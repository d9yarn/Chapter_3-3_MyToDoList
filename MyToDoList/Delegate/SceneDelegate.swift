//
//  SceneDelegate.swift
//  MyToDoList
//
//  Created by t2023-m0045 on 2023/08/28.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        let rootViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)

        self.window?.rootViewController = navigationController
    }
}

