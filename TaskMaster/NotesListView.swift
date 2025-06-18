//
//  NotesListView.swift
//  TaskMaster
//
//  Created by Vikas Hareram Shah on 18/06/25.
//

import SwiftUI
import CoreData

struct NotesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: NotesViewModel

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: NotesViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notes, id: \.objectID) { note in
                    NavigationLink {
                        NoteEditView(viewModel: viewModel, note: note)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(note.title ?? "Untitled")
                                .font(.headline)
                            Text(note.body ?? "")
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteNote)
            }
            .navigationTitle("My Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sort by \(viewModel.sortByTitle ? "Date" : "Title")") {
                        viewModel.sortByTitle.toggle()
                        viewModel.fetchNotes()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        NoteEditView(viewModel: viewModel, note: nil)
                    } label: {
                        Text("Add")
                    }
                }
            }
        }
    }
}

