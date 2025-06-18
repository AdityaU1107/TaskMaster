//
//  NoteEditView.swift
//  TaskMaster
//
//  Created by Aditya on 18/06/25.
//

import SwiftUI
import CoreData

struct NoteEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var viewModel: NotesViewModel
    var note: Note?

    @State private var title: String = ""
    @State private var bodyText: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            // Header: Navigation Title + Cancel Button
            HStack {
                Text(note == nil ? "Add Note" : "Edit Note")
                    .font(.headline)
                    .padding()
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .padding()
            }
            

            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }

                Section(header: Text("Body")) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.clear, lineWidth: 0)
                        TextEditor(text: $bodyText)
                            .padding(8)
                            .frame(minHeight: 150, alignment: .top)
                            .scrollContentBackground(.hidden)
                    }
                }
            }

            // Save Button
            Button(action: {
                if let note = note {
                    viewModel.update(note: note, title: title, body: bodyText)
                } else {
                    viewModel.addNote(title: title, body: bodyText)
                }
                dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.top, 30)

            Spacer()
        }
        .onAppear {
            if let note = note {
                title = note.title ?? ""
                bodyText = note.body ?? ""
            }
        }
    }
}
