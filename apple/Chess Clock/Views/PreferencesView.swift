//
//  PreferencesView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftUI

struct PreferencesView: View {
    @AppStorage("selectedTheme") private var selectedTheme: String = ThemeColor.green.rawValue
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true

    var body: some View {
        Form {
            Section(header: Text("THEME COLOR")) {
                ForEach(ThemeColor.allCases) { theme in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(theme.color)
                            .frame(width: 24, height: 24)

                        Text(theme.rawValue)
                            .foregroundColor(.primary)

                        Spacer()

                        if selectedTheme == theme.rawValue {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .bold()
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTheme = theme.rawValue
                    }
                }
            }

            Section {
                Toggle(isOn: $soundEnabled) {
                    Label("Sound", systemImage: "speaker.wave.2.fill")
                }
            }
        }
    }
}
