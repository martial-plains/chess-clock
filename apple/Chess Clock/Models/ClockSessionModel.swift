//
//  ClockSessionModel.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.04.10.
//

import SwiftData
import Foundation

@Model
final class ClockSessionModel {

    var controlData: Data = Data()
    
    var whiteRemaining: TimeInterval = 0
    var blackRemaining: TimeInterval = 0
    
    var whiteMoves: Int = 0
    var blackMoves: Int = 0
    
    var stageIndexWhite: Int = 0
    var stageIndexBlack: Int = 0
    
    var activePlayerRaw: String?
    
    var isGameOver: Bool = false
    
    var turnStartedAt: Date?
    
    init() {
        
    }
}
