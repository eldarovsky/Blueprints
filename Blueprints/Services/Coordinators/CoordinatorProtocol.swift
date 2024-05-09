//
//  CoordinatorProtocol.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 07.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

// MARK: - Coordinator protocol

/// Protocol defining methods and properties required for a coordinator.
protocol CoordinatorProtocol: AnyObject {

    /// An array containing child coordinators.
    var childCoordinators: [CoordinatorProtocol] { get set }

    /// Starts the coordinator's navigation flow.
    func start ()
}

// MARK: - Coordinator protocol extension

extension CoordinatorProtocol {

    /// Adds a child coordinator to the list of child coordinators.
    /// - Parameter coordinator: The coordinator to be added.
    func add(coordinator: CoordinatorProtocol) {
        childCoordinators.append (coordinator)
    }
    
    /// Removes a child coordinator from the list of child coordinators.
    /// - Parameter coordinator: The coordinator to be removed.
    func remove(coordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
