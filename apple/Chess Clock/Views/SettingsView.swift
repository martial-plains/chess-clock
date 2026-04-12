//
//  SettingsView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.04.07.
//

import SwiftUI


struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: SettingsTab? = .presets
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detail
        }
        .navigationSplitViewStyle(.automatic)
#if os(iOS)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
#endif
    }
        
    private var sidebar: some View {
        List(selection: $selectedTab) {
            Section("Settings") {
                Label("Presets", systemImage: "clock.arrow.circlepath")
                    .tag(SettingsTab.presets)
            }
        }
        .navigationTitle("Settings")
        .listStyle(.sidebar)
    }
    
    // MARK: - Detail
    
    @ViewBuilder
    private var detail: some View {
        switch selectedTab {
        case .presets:
            PresetsSettingsView()
            
        case .none:
            ContentUnavailableView(
                "Select a category",
                systemImage: "gearshape"
            )
        }
    }
}


enum SettingsTab: Hashable {
    case presets
}
