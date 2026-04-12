//
//  TimeControl.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import Foundation

struct TimeControl: Codable {
    var mode: TimingMode
    var stages: [ClockStage]
}
