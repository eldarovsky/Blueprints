//
//  AddNotePresenter.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 09.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

protocol AddNotePresenterProtocol {
    func save(text: String, ofNote: Note?)
}

final class AddNotePresenter {
    weak var view: AddNoteViewControllerProtocol?
    private let storageManager: StorageManagerProtocol = StorageManager()
}

extension AddNotePresenter: AddNotePresenterProtocol {
    func save(text: String, ofNote note: Note?) {
        let lines = text.components(separatedBy: "\n")
        guard let title = lines.first else { return }
        let fullText = lines.joined(separator: " ")
        guard !fullText.isEmpty else { return }

        if let existingNote = note {
            storageManager.update(note: existingNote, title: title, text: fullText)
        } else {
            storageManager.create(title: title, text: fullText)
        }
    }
}
