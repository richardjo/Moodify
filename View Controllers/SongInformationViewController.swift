//
//  SongInformationViewController.swift
//  MoodMusicPlayer
//
//  Created by Richard Jo on 8/18/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit
import AVFoundation

class SongInformationViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songInformationView: UIView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    var track: Track!
    var songPreviewPlayer: AVAudioPlayer?
    @IBOutlet weak var songPreviewProgressBar: UIProgressView!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupSongInformationView()
        setupSongInformationLabels()
        setupAlbumImage()
        setupSongPreviewProgressBar()
        setupPlayButton()
    }
    
    @IBAction func playButtonDidTouch(_ sender: UIButton) {
        if songPreviewPlayer == nil {
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let strongSelf = self else { return }
                do {
                    let data = try Data(contentsOf: URL(string: strongSelf.track.previewURL)!)
                    strongSelf.songPreviewPlayer = try AVAudioPlayer(data: data)
                    strongSelf.songPreviewPlayer?.play()
                    DispatchQueue.main.async { strongSelf.updateSongPreviewProgressBar() }
                } catch {
                    //
                }
            }
        } else {
            if songPreviewPlayer!.isPlaying {
                songPreviewPlayer!.pause()
            } else {
                songPreviewPlayer!.play()
            }
        }
    }
    
    func setupPlayButton(){
        playButton.layer.cornerRadius = playButton.frame.width / 2
    }
    func setupSongPreviewProgressBar(){
        songPreviewProgressBar.progress = 0
    }
    
    func updateSongPreviewProgressBar() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.songPreviewProgressBar.progress = Float(strongSelf.songPreviewPlayer!.currentTime / strongSelf.songPreviewPlayer!.duration)
            })
            timer?.fire()
        }
    }
    
    func setupAlbumImage(){
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            do {
                let data = try Data(contentsOf: URL(string: strongSelf.track.albumImageURL)!)
                let albumImage = UIImage(data: data)
                DispatchQueue.main.async {
                    strongSelf.albumImageView.image = albumImage
                }
            } catch {
                //
            }
        }
    }
    
    func setupSongInformationLabels(){
        songTitleLabel.text = track.name
        artistLabel.text = track.artists[0].name
        albumLabel.text = track.album
    }
    
    func setupBackgroundView(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissSongInformationView))
        backgroundView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setupSongInformationView(){
        songInformationView.layer.cornerRadius = 17
    }
    
    @objc func dismissSongInformationView() {
        songPreviewPlayer?.stop()
        timer?.invalidate()
        dismiss(animated: true, completion: nil)
    }

}
