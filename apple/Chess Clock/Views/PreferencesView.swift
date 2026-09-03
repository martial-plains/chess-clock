//
//  PreferencesView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftData
import SwiftUI

struct PreferencesView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var settingsArray: [AppSettings]

  private var currentSettings: AppSettings {
    if let existing = settingsArray.first {
      return existing
    } else {
      let newSettings = AppSettings()
      modelContext.insert(newSettings)
      return newSettings
    }
  }

  var body: some View {
    Form {
      Section(header: Text("Theme")) {
        ForEach(ThemeColor.allCases) { theme in
          HStack(spacing: 12) {
            Circle()
              .fill(theme.color)
              .frame(width: 24, height: 24)

            Text(theme.rawValue)
              .foregroundColor(.primary)

            Spacer()

            if currentSettings.appThemeColor == theme {
              Image(systemName: "checkmark")
                .foregroundColor(.accentColor)
            }
          }
          .contentShape(Rectangle())
          .onTapGesture {
            currentSettings.appThemeColor = theme
            try? modelContext.save()
          }
        }
      }

      Section("Interface") {
        Toggle(
          "Hide Status Bar",
          isOn: Binding(
            get: { currentSettings.isStatusBarHidden },
            set: { newValue in
              currentSettings.isStatusBarHidden = newValue
              try? modelContext.save()
            }
          ))
      }

      Section {
        Toggle(
          isOn: Binding(
            get: { currentSettings.isSoundEnabled },
            set: {
              currentSettings.isSoundEnabled = $0
              try? modelContext.save()
            }
          )
        ) {
          Label("Sound", systemImage: "speaker.wave.2.fill")
        }

        Toggle(
          isOn: Binding(
            get: { currentSettings.isHapticsEnabled },
            set: {
              currentSettings.isHapticsEnabled = $0
              try? modelContext.save()
            }
          )
        ) {
          Label("Haptics", systemImage: "iphone.radiowaves.left.and.right")
        }

        Toggle(
          isOn: Binding(
            get: { currentSettings.isLowTimeHapticsEnabled },
            set: {
              currentSettings.isLowTimeHapticsEnabled = $0
              try? modelContext.save()
            }
          )
        ) {
          Label("Vibrate on Low Time", systemImage: "timer.degree.180")
        }
      }
    }.tint(currentSettings.appThemeColor.color)
  }
}
