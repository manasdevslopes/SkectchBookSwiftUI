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
    
    @StateObject var appLockVm = AppLockViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    @State var blurRadius: CGFloat = 0
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appLockVm)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .modifier(DarkModeViewModifier())
                .blur(radius: blurRadius)
                .onChange(of: scenePhase) { value in
                    switch value {
                    case .active :
                        blurRadius = 0
                    case .background:
                        appLockVm.isAppUnlocked = false
                    case .inactive:
                        blurRadius = 5
                    @unknown default:
                        print("unknown")
                    }
                }
        }
    }
}
