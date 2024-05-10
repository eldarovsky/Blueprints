//
//  NotesPresenter.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 08.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

// MARK: - Notes presenter protocol

/// Protocol defining methods to be implemented by the notes presenter.
protocol NotesPresenterProtocol {
    
    /// Fetches notes from the storage manager.
    func fetchNotes()
    
    /// Returns the number of notes.
    /// - Returns: The number of notes.
    func numberOfNotes() -> Int
    
    /// Returns the note at the specified index path.
    /// - Parameter indexPath: The index path of the note.
    /// - Returns: The note at the specified index path.
    func note(at indexPath: IndexPath) -> Note
    
    /// Deletes the note at the specified index path.
    /// - Parameter indexPath: The index path of the note to delete.
    func deleteNote(at indexPath: IndexPath)
    
    /// Updates the label displaying the count of notes.
    /// - Returns: The text to display on the label.
    func updateNotesCounterLabel() -> String
}

// MARK: - Notes presenter

/// Presenter responsible for managing notes.
final class NotesPresenter {
    
    // MARK: - Public properties
    
    /// View associated with the presenter.
    weak var view: NotesViewControllerProtocol?
    
    // MARK: - Private properties
    
    /// Storage manager for managing notes data.
    private let storageManager = StorageManager.shared

    /// Array containing the notes.
    private var notes: [Note] = []
}

// MARK: - Notes presenter protocol methods

extension NotesPresenter: NotesPresenterProtocol {
    func fetchNotes() {
        storageManager.fetch { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notes):
                self.notes = notes.sorted { $0.date ?? Date() > $1.date ?? Date() }
                self.view?.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func numberOfNotes() -> Int {
        notes.count
    }
    
    func note(at indexPath: IndexPath) -> Note {
        notes[indexPath.row]
    }
    
    func deleteNote(at indexPath: IndexPath) {
        let note = notes[indexPath.row]
        storageManager.delete(note: note)
        
        notes.remove(at: indexPath.row)
        view?.deleteRow(at: indexPath)
    }
    
    func updateNotesCounterLabel() -> String {
        if notes.count <= 1 {
            return "\(notes.count) note"
        } else {
            return "\(notes.count) notes"
        }
    }
}
