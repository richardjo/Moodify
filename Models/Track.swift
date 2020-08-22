//
//  Track.swift
//  MoodMusicPlayer
//
//  Created by Richard Jo on 8/18/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import Foundation

/* Track
    - Stores individual track information
 */
struct Track {
    var name = String()
    var URI = String()
    var ID = String()
    var album = String()
    var artists = [Artist]()
    var previewURL = String()
    var albumImageURL = String()
}
