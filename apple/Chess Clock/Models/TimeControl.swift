//
//  TimeControl.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

struct TimeControl: Codable {

    var mode: TimingMode
    var stages: [ClockStage]
}
