//
//  BaseCoordinator.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 07.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

// MARK: - Base coordinator

/// The base coordinator class that provides a blueprint for coordinating navigation flows.
class BaseCoordinator: CoordinatorProtocol {
    
    // MARK: - Public properties
    
    /// An array containing child coordinators.
    var childCoordinators: [CoordinatorProtocol] = []
    
    // MARK: - Public methods
    
    /// Starts the coordination flow. This method should be overridden by subclasses.
    func start() {
        fatalError("Child should implement func Start")
    }
}
