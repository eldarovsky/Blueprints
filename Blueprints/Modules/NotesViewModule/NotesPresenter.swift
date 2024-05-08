//
//  NotesPresenter.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 08.05.2024.
//

import Foundation

protocol NotesPresenterProtocol {
    func fetchData()
    func numberOfNotes() -> Int
    func note(at indexPath: IndexPath) -> Note
    func deleteNote(at indexPath: IndexPath)
    func addNoteButtonTapped()
}

class NotesPresenter {
    weak var view: NotesViewControllerProtocol?
    private let storageManager = StorageManager.shared
    private var notes: [Note] = []
}

extension NotesPresenter: NotesPresenterProtocol {
    func fetchData() {
        storageManager.fetch { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notes):
                self.notes = notes
                self.view?.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        notes.sort { $0.date ?? Date() > $1.date ?? Date() }
    }
    
    func numberOfNotes() -> Int {
        notes.count
    }
    
    func note(at indexPath: IndexPath) -> Note {
        return notes[indexPath.row]
    }
    
    func deleteNote(at indexPath: IndexPath) {
        let note = notes[indexPath.row]
        storageManager.delete(note: note)
        
        notes.remove(at: indexPath.row)
    }
    
    func addNoteButtonTapped() {
        view?.showAddNoteView()
    }
}
