//
//  NoteViewControllerCoordinator.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 08.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit

// MARK: - Note view controller coordinator

/// Coordinator responsible for managing the navigation flow from the note view controller.
final class NoteViewControllerCoordinator: BaseCoordinator {
    
    // MARK: - Private properties
    
    /// Navigation controller used for navigation.
    private var navigationController: UINavigationController
    
    // MARK: - Initializers
    
    /// Initializes the coordinator with the given navigation controller.
    /// - Parameter navigationController: The navigation controller used for navigation.
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public methods
    
    /// Starts the coordinator and presents the note view controller.
    override func start() {
        let noteViewController = NoteViewController()
//        let presenter = NotePresenter()
//        
//        noteViewController.presenter = presenter
//        presenter.view = noteViewController
        
        noteViewController.noteViewControllerCoordinator = self
        navigationController.pushViewController(noteViewController, animated: true)
    }
}
