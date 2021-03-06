//
//  SuggestionsViewController.swift
//  MoodMusicPlayer
//
//  Created by Richard Jo on 8/1/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit

class SuggestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user:User!
    var energy:Float!
    var danceability:Float!
    
    @IBOutlet weak var suggestionsTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    var matchingSongs: [Track]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNextButton()
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        matchingSongs = user.retrieveMatchingSongs(danceability: danceability, energy: energy)
    }
    
    func setupNextButton(){
        nextButton.layer.cornerRadius = 21
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingSongs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "songInformationSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionTableViewCell")!
        
        if let suggestionTableViewCell = cell as? SuggestionTableViewCell {
            let track = matchingSongs[indexPath.row]
            let album = track.album
            let artist = track.artists
            let songTitle = track.name
            suggestionTableViewCell.albumLabel.text = album
            suggestionTableViewCell.artistLabel.text = artist[0].name
            suggestionTableViewCell.songTitleLabel.text = songTitle
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SongInformationViewController {
            if let indexPath = sender as? IndexPath {
                destination.track = matchingSongs[indexPath.row]
            }
        }
    }
}
