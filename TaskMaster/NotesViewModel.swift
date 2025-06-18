//
//  NotesViewModel.swift
//  TaskMaster
//
//  Created by Aditya on 18/06/25.
//

import Foundation
import CoreData

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var sortByTitle = false

    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchNotes()
    }

    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        if sortByTitle {
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        } else {
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        }

        do {
            notes = try context.fetch(request)
        } catch {
            print("Error fetching notes: \(error)")
        }
    }

    func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            context.delete(notes[index])
        }
        saveContext()
        fetchNotes()
    }

    func addNote(title: String, body: String) {
        let note = Note(context: context)
        note.title = title
        note.body = body
        note.createdAt = Date()

        saveContext()
        fetchNotes()
    }

    func update(note: Note, title: String, body: String) {
        note.title = title
        note.body = body
        saveContext()
        fetchNotes()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }
}

