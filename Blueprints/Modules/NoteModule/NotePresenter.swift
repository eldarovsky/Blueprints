//
//  NotePresenter.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 09.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

// MARK: - Note presenter protocol

/// Protocol defining methods to be implemented by the note presenter.
protocol NotePresenterProtocol {
    
    /// Saves the text of the note.
    /// - Parameters:
    ///   - text: The text content of the note.
    ///   - note: The note object to be updated. If nil, a new note will be created.
    func save(text: String, ofNote: Note?)
}

// MARK: - Note presenter

/// Presenter responsible for managing notes.
final class NotePresenter {
    
    // MARK: - Public properties
    
    /// View associated with the presenter.
    weak var view: NoteViewControllerProtocol?
    
    // MARK: - Private properties
    
    /// Storage manager for managing notes data.
    private let storageManager = StorageManager.shared
}

// MARK: - Note presenter protocol methods

extension NotePresenter: NotePresenterProtocol {
    func save(text: String, ofNote note: Note?) {
        if let existingNote = note {
            storageManager.update(text: text, ofNote: existingNote)
        } else {
            storageManager.create(text: text)
        }
    }
}
