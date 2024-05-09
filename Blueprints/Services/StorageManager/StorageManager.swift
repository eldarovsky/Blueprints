//
//  StorageManager.swift
//  TaskList
//
//  Created by Eldar Abdullin on 17.09.2023.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import CoreData

// MARK: - Storage manager protocol

/// Protocol defining methods for managing notes storage.
protocol StorageManagerProtocol {

    /// Creates a new note with the given title and text.
    /// - Parameters:
    ///   - title: The title of the note.
    ///   - text: The text content of the note.
    func create(title: String, text: String?)

    /// Fetches all notes from the storage.
    /// - Parameter completion: Completion block returning a result with an array of notes or an error.
    func fetch(completion: (Result<[Note], Error>) -> Void)

    /// Updates the given note with new title and text.
    /// - Parameters:
    ///   - note: The note to be updated.
    ///   - title: The new title for the note.
    ///   - text: The new text content for the note.
    func update(note: Note, title: String, text: String?)

    /// Deletes the given note from the storage.
    /// - Parameter note: The note to be deleted.
    func delete(note: Note)

    /// Saves changes to the storage context.
    func saveContext()
}

// MARK: - Storage manager

/// Manages storage for notes using CoreData.
final class StorageManager {

    // MARK: - Private properties

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Note")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private let viewContext: NSManagedObjectContext

    // MARK: - Initializers

    /// Initializes a new instance of `StorageManager`.
    init() {
        viewContext = persistentContainer.viewContext
    }
}

// MARK: - CRUD methods

extension StorageManager: StorageManagerProtocol {

    func create(title: String, text: String?) {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.date = Date()
        note.title = title
        note.text = text
        saveContext()
    }

    func fetch(completion: (Result<[Note], Error>) -> Void) {
        let fetchRequest = Note.fetchRequest()

        do {
            let notes = try viewContext.fetch(fetchRequest)
            completion(.success(notes))
        } catch let error {
            completion(.failure(error))
        }
    }

    func update(note: Note, title: String, text: String?) {
        note.date = Date()
        note.title = title
        note.text = text
        saveContext()
    }

    func delete(note: Note) {
        viewContext.delete(note)
        saveContext()
    }

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
