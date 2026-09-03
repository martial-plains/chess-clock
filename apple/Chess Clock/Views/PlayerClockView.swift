//
//  PlayerClockView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftData
import SwiftUI

struct PlayerClockView: View {

  @ObservedObject var engine: ClockEngine

  let player: Player
  let rotate: Bool
  let action: () -> Void

  @Query private var settingsArray: [AppSettings]

  private var activeThemeColor: Color? {
    settingsArray.first?.appThemeColor.color
  }

  var body: some View {

    TimelineView(.animation) { _ in

      let time = engine.displayTime(for: player)
      let isActive = engine.state.activePlayer == player
      let lost = engine.state.losingPlayer == player
      let moves = player == .white ? engine.state.whiteMoves : engine.state.blackMoves

      Button(action: action) {
        GeometryReader { geo in
          ZStack {
            Text(format(time))
              .font(.system(size: 32, weight: .bold, design: .monospaced))
              .position(x: geo.size.width / 2, y: geo.size.height / 2)

            HStack {
              Spacer()
              Text("Moves: \(moves)")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
            }
            .padding(.top, geo.safeAreaInsets.top > 0 ? geo.safeAreaInsets.top : 16)
            .padding(.trailing, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .rotationEffect(
          rotate && player == .black
            ? .degrees(180)
            : .zero
        )
        .background(lost ? Color.red.opacity(0.8) : (isActive ? activeThemeColor : .black))
        .foregroundColor(.white)
      }
      .buttonStyle(.plain)
    }
  }

  func format(_ time: TimeInterval) -> String {

    let t = max(0, Int(time))
    let m = t / 60
    let s = t % 60

    return String(format: "%02d:%02d", m, s)
  }

}
