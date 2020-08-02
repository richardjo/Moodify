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
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        matchingSongs = user.retrieveMatchingSongs(danceability: danceability, energy: energy)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionTableViewCell")!
        
        cell.textLabel?.text = matchingSongs[indexPath.row].name
        return cell
    }

}
