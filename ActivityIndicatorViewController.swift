//
//  ActivityIndicatorViewController.swift
//  MoodMusicPlayer
//
//  Created by Richard Jo on 8/1/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    func startActivityIndicator(){
        activityIndicatorView.startAnimating()
    }
    
    func stopActivityIndicator(){
        activityIndicatorView.stopAnimating()
    }

    private func setupBackgroundView() {
        view.backgroundColor = UIColor.black
        view.alpha = 0.20
    }
    
    private func setupActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = UIColor.white
        activityIndicatorView.style = .large
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupActivityIndicatorView()
    }
}
