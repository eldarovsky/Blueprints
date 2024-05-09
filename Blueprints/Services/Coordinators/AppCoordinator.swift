//
//  AppCoordinator.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 07.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit

// MARK: - App coordinator

/// Coordinates the flow of the application.
final class AppCoordinator: BaseCoordinator {

    // MARK: - Private properties

    /// The window used to display the app's interface.
    private var window: UIWindow

    /// The navigation controller managing the app's navigation stack.
    private var navigationController = UINavigationController()

    // MARK: - Initializers

    /// Initializes the coordinator with a window.
    /// - Parameter window: The application's window.
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }

    // MARK: - Public methods

    /// Starts the application flow.
    override func start() {
        let notesViewControllerCoordinator = NotesViewControllerCoordinator(navigationController: navigationController)
        add(coordinator: notesViewControllerCoordinator)
        notesViewControllerCoordinator.start()
    }
}
