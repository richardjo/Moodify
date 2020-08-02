//
//  User.swift
//  MoodMusicPlayer
//
//  Created by Richard Jo on 7/29/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/* User
    - Manages user's auth. credentials (OAuth Token).
    - Retrieves, parses and stores user's artist/track data asynchronously using Spotify API network calls.
    - Computes and returns user's top songs/tracks using a simple algorithm.
 */
class User {
    
    //Stores user's authentication token
    let accessToken:String!
    //Stores user's top artists
    var topArtistsIDs = [String]()
    //Stores user's top songs (and associated metadata, e.g. the ID, artists, etc)
    var topSongs = [Track]()
    //Stores user's top songs properties (e.g. tempo, key, energy, danceability, etc)
    var topSongsProperties = [String:[String:Any]]()
    
    //Retrieves matching songs from user song data based on "danceability" and "energy"
    func retrieveMatchingSongs(danceability:Float, energy:Float) -> [Track] {
        let matchingSongs = topSongs.filter({ (track) -> Bool in
            if let trackProperties = self.topSongsProperties[track.ID] {
                let trackEnergy = trackProperties["energy"] as! Float
                let trackDanceability = trackProperties["danceability"] as! Float
                if abs(trackEnergy - energy) < 0.15 || abs(trackDanceability - danceability) < 0.20 {
                    return true
                }
            }
            return false
        })
        return matchingSongs
    }
    
    //Retrieves user data
    func retrieveUserData(danceability:Float, energy:Float) {
        //Uses semaphore to manage storage for shared user data resources (i.e. for shared top songs array) and ensures data retrieval occurs in-order.\
        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .utility)
        dispatchQueue.async {
            self.retrieveTopArtists(completion: { semaphore.signal() })
            semaphore.wait()
            self.retrieveTopSongs(completion: { semaphore.signal() })
            semaphore.wait()
            self.retrieveTopSongsProperties(completion: { semaphore.signal() })
            semaphore.wait()
            self.retrieveTopArtistsSongs(completion: { semaphore.signal() })
            semaphore.wait()
            self.retrieveTopSongsProperties(completion: { semaphore.signal() })
            semaphore.wait()
            self.retrieveRecommendedSongs(completion: { semaphore.signal() }, danceability: danceability, energy: energy)
            semaphore.wait()
            self.retrieveTopSongsProperties(completion: { semaphore.signal() })
            semaphore.wait()
            //Notifies login view controller that user data has been successfully fetched
            DispatchQueue.main.async {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "userDataDidLoadNotification")))
            }
        }
    }
    
    //Retrieves user's top artists
    private func retrieveTopArtists(completion: @escaping ()->()) {
        let headers:HTTPHeaders = [.authorization(bearerToken: accessToken)]
        let parameters = ["time_range":"medium_term", "limit":"25"]
        //Makes network request for user's top 50 artists over a 6 month timeframe
        AF.request("https://api.spotify.com/v1/me/top/artists", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                //Parses response JSON and stores top artist IDs
                let topArtistsJSON = JSON(value)
                self.topArtistsIDs = self.parseTopArtistsJSON(data: topArtistsJSON)
                completion()
            case .failure:
                break
            }
        }
    }
    
    //Retrieves user's top songs
    private func retrieveTopSongs(completion: @escaping ()->()){
        let headers:HTTPHeaders = [.authorization(bearerToken: accessToken)]
        let parameters = ["time_range":"medium_term", "limit":"50"]
        //Makes network request for user's top 50 songs over a 6 month timeframe
        AF.request("https://api.spotify.com/v1/me/top/tracks", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                //Parses response JSON and stores top songs (and associated song metadata)
                let topSongsJSON = JSON(value)
                self.topSongs = self.parseTopSongsJSON(data: topSongsJSON)
                completion()
            case .failure:
                completion()
                break
            }
        }
    }
    
    //Retrieves top songs from user's top artists
    private func retrieveTopArtistsSongs(completion: @escaping ()->()){
        let headers:HTTPHeaders = [.authorization(bearerToken: accessToken)]
        let parameters:Parameters = ["country":"US"]
        //Makes network request for the top songs of the user's favorite artists
        let dispatchGroup = DispatchGroup()
        let _ = self.topArtistsIDs.map { (artistID) in
            dispatchGroup.enter()
            AF.request("https://api.spotify.com/v1/artists/\(artistID)/top-tracks", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    //Parses response JSON and stores top songs (and associated song metadata)
                    let artistsTopSongsJSON = JSON(value)
                    var artistsTopSongs = self.parseArtistsTopSongsJSON(data: artistsTopSongsJSON)
                    //Ensures that there are no duplicates with the user's top 50 songs
                    artistsTopSongs = artistsTopSongs.filter { (track) -> Bool in
                        self.topSongsProperties[track.ID] == nil
                    }
                    self.topSongs += artistsTopSongs
                    dispatchGroup.leave()
                case .failure:
                    dispatchGroup.leave()
                    break
                }
            }
        }
        dispatchGroup.notify(queue: .global(qos: .utility)) { completion() }
    }
    
    //Retrieves song properties (e.g. tempo, key, etc) of user's top songs
    private func retrieveTopSongsProperties(completion: @escaping ()->()){
        let dispatchGroup = DispatchGroup()
        let _ = self.topSongs.map { (song) in
            dispatchGroup.enter()
            let ID = song.ID
            let headers:HTTPHeaders = [.authorization(bearerToken: accessToken)]
            AF.request("https://api.spotify.com/v1/audio-features/\(ID)", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    //Parses response JSON and stores song properties by song ID
                    let songPropertiesJSON = JSON(value)
                    let songProperties = self.parseSongPropertiesJSON(data: songPropertiesJSON)
                    self.topSongsProperties[ID] = songProperties
                    dispatchGroup.leave()
                case .failure:
                    dispatchGroup.leave()
                    break
                }
            }
        }
        dispatchGroup.notify(queue: .global(qos: .utility)) { completion() }
    }
    
    /* Retriees user's recommended songs
        - Calculates recommendations by user provided energy and danceability song values
        - Generates 100 recommended songs by using a combination of:
            - A random selection of 2 of the user's top artists
            - User's top 3 artists
          as seeds.
     */
    private func retrieveRecommendedSongs(completion: @escaping ()->(), danceability: Float, energy: Float) {
        let headers:HTTPHeaders = [.authorization(bearerToken: accessToken)]
        let topArtistSeeds = getTopArtistsSeeds()
        let parameters:[String:Any] = ["limit":"100", "min_energy": energy - 0.05, "max_energy": energy + 0.05, "min_danceability": danceability - 0.075, "max_danceability": danceability + 0.075, "seed_artists": topArtistSeeds]
        AF.request("https://api.spotify.com/v1/recommendations", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                //Parses response JSON and stores Spotify recommended songs
                let recommendedSongsJSON = JSON(value)
                var recommendedSongs = self.parseRecommendedSongsJSON(data: recommendedSongsJSON)
                //Ensures that there are no duplicates with the user's top 50 songs
                recommendedSongs = recommendedSongs.filter { (track) -> Bool in
                    self.topSongsProperties[track.ID] == nil
                }
                self.topSongs += recommendedSongs
                completion()
            case .failure:
                completion()
                break
            }
        }
    }
    
    private func getTopArtistsSeeds() -> [String] {
        var topArtistsSeeds = [String]()
        for _ in 1...2 {
            let randomIndex = Int.random(in: 0..<topArtistsIDs.count)
            topArtistsSeeds.append(topArtistsIDs[randomIndex])
        }
        topArtistsSeeds.append(contentsOf: topArtistsIDs[0..<max(2, topArtistsIDs.count)])
        return topArtistsSeeds
    }
    
    private func parseTopArtistsJSON(data: JSON) -> [String] {
        let topArtistsJSON = data["items"].arrayValue
        let topArtistsIDs:[String] = topArtistsJSON.map { (data) -> String in
            return data["id"].stringValue
        }
        return topArtistsIDs
    }

    
    private func parseTopSongsJSON(data: JSON) -> [Track] {
        let topSongsJSON = data["items"].arrayValue
        let topSongs: [Track] = topSongsJSON.map { (data) -> Track in
            let name = data["name"].stringValue
            let URI = data["uri"].stringValue
            let ID = data["id"].stringValue
            let album = data["album"].stringValue
            let artists:[Artist] = data["artists"].map { (_, data) -> Artist in
                let name = data["name"].stringValue
                let ID = data["id"].stringValue
                let URI = data["uri"].stringValue
                return Artist(name: name, URI: URI, ID: ID)
            }
            return Track(name: name, URI: URI, ID: ID, album: album, artists: artists)
        }
        return topSongs
    }
    
    private func parseArtistsTopSongsJSON(data: JSON) -> [Track] {
        let artistsTopSongsJSON = data["tracks"].arrayValue
        let artistsTopSongs: [Track] = artistsTopSongsJSON.map { (data) -> Track in
            let name = data["name"].stringValue
            let URI = data["uri"].stringValue
            let ID = data["id"].stringValue
            let album = data["album"].stringValue
            let artists:[Artist] = data["artists"].map { (_, data) -> Artist in
                let name = data["name"].stringValue
                let ID = data["id"].stringValue
                let URI = data["uri"].stringValue
                return Artist(name: name, URI: URI, ID: ID)
            }
            return Track(name: name, URI: URI, ID: ID, album: album, artists: artists)
        }
        return artistsTopSongs
    }
    
    private func parseSongPropertiesJSON(data: JSON) -> [String: Any] {
        let danceability = data["danceability"].floatValue
        let energy = data["energy"].floatValue
        let tempo = data["tempo"].floatValue
        let key = data["key"].intValue
        let songProperties:[String:Any] = ["danceability": danceability, "energy": energy, "tempo": tempo, "key": key]
        return songProperties
    }
    
    private func parseRecommendedSongsJSON(data: JSON) -> [Track] {
        let recommendedSongsJSON = data["tracks"].arrayValue
        let recommendedSongs: [Track] = recommendedSongsJSON.map { (data) -> Track in
            let name = data["name"].stringValue
            let URI = data["uri"].stringValue
            let ID = data["id"].stringValue
            let album = data["album"].stringValue
            let artists:[Artist] = data["artists"].map { (_, data) -> Artist in
                let name = data["name"].stringValue
                let ID = data["id"].stringValue
                let URI = data["uri"].stringValue
                return Artist(name: name, URI: URI, ID: ID)
            }
            return Track(name: name, URI: URI, ID: ID, album: album, artists: artists)
        }
        return recommendedSongs
    }
    
    init(accessToken:String){
        self.accessToken = accessToken
    }
}

/* Track
    - Stores individual track information
 */
struct Track {
    var name = String()
    var URI = String()
    var ID = String()
    var album = String()
    var artists = [Artist]()
}

/* Artist
   - Stores individual artist information
*/
struct Artist {
    var name = String()
    var URI = String()
    var ID = String()
}
