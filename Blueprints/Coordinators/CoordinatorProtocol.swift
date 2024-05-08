//
//  CoordinatorProtocol.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 07.05.2024.
//

import Foundation

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    func start ()
}

extension CoordinatorProtocol {
    func add(coordinator: CoordinatorProtocol) {
        childCoordinators.append (coordinator)
    }
    
    func remove(coordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
