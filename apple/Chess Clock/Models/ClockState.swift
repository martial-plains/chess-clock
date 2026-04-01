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

    var whiteMoves = 0
    var blackMoves = 0

    var activePlayer: Player?
    var turnStart: Date?
    
    var accumulatedTimeThisTurn: TimeInterval = 0

    var stageIndexWhite = 0
    var stageIndexBlack = 0

    var isGameOver = false
}
