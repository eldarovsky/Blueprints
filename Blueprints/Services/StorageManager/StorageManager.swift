//
//  StorageManager.swift
//  TaskList
//
//  Created by Eldar Abdullin on 17.09.2023.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import CoreData

// MARK: - Storage manager

/// Manages storage for notes using CoreData.
final class StorageManager {

    // MARK: - Public properties

    /// Storage manager access point.
    static let shared = StorageManager()

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

    /// Initializes a new instance of StorageManager.
    private init() {
        viewContext = persistentContainer.viewContext
    }

    // MARK: - Public methods

    func create(text: String?) {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.date = Date()
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

    func update(text: String?, ofNote note: Note) {
        note.date = Date()
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
