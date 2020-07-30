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

class User {
    
    let accessToken:String!
    
    var topArtistsURIs = [String]()
    
    func retrieveTopArtists(){
        let headers:HTTPHeaders = [.authorization(bearerToken: accessToken)]
        let parameters = ["time_range":"medium_term", "limit":"50"]
        AF.request("https://api.spotify.com/v1/me/top/artists", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                let topArtistsJSON = JSON(value)
                self.topArtistsURIs = self.parseTopArtists(data: topArtistsJSON)
            case .failure:
                self.topArtistsURIs = []
            }
        }
    }
    
    private func parseTopArtists(data: JSON) -> [String] {
        let topArtistsJSON = data["items"].arrayValue
        let topArtistsURIs:[String] = topArtistsJSON.map { (data) -> String in
            return data["uri"].stringValue
        }
        return topArtistsURIs
    }
    
    init(accessToken:String){
        self.accessToken = accessToken
    }
}
