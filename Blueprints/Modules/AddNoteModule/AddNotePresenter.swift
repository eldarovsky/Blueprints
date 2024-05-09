//
//  AddNotePresenter.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 09.05.2024.
//

import Foundation

protocol AddNotePresenterProtocol {
    func save(text: String, ofNote: Note?)
}

final class AddNotePresenter {
    weak var view: AddNoteViewControllerProtocol?
}

extension AddNotePresenter: AddNotePresenterProtocol {
    func save(text: String, ofNote note: Note?) {
        let lines = text.components(separatedBy: "\n")
        guard let title = lines.first else { return }
        let fullText = lines.joined(separator: " ")
        guard !fullText.isEmpty else { return }

        if let existingNote = note {
            StorageManager.shared.update(note: existingNote, title: title, text: fullText)
        } else {
            StorageManager.shared.create(title: title, text: fullText)
        }
    }
}
