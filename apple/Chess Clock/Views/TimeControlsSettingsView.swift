//
//  GeneralSettingsView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.04.07.
//

import SwiftData
import SwiftUI

struct TimeControlsSettingsView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var savedPresets: [TimeControlModel]

  @AppStorage("activePresetID") private var activePresetID: String = "standard_1 min"
  @State private var showingAddCustomTime = false

  var body: some View {
    NavigationStack {
      Form {
        Section {
          Button {
            showingAddCustomTime = true
          } label: {
            HStack {
              Text("Add Custom Time")
                .foregroundColor(.primary)
              Spacer()
              Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
            }
          }
        }

        if !savedPresets.isEmpty {
          Section("Custom Presets") {
            ForEach(savedPresets) { model in
              let preset = Preset.custom(id: model.id, name: model.name, control: model.control)
              presetRow(for: preset)
            }
            .onDelete(perform: deleteCustomPresets)
          }
        }

        Section("Presets") {
          ForEach(Preset.defaults) { preset in
            presetRow(for: preset)
          }
        }

        Section {
          Button(role: .destructive) {
            restoreDefaults()
          } label: {
            HStack {
              Spacer()
              Text("Restore Default Time Controls")
              Spacer()
            }
          }
        }
      }
      .listStyle(.insetGrouped)
      .navigationTitle("Time Controls")
      .navigationBarTitleDisplayMode(.inline)
      .sheet(isPresented: $showingAddCustomTime) {
        AddCustomTimeView()
      }
    }
  }

  @ViewBuilder
  private func presetRow(for preset: Preset) -> some View {
    let isSelected = activePresetID == preset.id

    HStack {
      Text(preset.name)
        .foregroundColor(isSelected ? .green : .primary)
      Spacer()
      if isSelected {
        Image(systemName: "checkmark")
          .foregroundColor(.green)
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      activePresetID = preset.id
    }
  }

  private func deleteCustomPresets(at offsets: IndexSet) {
    for index in offsets {
      let model = savedPresets[index]
      let presetID = "custom_\(model.id.uuidString)"
      if activePresetID == presetID {
        activePresetID = Preset.defaults.first?.id ?? ""
      }
      modelContext.delete(model)
    }
  }

  private func restoreDefaults() {
    activePresetID = Preset.defaults.first?.id ?? "standard_1 min"

    for model in savedPresets {
      modelContext.delete(model)
    }
  }
}
