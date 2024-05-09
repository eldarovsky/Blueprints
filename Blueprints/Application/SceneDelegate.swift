//
//  SceneDelegate.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 07.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    private let storageManager: StorageManagerProtocol = StorageManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if let window {
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.start()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        storageManager.saveContext()
    }
}
