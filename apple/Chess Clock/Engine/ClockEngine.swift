//
//  ClockEngine.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import Combine
import Foundation

@MainActor
final class ClockEngine: ObservableObject {

  @Published private(set) var state: ClockState

  private var timeoutTask: Task<Void, Never>?

  var control: TimeControl

  init(control: TimeControl) {
    self.control = control

    precondition(
      !control.stages.isEmpty,
      "TimeControl must contain at least one stage")

    let start = control.stages[0]

    state = ClockState(
      whiteRemaining: start.baseTime,
      blackRemaining: start.baseTime,
      whiteDeadline: nil,
      blackDeadline: nil
    )
  }

  func start(player: Player) {
    guard !state.isGameOver else { return }

    state.activePlayer = player
    state.turnStartedAt = Date()

    let remaining = displayTime(for: player)
    let deadline = startDeadline(for: player, remaining: remaining)

    if player == .white {
      state.whiteDeadline = deadline
    } else {
      state.blackDeadline = deadline
    }

    scheduleTimeout(for: player)
  }

  func pause() {
    guard let player = state.activePlayer else { return }

    timeoutTask?.cancel()

    let remaining = displayTime(for: player)

    if player == .white {
      state.whiteRemaining = remaining
      state.whiteDeadline = nil
    } else {
      state.blackRemaining = remaining
      state.blackDeadline = nil
    }

    state.pausedPlayer = player
    state.activePlayer = nil
    state.isPaused = true
  }

  func resume() {
    guard state.isPaused,
      let player = state.pausedPlayer,
      !state.isGameOver
    else { return }

    state.pausedPlayer = nil
    state.isPaused = false

    state.activePlayer = player
    state.turnStartedAt = Date()

    let remaining = displayTime(for: player)
    let deadline = startDeadline(
      for: player,
      remaining: remaining
    )

    if player == .white {
      state.whiteDeadline = deadline
    } else {
      state.blackDeadline = deadline
    }

    scheduleTimeout(for: player)
  }

  func reset(with newControl: TimeControl? = nil) {
    timeoutTask?.cancel()

    if let newControl {
        self.control = newControl
    }

    let start = control.stages[0]

    state = ClockState(
        whiteRemaining: start.baseTime,
        blackRemaining: start.baseTime,
        whiteDeadline: nil,
        blackDeadline: nil
    )
}

  func switchTurn() {
      guard !state.isGameOver,
            !state.isPaused,
      let player = state.activePlayer
    else { return }

    timeoutTask?.cancel()

    let remaining = displayTime(for: player)

    if player == .white {
      state.whiteRemaining = remaining
      state.whiteDeadline = nil
    } else {
      state.blackRemaining = remaining
      state.blackDeadline = nil
    }

    registerMove(for: player)

    switch control.mode {
    case .fischer:
      addIncrement(to: player)
    case .bronstein:
      applyBronsteinRefund(for: player)
    default:
      break
    }

    let opponent = player.opponent
    let opponentRemaining = displayTime(for: opponent)
    let deadline = startDeadline(for: opponent, remaining: opponentRemaining)

    if opponent == .white {
        state.whiteDeadline = deadline
        state.blackDeadline = nil
    } else {
        state.blackDeadline = deadline
        state.whiteDeadline = nil
    }

    state.activePlayer = opponent
    state.turnStartedAt = Date()

    scheduleTimeout(for: opponent)
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
    let index = (player == .white) ? state.stageIndexWhite : state.stageIndexBlack
    guard index < control.stages.count - 1 else { return }

    let stage = control.stages[index]
    guard let required = stage.movesRequired else { return }

    let moves = (player == .white) ? state.whiteMoves : state.blackMoves
    guard moves >= required else { return }

    let nextIndex = index + 1
    let nextStage = control.stages[nextIndex]
    if player == .white {
      state.whiteRemaining += nextStage.baseTime
      state.stageIndexWhite = nextIndex
    } else {
      state.blackRemaining += nextStage.baseTime
      state.stageIndexBlack = nextIndex
    }
  }

  func displayTime(for player: Player) -> TimeInterval {

    let deadline =
      player == .white
      ? state.whiteDeadline
      : state.blackDeadline

    if let deadline {
      return max(0, deadline.timeIntervalSinceNow)
    } else {
      return (player == .white) ? state.whiteRemaining : state.blackRemaining
    }
  }

  private func currentStage(for player: Player) -> ClockStage {

    let index =
      player == .white
      ? state.stageIndexWhite
      : state.stageIndexBlack

    return control.stages[index]
  }

  private func subtract(
    _ time: TimeInterval,
    from player: Player
  ) {

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

    if player == .white, let deadline = state.whiteDeadline {
      state.whiteDeadline = deadline.addingTimeInterval(inc)
    } else if player == .black, let deadline = state.blackDeadline {
      state.blackDeadline = deadline.addingTimeInterval(inc)
    } else {
      if player == .white { state.whiteRemaining += inc } else { state.blackRemaining += inc }
    }
  }

  private func addTime(
    _ time: TimeInterval,
    to player: Player
  ) {

    if player == .white {
      state.whiteRemaining += time
    } else {
      state.blackRemaining += time
    }
  }

  private func flagFall() {

    guard !state.isGameOver else { return }

    state.isGameOver = true
    state.losingPlayer = state.activePlayer
    state.activePlayer = nil

    timeoutTask?.cancel()

    SoundManager.shared.playFlagFall()
    HapticsManager.flagFall()
  }

  private func scheduleTimeout(for player: Player) {
    timeoutTask?.cancel()

    let remaining = displayTime(for: player)
    guard remaining > 0 else {
      flagFall()
      return
    }

    timeoutTask = Task { @MainActor in
      try? await Task.sleep(nanoseconds: UInt64(remaining * 1_000_000_000))
      guard !Task.isCancelled else { return }
      self.flagFall()
    }
  }

  private func startDeadline(for player: Player, remaining: TimeInterval) -> Date {
    let inc = currentStage(for: player).increment
    switch control.mode {
    case .simple, .fischer, .bronstein:
      return Date().addingTimeInterval(remaining)
    case .delay:
      return Date().addingTimeInterval(remaining + inc)
    }
  }

  private func applyBronsteinRefund(for player: Player) {
    guard control.mode == .bronstein,
      let start = state.turnStartedAt
    else { return }

    let elapsed = Date().timeIntervalSince(start)
    let inc = currentStage(for: player).increment
    let refund = min(elapsed, inc)

    if player == .white { state.whiteRemaining += refund } else { state.blackRemaining += refund }
  }
}
