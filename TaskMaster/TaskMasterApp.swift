//
//  TaskMasterApp.swift
//  TaskMaster
//
//  Created by Aditya on 17/06/25.
//

import SwiftUI

@main
struct TaskMasterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NotesListView(context: persistenceController.container.viewContext)
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    }
    }
}
