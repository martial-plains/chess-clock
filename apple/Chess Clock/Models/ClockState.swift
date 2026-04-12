//
//  ClockState.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import Foundation

struct ClockState {
    var whiteRemaining: TimeInterval
    var blackRemaining: TimeInterval
    
    var whiteDeadline: Date?
    var blackDeadline: Date?

    var whiteMoves = 0
    var blackMoves = 0

    var activePlayer: Player?
    var losingPlayer: Player?
    var turnStartedAt: Date?
    
    var stageIndexWhite = 0
    var stageIndexBlack = 0

    var isGameOver = false
}
