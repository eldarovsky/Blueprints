//
//  NotesViewControllerCoordinator.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 08.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit

// MARK: - Notes view controller coordinator

/// Coordinator responsible for managing the navigation flow from the notes view controller.
final class NotesViewControllerCoordinator: BaseCoordinator {
    
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
    
    /// Starts the coordinator and presents the notes view controller.
    override func start() {
        let notesViewController = NotesViewController()
        let presenter = NotesPresenter()
        
        notesViewController.presenter = presenter
        presenter.view = notesViewController
        
        notesViewController.notesViewControllerCoordinator = self
        navigationController.pushViewController(notesViewController, animated: true)
    }
    
    /// Initiates the coordinator for adding notes.
    func runNote(note: Note? = nil) {
        removeAllChildCoordinators()
        
        let noteViewControllerCoordinator = NoteViewControllerCoordinator(
            navigationController: navigationController,
            note: note
        )
        
        add(coordinator: noteViewControllerCoordinator)
        noteViewControllerCoordinator.start()
    }
}
