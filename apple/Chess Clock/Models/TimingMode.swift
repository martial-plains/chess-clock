//
//  TimingMode.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

/// Defines the logic used to calculate time deductions and increments.
enum TimingMode: String, Hashable, Codable, CaseIterable {

    /// No time is added. The clock counts down continuously until it reaches zero.
    case simple

    /// A fixed amount of time is added to the player's clock after every move.
    /// This time can be "banked" for future turns.
    case fischer

    /// The clock starts counting down immediately. Upon completing a move,
    /// the time spent (up to the increment limit) is added back to the clock.
    /// *Note: You can never have more time than you started the turn with.*
    case bronstein

    /// When a turn starts, the clock waits for the duration of the increment
    /// before it begins counting down.
    case delay
}
