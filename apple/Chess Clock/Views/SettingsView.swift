//
//  SettingsView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.04.07.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      TabView {
        Tab("Time Controls", systemImage: "timer") {
          TimeControlsSettingsView()
        }
        Tab("Preferences", systemImage: "gearshape") {
          PreferencesView()
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            dismiss()
          }
          .bold()
        }
      }
    }
  }
}
