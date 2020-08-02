//
//  ViewController.swift
//  MoodMusicPlayer
//
//  Created by Richard Jo on 7/29/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, SPTSessionManagerDelegate {
    
    var accessToken:String?
    var user:User!
    
    //MARK: - Configuration
    
    lazy var configuration:SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: Constants.SpotifyClientID, redirectURL: Constants.SpotifyRedirectURL)
        return configuration
    }()

    lazy var sessionManager: SPTSessionManager = {
        return SPTSessionManager(configuration: configuration, delegate: self)
    }()
    
    //MARK: - Session Manager Delegate Methods
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        user = User(accessToken: session.accessToken)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "moodSelectorSegue", sender: nil)
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        //
    }
    

    //MARK: - Sign In View Controller Logic

    var moodifyLabel: UILabel!
    var descriptionLabel: UILabel!
    var labelsStackView: UIStackView!
    var labelsStackViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signInButtonDidTouch(_ sender: UIButton) {
        //Authenticates user
        let requestedScopes: SPTScope = [.appRemoteControl, .playlistModifyPrivate, .playlistModifyPublic, .userTopRead]
        sessionManager.initiateSession(with: requestedScopes, options: .default)
    }
    
    func setupSignInButton() {
        signInButton.layer.cornerRadius = 21
    }
    
    func setupLabels(){
        moodifyLabel = UILabel()
        descriptionLabel = UILabel()
        moodifyLabel.text = "Moodify"
        descriptionLabel.text = "Personal DJ for your mood based on your listening history."
        moodifyLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        moodifyLabel.textColor = UIColor.white
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.numberOfLines = 0
        moodifyLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
        labelsStackView = UIStackView(arrangedSubviews: [moodifyLabel, descriptionLabel])
        labelsStackView.alignment = .center
        labelsStackView.axis = .vertical
        view.addSubview(labelsStackView)
    }
       
    func layoutLabels(){
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        labelsStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        labelsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelsStackViewCenterYConstraint = labelsStackView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        labelsStackViewCenterYConstraint.isActive = true
    }
    
    func animateLabels(){
        descriptionLabel.alpha = 0
        signInButton.alpha = 0
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.labelsStackViewCenterYConstraint.constant = self.view.center.y
            self.labelsStackView.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1.5) {
                self.descriptionLabel.alpha = 1
                self.signInButton.alpha = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupSignInButton()
        layoutLabels()
        animateLabels()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MoodSelectorViewController {
            segue.destination.modalPresentationStyle = .fullScreen
            destination.user = user
        }
     }
}

