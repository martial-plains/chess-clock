//
//  Preset.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.09.01.
//

import Foundation

enum Preset: Hashable, Identifiable, Codable {
    case standard(name: String, control: TimeControl)
    case custom(id: UUID, name: String, control: TimeControl)

    var id: String {
        switch self {
        case .standard(let name, _):
            return "standard_\(name)"
        case .custom(let id, _, _):
            return "custom_\(id.uuidString)"
        }
    }

    var name: String {
        switch self {
        case .standard(let name, _):
            return name
        case .custom(_, let name, _):
            return name
        }
    }

    var control: TimeControl {
        switch self {
        case .standard(_, let control):
            return control
        case .custom(_, _, let control):
            return control
        }
    }

    static let defaults: [Preset] = [
        .standard(name: "1 min", control: TimeControl(mode: .simple, stages: [ClockStage(movesRequired: nil, baseTime: 60, increment: 0)])),
        .standard(name: "1 min | 1 sec", control: TimeControl(mode: .fischer, stages: [ClockStage(movesRequired: nil, baseTime: 60, increment: 1)])),
        .standard(name: "2 min | 1 sec", control: TimeControl(mode: .fischer, stages: [ClockStage(movesRequired: nil, baseTime: 120, increment: 1)])),
        .standard(name: "3 min", control: TimeControl(mode: .simple, stages: [ClockStage(movesRequired: nil, baseTime: 180, increment: 0)])),
        .standard(name: "3 min | 2 sec", control: TimeControl(mode: .fischer, stages: [ClockStage(movesRequired: nil, baseTime: 180, increment: 2)])),
        .standard(name: "5 min", control: TimeControl(mode: .simple, stages: [ClockStage(movesRequired: nil, baseTime: 300, increment: 0)])),
        .standard(name: "5 min | 5 sec", control: TimeControl(mode: .fischer, stages: [ClockStage(movesRequired: nil, baseTime: 300, increment: 5)])),
        .standard(name: "10 min", control: TimeControl(mode: .simple, stages: [ClockStage(movesRequired: nil, baseTime: 600, increment: 0)])),
        .standard(name: "15 min | 10 sec", control: TimeControl(mode: .fischer, stages: [ClockStage(movesRequired: nil, baseTime: 900, increment: 10)])),
        .standard(name: "20 min", control: TimeControl(mode: .simple, stages: [ClockStage(movesRequired: nil, baseTime: 1200, increment: 0)])),
        .standard(name: "30 min", control: TimeControl(mode: .simple, stages: [ClockStage(movesRequired: nil, baseTime: 1800, increment: 0)]))
    ]
}
