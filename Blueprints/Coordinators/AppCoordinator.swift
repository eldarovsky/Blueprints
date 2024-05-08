//
//  AppCoordinator.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 07.05.2024.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private var window: UIWindow
    
    private var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        
        // Здесь можно настроить navigationController

        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    override func start() {
        let notesViewControllerCoordinator = NotesViewControllerCoordinator(navigationController: navigationController)
        add(coordinator: notesViewControllerCoordinator)
        notesViewControllerCoordinator.start()
    }
}
