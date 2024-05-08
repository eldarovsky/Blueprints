//
//  NotesViewControllerCoordinator.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 08.05.2024.
//

import UIKit

final class NotesViewControllerCoordinator: BaseCoordinator {
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let notesViewController = NotesViewController()
        let presenter = NotesPresenter()
        
        notesViewController.presenter = presenter
        presenter.view = notesViewController
        
        notesViewController.notesViewControllerCoordinator = self
        navigationController.pushViewController(notesViewController, animated: true)
    }
    
    func runAddNotes() {
        let addNoteViewControllerCoordinator = AddNoteViewControllerCoordinator(navigationController: navigationController)
        add(coordinator: addNoteViewControllerCoordinator)
        addNoteViewControllerCoordinator.start()
    }
}
