//
//  Chess_ClockApp.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftUI
import SwiftData

@main
struct Chess_ClockApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TimeControlModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView().ignoresSafeArea().frame(minWidth: 450, minHeight: 350)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .modelContainer(sharedModelContainer)
        
#if os(macOS)
        Settings {
            SettingsView()
        }
#endif
    }
}
