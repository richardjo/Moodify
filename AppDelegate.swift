//
//  AppDelegate.swift
//  MoodMusicPlayer
//
//  Created by Richard Jo on 7/29/20.
//  Copyright © 2020 Richard Jo. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var signInViewController: SignInViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let signInStoryboard = UIStoryboard(name: "Main", bundle: nil)
        signInViewController = signInStoryboard.instantiateInitialViewController()
        window?.rootViewController = signInViewController
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let signInStoryboard = UIStoryboard(name: "Main", bundle: nil)
        signInViewController = signInStoryboard.instantiateInitialViewController() as! SignInViewController
        signInViewController.sessionManager.application(app, open: url, options: options)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

