//
//  MoodSelectorViewController.swift
//  MoodMusicPlayer
//
//  Created by Richard Jo on 7/31/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit

class MoodSelectorViewController: UIViewController {
    
    var user: User!
    @IBOutlet weak var moodSelectionView: UIView!
    var moodSelectionGradientLayer: CAGradientLayer!
    var moodSelectorView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    var activityIndicatorViewController = ActivityIndicatorViewController()
    var moodData: (Float, Float)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMoodSelectionView()
        setupMoodSelectorView()
        setupNextButton()
        setupDataDidLoadNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver("userDataDidLoadNotification")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moodSelectionGradientLayer.frame = moodSelectionView.bounds
    }
    
    @IBAction func nextButtonDidTouch(_ sender: UIButton) {
        moodData = retrieveMoodInput()
        user.retrieveUserData(danceability: moodData.1, energy: moodData.0)
        present(activityIndicatorViewController, animated: false, completion: nil)
        activityIndicatorViewController.startActivityIndicator()
    }
    
    func retrieveMoodInput() -> (Float, Float) {
        let energy = Float(moodSelectorView.center.x / moodSelectionView.frame.width)
        let danceability = Float((moodSelectionView.frame.height - moodSelectorView.center.y) / moodSelectionView.frame.height)
        return (energy, danceability)
    }
    
    func setupDataDidLoadNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidLoad), name: NSNotification.Name("userDataDidLoadNotification"), object: nil)
    }
    
    @objc func userDataDidLoad() {
        activityIndicatorViewController.stopActivityIndicator()
        dismiss(animated: false, completion: nil)
        performSegue(withIdentifier: "suggestionsSegue", sender: moodData)
    }

    func setupMoodSelectionView(){
        moodSelectionGradientLayer = CAGradientLayer()
        moodSelectionGradientLayer.frame = moodSelectionView.bounds
        let color1 = UIColor(red: 250/255, green: 87/255, blue: 75/255, alpha: 1)
        let color2 = UIColor(red: 75/255, green: 150/255, blue: 250/255, alpha: 1)
        moodSelectionGradientLayer.colors = [color1.cgColor, color2.cgColor]
        moodSelectionGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        moodSelectionGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        moodSelectionView.layer.insertSublayer(moodSelectionGradientLayer, at: 0)
    }
    
    func setupMoodSelectorView(){
        moodSelectorView = UIView()
        moodSelectionView.addSubview(moodSelectorView)
        moodSelectorView.translatesAutoresizingMaskIntoConstraints = false
        moodSelectorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        moodSelectorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        moodSelectorView.centerXAnchor.constraint(equalTo: moodSelectionView.centerXAnchor).isActive = true
        moodSelectorView.centerYAnchor.constraint(equalTo: moodSelectionView.centerYAnchor).isActive = true
        moodSelectorView.backgroundColor = UIColor.clear
        moodSelectorView.alpha = 0.80
        moodSelectorView.layer.cornerRadius = 15
        moodSelectorView.layer.masksToBounds = true
        moodSelectorView.layer.borderWidth = 5
        moodSelectorView.layer.borderColor = UIColor.white.cgColor
        moodSelectorView.layer.shadowRadius = 3
        moodSelectorView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        moodSelectorView.layer.shadowColor = UIColor.black.cgColor
        moodSelectorView.layer.shadowOpacity = 0.75
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moodSelectorViewDidDrag(_:)))
        moodSelectorView.addGestureRecognizer(panGesture)
        moodSelectorView.isUserInteractionEnabled = true
    }
    
    func setupNextButton(){
        nextButton.layer.cornerRadius = 21
    }
    
    @objc func moodSelectorViewDidDrag(_ sender:UIPanGestureRecognizer) {
        view.bringSubviewToFront(moodSelectorView)
        let translation = sender.translation(in: moodSelectionView)
        let destination = CGPoint(x: moodSelectorView.center.x + translation.x, y: moodSelectorView.center.y + translation.y)
        //Ensures selector doesn't go out of bounds of the selection view
        if moodSelectionView.bounds.contains(destination) { moodSelectorView.center = destination }
        sender.setTranslation(CGPoint(x: 0, y: 0), in: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SuggestionsViewController {
            if let sender = sender as? (Float, Float) {
                segue.destination.modalPresentationStyle = .fullScreen
                destination.user = user
                destination.energy = sender.0
                destination.danceability = sender.1
            }
        }
    }

}
