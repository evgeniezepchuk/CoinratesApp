//
//  SceneDelegate.swift
//  CoinRates
//
//  Created by Евгений Езепчук on 27.07.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let widnowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: widnowScene)
        window?.rootViewController = UINavigationController(rootViewController: GetStartedViewController())
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

