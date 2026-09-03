//
//  ClockStage.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import Foundation

struct ClockStage: Hashable, Codable {

    var movesRequired: Int?
    var baseTime: TimeInterval
    var increment: TimeInterval

}
