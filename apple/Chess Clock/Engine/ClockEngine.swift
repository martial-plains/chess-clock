//
//  ClockEngine.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import Foundation
import Combine

@MainActor
final class ClockEngine: ObservableObject {

    @Published private(set) var state: ClockState
    
    private var timeoutTask: Task<Void, Never>?

    let control: TimeControl

    init(control: TimeControl) {

        self.control = control

        let start = control.stages.first!

        state = ClockState(
            whiteRemaining: start.baseTime,
            blackRemaining: start.baseTime
        )
    }
    
    
    func start(player: Player) {
        state.activePlayer = player
        state.turnStart = Date()
        
        scheduleTimeout(for: player)
    }

    func pause() {
        timeoutTask?.cancel()
        
        if let start = state.turnStart {
            state.accumulatedTimeThisTurn += Date().timeIntervalSince(start)
        }
        state.turnStart = nil
        state.activePlayer = nil
    }

    func switchTurn() {
        guard let player = state.activePlayer else { return }
        timeoutTask?.cancel()
        
        commitElapsed()
        registerMove(for: player)
        
        state.accumulatedTimeThisTurn = 0
        
        if control.system == .fischer {
            addIncrement(to: player)
        }
        
        state.activePlayer = player.opponent
        state.turnStart = Date()
        scheduleTimeout(for: player.opponent)
    }
    
    private func registerMove(for player: Player) {

        if player == .white {
            state.whiteMoves += 1
            advanceStageIfNeeded(player)
        } else {
            state.blackMoves += 1
            advanceStageIfNeeded(player)
        }
    }

    private func advanceStageIfNeeded(_ player: Player) {

        let index =
            player == .white
            ? state.stageIndexWhite
            : state.stageIndexBlack

        guard index < control.stages.count else { return }

        let stage = control.stages[index]

        guard let required = stage.movesRequired else { return }

        let moves =
            player == .white
            ? state.whiteMoves
            : state.blackMoves

        if moves == required {

            let nextIndex = index + 1
            guard nextIndex < control.stages.count else { return }

            let nextStage = control.stages[nextIndex]

            addTime(nextStage.baseTime, to: player)

            if player == .white {
                state.stageIndexWhite = nextIndex
            } else {
                state.stageIndexBlack = nextIndex
            }
        }
    }
    
    private func commitElapsed() {
        guard let player = state.activePlayer else { return }
        
        var elapsed = state.accumulatedTimeThisTurn
        if let start = state.turnStart {
            elapsed += Date().timeIntervalSince(start)
        }
        
        let increment = currentStage(for: player).increment
        let deduction: TimeInterval
        
        switch control.system {
        case .simple, .fischer:
            deduction = elapsed
            
        case .delay, .bronstein:
            deduction = max(0, elapsed - increment)
        }
        
        subtract(deduction, from: player)
    }

    func displayTime(for player: Player) -> TimeInterval {
        var remaining = player == .white ? state.whiteRemaining : state.blackRemaining
        
        guard player == state.activePlayer else {
            return max(0, remaining)
        }
        
        var elapsed = state.accumulatedTimeThisTurn
        if let start = state.turnStart {
            elapsed += Date().timeIntervalSince(start)
        }
        
        let inc = currentStage(for: player).increment
        
        switch control.system {
        case .simple, .fischer, .bronstein:
            remaining -= elapsed
            
        case .delay:
            remaining -= max(0, elapsed - inc)
        }
        
        return max(0, remaining)
    }
    
    private func currentStage(for player: Player) -> ClockStage {

        let index =
            player == .white
            ? state.stageIndexWhite
            : state.stageIndexBlack

        return control.stages[index]
    }

    private func subtract(_ time: TimeInterval,
                           from player: Player) {

        switch player {
        case .white:
            state.whiteRemaining -= time
            if state.whiteRemaining <= 0 { flagFall() }

        case .black:
            state.blackRemaining -= time
            if state.blackRemaining <= 0 { flagFall() }
        }
    }

    private func addIncrement(to player: Player) {
        let inc = currentStage(for: player).increment
        addTime(inc, to: player)
    }

    private func addTime(_ time: TimeInterval,
                         to player: Player) {

        if player == .white {
            state.whiteRemaining += time
        } else {
            state.blackRemaining += time
        }
    }

    private func flagFall() {

        state.isGameOver = true
        state.activePlayer = nil

        SoundManager.shared.playFlagFall()
        HapticsManager.flagFall()
    }
    
    private func scheduleTimeout(for player: Player) {
        timeoutTask?.cancel()
        
        let timeUntilFlag = displayTime(for: player)
        
        guard timeUntilFlag > 0 else {
            flagFall()
            return
        }
        
        timeoutTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(timeUntilFlag * 1_000_000_000))
            
            if !Task.isCancelled {
                self.flagFall()
            }
        }
    }
}

