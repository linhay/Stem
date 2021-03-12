//
//  SceneDelegate.swift
//  iOSApp
//
//  Created by 林翰 on 2021/3/1.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: HomeViewController())
            self.window = window
            window.makeKeyAndVisible()
        }
    }

}

