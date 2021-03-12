//
//  AppDelegate.swift
//  iOSApp
//
//  Created by 林翰 on 2021/3/1.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: HomeViewController())
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }



}

