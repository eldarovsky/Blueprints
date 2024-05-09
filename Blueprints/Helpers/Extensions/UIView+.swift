//
//  UIView+.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 07.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit

// MARK: - UIView extension

extension UIView {

    /// Adds multiple subviews to the current view.
    /// - Parameter views: The views to be added as subviews.
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    /// Disables autoresizing mask translation for multiple views.
    /// - Parameter views: The views for which autoresizing mask translation should be disabled.
    func disableAutoresizingMask(_ views: UIView...) {
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}
