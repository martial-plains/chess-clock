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
            mode: .fischer,
            stages: [
                ClockStage(
                    movesRequired: nil,
                    baseTime: 300,
                    increment: 5,
                )
            ]
        )
    )
    
    @State private var isTapLocked = false
    @State private var pressedPlayer: Player?
    
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            
            VStack(spacing: 0) {
                
                
                Group {
                    if isLandscape {
                        HStack(spacing: 0) {
                            playerView(.black, isLandscape: isLandscape)
                            playerView(.white, isLandscape: isLandscape)
                        }
                    } else {
                        VStack(spacing: 0) {
                            playerView(.black, isLandscape: isLandscape)
                            playerView(.white, isLandscape: isLandscape)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: isLandscape)
                
            }
        }
        .onChange(of: phase) { _, newPhase in
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
        
        guard !isTapLocked else { return }
        
        isTapLocked = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isTapLocked = false
        }
        
        if engine.state.activePlayer == nil {
            let opponent: Player = (player == .white) ? .black : .white
            engine.start(player: opponent)
        } else if engine.state.activePlayer == player {
            engine.switchTurn()
        }
        
        HapticsManager.tap()
    }
    
    func rotateFor(_ player: Player, isLandscape: Bool) -> Bool {
        if isLandscape {
            return false
        } else {
            return player == .black
        }
    }
    
    
    @ViewBuilder
    func playerView(_ player: Player, isLandscape: Bool) -> some View {        
        PlayerClockView(
            engine: engine,
            player: player,
            rotate: rotateFor(player, isLandscape: isLandscape)
        ) {
            tap(player)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            pressedPlayer = player
            tap(player)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                pressedPlayer = nil
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TimeControlModel.self, inMemory: true)
}
