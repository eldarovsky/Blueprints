//
//  SceneDelegate.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 07.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if let window {
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.start()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        StorageManager.shared.saveContext()
    }
}
