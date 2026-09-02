//
//  IncrementSelectionView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.09.01.
//

import SwiftUI

enum IncrementOption: String, CaseIterable, Identifiable {
    case bronstein = "Bronstein"
    case delay = "Delay"
    case fischer = "Fischer"
    case none = "None"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .bronstein:
            return "Time spent is added back up to the increment limit"
        case .delay:
            return "The player's clock starts after the delay period"
        case .fischer:
            return "A fixed amount of time is added after every move"
        case .none:
            return "Players recieve no increment"
        }
    }

    var timingMode: TimingMode {
        switch self {
        case .bronstein: return .bronstein
        case .delay: return .delay
        case .fischer: return .fischer
        case .none: return .simple
        }
    }
}

struct IncrementSelectionView: View {
    @Binding var timingMode: TimingMode
    @Binding var increment: TimeInterval

    @State private var selectedOption: IncrementOption = .none
    @State private var incMinutes: Int = 0
    @State private var incSeconds: Int = 5
    @State private var showIncPicker: Bool = false

    var body: some View {
        Form {
            Section(header: Text("TYPE"), footer: Text(selectedOption.description)) {
                ForEach(IncrementOption.allCases) { option in
                    HStack {
                        Text(option.rawValue)
                            .foregroundColor(selectedOption == option ? .accentColor : .primary)
                        Spacer()
                        if selectedOption == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedOption = option
                        timingMode = option.timingMode
                        if option == .none {
                            increment = 0
                        } else if increment == 0 {
                            increment = 5
                            incSeconds = 5
                        }
                    }
                }
            }

            if selectedOption != .none {
                Section {
                    HStack {
                        Text("Increment")
                        Spacer()
                        Text(String(format: "%d:%02d", incMinutes, incSeconds))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color(uiColor: .tertiarySystemFill))
                            .cornerRadius(8)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            showIncPicker.toggle()
                        }
                    }

                    if showIncPicker {
                        HStack {
                            Picker("Minutes", selection: $incMinutes) {
                                ForEach(0..<60) { m in Text("\(m) m").tag(m) }
                            }
                            .pickerStyle(.wheel)

                            Picker("Seconds", selection: $incSeconds) {
                                ForEach(0..<60) { s in Text("\(s) s").tag(s) }
                            }
                            .pickerStyle(.wheel)
                        }
                        .frame(height: 140)
                        .onChange(of: incMinutes) { _, _ in updateIncrement() }
                        .onChange(of: incSeconds) { _, _ in updateIncrement() }
                    }
                }
            }
        }
        .navigationTitle("Increment")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if increment == 0 || timingMode == .simple {
                selectedOption = .none
            } else {
                switch timingMode {
                case .bronstein: selectedOption = .bronstein
                case .delay: selectedOption = .delay
                case .fischer: selectedOption = .fischer
                case .simple: selectedOption = .none
                }
                let total = Int(increment)
                incMinutes = total / 60
                incSeconds = total % 60
            }
        }
    }

    private func updateIncrement() {
        increment = TimeInterval(incMinutes * 60 + incSeconds)
    }
}
