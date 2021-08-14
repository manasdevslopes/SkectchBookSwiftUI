//
//  SketchAppApp.swift
//  SketchApp
//
//  Created by MANAS VIJAYWARGIYA on 14/08/21.
//

import SwiftUI

@main
struct SketchAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
