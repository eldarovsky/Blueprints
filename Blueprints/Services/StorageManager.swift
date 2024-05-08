//
//  StorageManager.swift
//  TaskList
//
//  Created by Эльдар Абдуллин on 17.09.2023.
//

import CoreData

// MARK: - class StorageManager

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    
    /// Creating persistent container
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Note")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    /// Creating viewContext
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    
    /// Метод создает новую заметку
    func create(title: String, text: String?) {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.date = Date()
        note.title = title
        note.text = text
        saveContext()
    }
    
    /// Метод извлечения данных из БД
    func fetch(completion: (Result<[Note], Error>) -> Void) {
        let fetchRequest = Note.fetchRequest()
        
        do {
            let notes = try viewContext.fetch(fetchRequest)
            completion(.success(notes))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    /// Метод обновляет заметку
    func update(note: Note, title: String, text: String?) {
        note.date = Date()
        note.title = title
        note.text = text
        saveContext()
    }
    
    /// Метод удаления заметки
    func delete(note: Note) {
        viewContext.delete(note)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    
    /// Метод сохранения контекста в БД
    func saveContext () {
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
