//
//  TimeControlModel.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import Foundation
import SwiftData

@Model
final class TimeControlModel {

  var id: UUID
  var name: String
  var systemRaw: String
  var stagesData: Data

  init(id: UUID = UUID(), name: String, control: TimeControl) {
    self.id = id
    self.name = name
    self.systemRaw = control.mode.rawValue
    self.stagesData = try! JSONEncoder().encode(control.stages)
  }

  var control: TimeControl {
    let mode = TimingMode(rawValue: systemRaw) ?? .simple
    let stages = (try? JSONDecoder().decode([ClockStage].self, from: stagesData)) ?? []
    return TimeControl(mode: mode, stages: stages)
  }
}
