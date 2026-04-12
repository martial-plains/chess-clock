//
//  TimeControlModel.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftData
import Foundation

@Model
final class TimeControlModel {
    @Attribute(.unique)
    var id: UUID

    var name: String
    var systemRaw: String
    var stagesData: Data
    var isDefault: Bool
    var sortIndex: Int = 0
    
    init(name: String, control: TimeControl, isDefault: Bool = false) {
        self.id = UUID()
        self.name = name
        self.systemRaw = control.mode.rawValue
        self.stagesData = try! JSONEncoder().encode(control.stages)
        self.isDefault = isDefault
    }

    var control: TimeControl {
        TimeControl(
            mode: TimingMode(rawValue: systemRaw)!,
            stages: try! JSONDecoder().decode([ClockStage].self, from: stagesData)
        )
    }
}
