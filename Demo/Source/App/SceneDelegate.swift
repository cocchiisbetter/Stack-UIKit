// Copyright © 2024 Cocchi is better. All rights reserved.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = scene as? UIWindowScene {
            window = .init(windowScene: windowScene)
            window?.rootViewController = UINavigationController(
                rootViewController: HomeViewController()
            )
            window?.makeKeyAndVisible()
        }
    }
}
