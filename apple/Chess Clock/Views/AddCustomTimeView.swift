//
//  AddCustomTimeView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.09.01.
//

import SwiftData
import SwiftUI

struct AddCustomTimeView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @State private var name: String = ""
  @State private var isAdvancedMode: Bool = false
  @State private var selectedPlayerTab: Int = 0
  @State private var selectedTimingMode: TimingMode = .fischer

  @State private var selectedMinutes: Int = 5
  @State private var selectedSeconds: Int = 0
  @State private var incrementMinutes: Int = 0
  @State private var incrementSeconds: Int = 5

  @State private var showBaseTimePicker: Bool = false
  @State private var showIncrementPicker: Bool = false

  @State private var playerOneStages: [ClockStage] = [
    ClockStage(movesRequired: 40, baseTime: 7200, increment: 0),
    ClockStage(movesRequired: nil, baseTime: 3600, increment: 0),
  ]
  @State private var playerTwoStages: [ClockStage] = [
    ClockStage(movesRequired: 40, baseTime: 7200, increment: 0),
    ClockStage(movesRequired: nil, baseTime: 3600, increment: 0),
  ]

  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("Name", text: $name)
        }

        if !isAdvancedMode {
          Section {
            HStack {
              Text("Time")
              Spacer()
              Text(String(format: "%d:%02d", selectedMinutes, selectedSeconds))
                .foregroundColor(.primary)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color(uiColor: .tertiarySystemFill))
                .cornerRadius(8)
            }
            .contentShape(Rectangle())
            .onTapGesture {
              withAnimation {
                showBaseTimePicker.toggle()
                showIncrementPicker = false
              }
            }

            if showBaseTimePicker {
              HStack {
                Picker("Minutes", selection: $selectedMinutes) {
                  ForEach(0..<181) { min in
                    Text("\(min) min").tag(min)
                  }
                }
                .pickerStyle(.wheel)

                Picker("Seconds", selection: $selectedSeconds) {
                  ForEach(0..<60) { sec in
                    Text("\(sec) sec").tag(sec)
                  }
                }
                .pickerStyle(.wheel)
              }
              .frame(height: 150)
            }

            HStack {
              Text("Increment")
              Spacer()
              Text(String(format: "%d:%02d", incrementMinutes, incrementSeconds))
                .foregroundColor(.primary)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color(uiColor: .tertiarySystemFill))
                .cornerRadius(8)
            }
            .contentShape(Rectangle())
            .onTapGesture {
              withAnimation {
                showIncrementPicker.toggle()
                showBaseTimePicker = false
              }
            }

            if showIncrementPicker {
              HStack {
                Picker("Inc Minutes", selection: $incrementMinutes) {
                  ForEach(0..<60) { min in
                    Text("\(min) min").tag(min)
                  }
                }
                .pickerStyle(.wheel)

                Picker("Inc Seconds", selection: $incrementSeconds) {
                  ForEach(0..<60) { sec in
                    Text("\(sec) sec").tag(sec)
                  }
                }
                .pickerStyle(.wheel)
              }
              .frame(height: 150)
            }
          }
        } else {
          Section {
            Picker("Player", selection: $selectedPlayerTab) {
              Text("Player One").tag(0)
              Text("Player Two").tag(1)
            }
            .pickerStyle(.segmented)
          }

          Section(header: Text("STAGES")) {
            let currentStages = selectedPlayerTab == 0 ? playerOneStages : playerTwoStages
            ForEach(Array(currentStages.enumerated()), id: \.offset) { index, _ in
              NavigationLink {
                StageEditView(
                  stage: selectedPlayerTab == 0 ? $playerOneStages[index] : $playerTwoStages[index],
                  timingMode: $selectedTimingMode,
                  stageTitle: index == 0 ? "Stage One" : "Stage \(index + 1)"
                )
              } label: {
                HStack {
                  ZStack {
                    Circle()
                      .fill(Color.gray.opacity(0.3))
                      .frame(width: 24, height: 24)
                    Text("\(index + 1)")
                      .font(.caption)
                      .bold()
                  }
                  VStack(alignment: .leading, spacing: 2) {
                    Text(stageDescription(currentStages[index]))
                      .font(.body)
                    Text(
                      "Increment – \(currentStages[index].increment == 0 ? "None" : "\(Int(currentStages[index].increment))s")"
                    )
                    .font(.caption)
                    .foregroundColor(.secondary)
                  }
                }
              }
            }

            Button {
              addStage()
            } label: {
              Label("Add Stage", systemImage: "plus")
                .foregroundColor(.accentColor)
            }
          }
        }

        Section {
          Toggle("Advanced Mode", isOn: $isAdvancedMode.animation())
        }
      }
      .navigationTitle("Custom Time")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Add") {
            saveCustomTime()
            dismiss()
          }
        }
      }
    }
  }

  private func stageDescription(_ stage: ClockStage) -> String {
    let hours = Int(stage.baseTime) / 3600
    let timeStr = hours > 0 ? "\(hours) hr" : "\(Int(stage.baseTime) / 60) min"

    if let moves = stage.movesRequired {
      return "\(moves) moves in \(timeStr)"
    } else {
      return "Game in \(timeStr)"
    }
  }

  private func addStage() {
    let newStage = ClockStage(movesRequired: nil, baseTime: 1800, increment: 0)
    if selectedPlayerTab == 0 {
      playerOneStages.append(newStage)
    } else {
      playerTwoStages.append(newStage)
    }
  }

  private func saveCustomTime() {
    let totalBaseSeconds = TimeInterval(selectedMinutes * 60 + selectedSeconds)
    let totalIncSeconds = TimeInterval(incrementMinutes * 60 + incrementSeconds)

    let defaultName = "\(selectedMinutes) min | \(totalIncSeconds) sec"
    let controlName = name.trimmingCharacters(in: .whitespaces).isEmpty ? defaultName : name

    let control: TimeControl
    if isAdvancedMode {
      control = TimeControl(mode: .fischer, stages: playerOneStages)
    } else {
      let stage = ClockStage(
        movesRequired: nil, baseTime: totalBaseSeconds, increment: totalIncSeconds)
      control = TimeControl(mode: totalIncSeconds > 0 ? .fischer : .simple, stages: [stage])
    }

    let model = TimeControlModel(name: controlName, control: control)
    modelContext.insert(model)
  }
}
