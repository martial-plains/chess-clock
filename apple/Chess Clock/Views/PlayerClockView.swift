//
//  PlayerClockView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftUI

struct PlayerClockView: View {

    @ObservedObject var engine: ClockEngine

    let player: Player
    let rotate: Bool
    let action: () -> Void

    var body: some View {

        TimelineView(.animation) { _ in

            let time = engine.displayTime(for: player)
            let isActive = engine.state.activePlayer == player
            let lost = engine.state.losingPlayer == player

            Button(action: action) {
                Text(format(time))
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .rotationEffect(
                        rotate && player == .black
                        ? .degrees(180)
                        : .zero
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(lost ? Color.red.opacity(0.8) : (isActive ? .green : .black))
                    .foregroundColor(.white)
            }.buttonStyle(.plain)
        }
    }
    
    func format(_ time: TimeInterval) -> String {

        let t = max(0, Int(time))
        let m = t / 60
        let s = t % 60

        return String(format: "%02d:%02d", m, s)
    }

}
