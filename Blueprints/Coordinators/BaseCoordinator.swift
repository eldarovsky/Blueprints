//
//  BaseCoordinator.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 07.05.2024.
//

import Foundation

class BaseCoordinator: CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    
    func start() {
        fatalError("Child should implement func Start")
    }
}
