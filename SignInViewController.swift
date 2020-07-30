//
//  ViewController.swift
//  MoodMusicPlayer
//
//  Created by Richard Jo on 7/29/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, SPTAppRemoteDelegate, SPTSessionManagerDelegate {
    
    var accessToken:String?
    
    //MARK: - Configuration
    
    lazy var configuration:SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: Constants.SpotifyClientID, redirectURL: Constants.SpotifyRedirectURL)
        return configuration
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    lazy var sessionManager: SPTSessionManager = {
        return SPTSessionManager(configuration: configuration, delegate: self)
    }()
    
    //MARK: - Session Manager and App Remote Delegate Methods
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        let user = User(accessToken: session.accessToken)
        user.retrieveTopArtists()
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("yuh")
    }
    
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        //
    }
       
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        //
    }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        appRemote.playerAPI?.pause(nil)
        let user = User(accessToken: accessToken!)
        user.retrieveTopArtists()
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        //
    }
    
    //MARK: - Sign In View Controller Logic
    
    @IBAction func signInButtonDidTouch(_ sender: UIButton) {
        //Authenticates user
        let requestedScopes: SPTScope = [.appRemoteControl, .playlistModifyPrivate, .playlistModifyPublic, .userTopRead]
        sessionManager.initiateSession(with: requestedScopes, options: .default)
        //appRemote.authorizeAndPlayURI("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let name = Notification.Name(Constants.SignInNotificationID)
//        NotificationCenter.default.addObserver(self, selector: #selector(signInDidComplete(_:)), name: name, object: nil)
    }
    
//    deinit {
//        //NotificationCenter.default.removeObserver(self)
//    }
    
//    //Stores local auth token and connects to Spotify app
//    @objc func signInDidComplete(_ notification:NSNotification) {
//        guard let signInURL = notification.object as? URL else { return }
//        let parameters = appRemote.authorizationParameters(from: signInURL)
//        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
//            appRemote.connectionParameters.accessToken = accessToken
//            self.accessToken = accessToken
//            appRemote.connect()
//        }
//    }

}

