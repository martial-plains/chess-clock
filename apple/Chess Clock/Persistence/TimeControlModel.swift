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

    var name: String
    var systemRaw: String
    var stagesData: Data

    init(name: String, control: TimeControl) {
        self.name = name
        self.systemRaw = control.mode.rawValue
        self.stagesData = try! JSONEncoder().encode(control.stages)
    }

    var control: TimeControl {
        TimeControl(
            mode: TimingMode(rawValue: systemRaw)!,
            stages: try! JSONDecoder().decode(
                [ClockStage].self,
                from: stagesData
            )
        )
    }
}
