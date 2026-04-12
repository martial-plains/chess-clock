//
//  AddPresetView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.04.10.
//

import SwiftUI

struct AddPresetView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFocused: Bool
    
    
    var onSave: (TimeControlModel) -> Void
    
    @State private var name: String = ""
    @State private var mode: TimingMode = .fischer
    @State private var baseTime: Double = 300
    @State private var increment: Double = 5
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Preset Info") {
                    TextField("Name", text: $name).focused($isNameFocused)
                }
                
                Section("Timing Mode") {
                    Picker("Mode", selection: $mode) {
                        ForEach(TimingMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue.capitalized)
                        }
                    }
                }
                
                Section("Time Settings") {
                    LabeledContent("Base Time") {
                        Stepper("\(Int(baseTime)) sec", value: $baseTime, in: 0...36000, step: 30)
                    }
                    
                    LabeledContent("Increment") {
                        Stepper("\(Int(increment)) sec", value: $increment, in: 0...60, step: 1)
                    }
                }
            }
            .navigationTitle("New Preset")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                isNameFocused = true
            }
        }
    }
    
    private func save() {
        let control = TimeControl(
            mode: mode,
            stages: [
                ClockStage(
                    movesRequired: nil,
                    baseTime: baseTime,
                    increment: increment
                )
            ]
        )
        
        let preset = TimeControlModel(
            name: name,
            control: control,
            isDefault: false
        )
        
        onSave(preset)
        dismiss()
    }
}
