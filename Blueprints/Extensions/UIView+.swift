//
//  UIView+.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 07.05.2024.
//

import UIKit

extension UIView {
    
    /// Method for adding subviews
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    /// Method for disabling autoresizing mask
    func disableAutoresizingMask(_ views: UIView...) {
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}
