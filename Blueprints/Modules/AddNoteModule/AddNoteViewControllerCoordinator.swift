//
//  AddNoteViewControllerCoordinator.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 08.05.2024.
//

import UIKit

final class AddNoteViewControllerCoordinator: BaseCoordinator {

    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let addNoteViewController = AddNoteViewController()
        let presenter = AddNotePresenter()

        addNoteViewController.presenter = presenter
        presenter.view = addNoteViewController

        addNoteViewController.addNoteViewControllerCoordinator = self
        navigationController.pushViewController(addNoteViewController, animated: true)
    }
}
