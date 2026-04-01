//
//  ContentView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) var phase
    @Environment(\.horizontalSizeClass) var size
    @StateObject var lifecycle = AppLifecycle()
    @StateObject var engine = ClockEngine(
            control: TimeControl(
                system: .fischer,
                stages: [
                    ClockStage(
                        movesRequired: nil,
                        baseTime: 300,
                        increment: 3
                    )
                ]
            )
        )
    
    var rotateBoard: Bool {
    #if os(iOS)
        size == .compact
    #else
        false
    #endif
    }

        var body: some View {

            TimelineView(.periodic(from: .now, by: 0.1)) { _ in

                VStack(spacing: 0) {

                    PlayerClockView(
                        player: .black,
                        rotate: rotateBoard,
                        time: engine.displayTime(for: .black),
                        isActive: engine.state.activePlayer == .black
                    ) {
                        tap(.black)
                    }

                    Divider()

                    PlayerClockView(
                        player: .white,
                        rotate: rotateBoard,
                        time: engine.displayTime(for: .white),
                        isActive: engine.state.activePlayer == .white
                    ) {
                        tap(.white)
                    }
                }
            }.onChange(of: phase) { _, newPhase in
                
                switch newPhase {
                case .background:
                    lifecycle.appMovedToBackground(engine: engine)

                case .active:
                    lifecycle.appReturned(engine: engine)

                default:
                    break
                }
            }
        }

        func tap(_ player: Player) {

            if engine.state.activePlayer == nil {
                engine.start(player: player)
            } else if engine.state.activePlayer == player {
                engine.switchTurn()
            }
        }
}

#Preview {
    ContentView()
        .modelContainer(for: TimeControlModel.self, inMemory: true)
}
