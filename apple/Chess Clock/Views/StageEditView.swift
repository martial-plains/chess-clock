//
//  StageEditView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.09.01.
//

import SwiftUI

struct StageEditView: View {
    @Binding var stage: ClockStage
    @Binding var timingMode: TimingMode

    @State private var hours: Int = 2
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0

    @State private var movesText: String = "40"
    @State private var showTimePicker: Bool = false

    var stageTitle: String

    var body: some View {
        Form {
            Section {
                // Time Row
                HStack {
                    Text("Time")
                    Spacer()
                    Text(formatTime())
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color(uiColor: .tertiarySystemFill))
                        .cornerRadius(8)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        showTimePicker.toggle()
                    }
                }

                if showTimePicker {
                    HStack {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24) { h in Text("\(h) h").tag(h) }
                        }
                        .pickerStyle(.wheel)

                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60) { m in Text("\(m) m").tag(m) }
                        }
                        .pickerStyle(.wheel)

                        Picker("Seconds", selection: $seconds) {
                            ForEach(0..<60) { s in Text("\(s) s").tag(s) }
                        }
                        .pickerStyle(.wheel)
                    }
                    .frame(height: 140)
                    .onChange(of: hours) { _, _ in updateBaseTime() }
                    .onChange(of: minutes) { _, _ in updateBaseTime() }
                    .onChange(of: seconds) { _, _ in updateBaseTime() }
                }

                // Moves Row
                HStack {
                    Text("Moves")
                    Spacer()
                    TextField("40", text: $movesText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .frame(width: 60)
                        .background(Color(uiColor: .tertiarySystemFill))
                        .cornerRadius(8)
                        .onChange(of: movesText) { _, newValue in
                            stage.movesRequired = Int(newValue)
                        }
                }

                // Increment Navigation Row
                NavigationLink {
                    IncrementSelectionView(timingMode: $timingMode, increment: $stage.increment)
                } label: {
                    HStack {
                        Text("Increment")
                        Spacer()
                        Text(incrementLabel)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle(stageTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let total = Int(stage.baseTime)
            hours = total / 3600
            minutes = (total % 3600) / 60
            seconds = total % 60
            if let moves = stage.movesRequired {
                movesText = "\(moves)"
            } else {
                movesText = ""
            }
        }
    }

    private var incrementLabel: String {
        if stage.increment == 0 || timingMode == .simple {
            return "None"
        }
        return timingMode.rawValue.capitalized
    }

    private func formatTime() -> String {
        String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }

    private func updateBaseTime() {
        stage.baseTime = TimeInterval(hours * 3600 + minutes * 60 + seconds)
    }
}
