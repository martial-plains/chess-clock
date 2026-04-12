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
    let container: ModelContainer
    
    init() {
        let schema = Schema([TimeControlModel.self])
        let config = ModelConfiguration(schema: schema)
        
        self.container = try! ModelContainer(for: schema, configurations: config)
        let context = container.mainContext
        DatabaseSeeder.seedIfNeeded(context: context)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea()
                .frame(minWidth: 450, minHeight: 350)
        }
        .modelContainer(container)
#if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
#endif
        
#if os(macOS)
        Settings {
            SettingsView()
        }
        .modelContainer(container)
#endif
    }
}
