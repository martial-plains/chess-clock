//
//  ContentView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.scenePhase) var phase
    @Environment(\.horizontalSizeClass) var size
    
    @Query(filter: #Predicate<TimeControlModel> { $0.isDefault })
    private var defaultPresets: [TimeControlModel]
    
    @State private var showSettings = false
    @State private var engine: ClockEngine? = nil
    @State private var isTapLocked = false
    @State private var pressedPlayer: Player?
    
    
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            
            ZStack {
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
                
                controlButtons(isLandscape: isLandscape)
            }
        }
        .onAppear {
            if let preset = defaultPresets.first, engine == nil {
                engine = ClockEngine(control: preset.control)
            }
        }
        .onChange(of: phase) { _, newPhase in
            if newPhase == .background {
                engine?.pause()
            }
        }
    }
    
    func tap(_ player: Player) {
        guard !isTapLocked else { return }
        
        guard let engine = engine else { return }
        
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
        isLandscape ? false : (player == .black)
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
    
    @ViewBuilder
    func controlButtons(isLandscape: Bool) -> some View {
        let layout = isLandscape
            ? AnyLayout(VStackLayout(spacing: 16))
            : AnyLayout(HStackLayout(spacing: 16))

        layout {
            glassButton(system: "arrow.counterclockwise", size: 20) {
                // reset
            }

            glassButton(system: "pause.fill", size: 28, isPrimary: true) {
                // pause
            }

            glassButton(system: "gearshape", size: 20) {
                showSettings = true
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                }
        }
        .shadow(color: .black.opacity(0.12), radius: 18, y: 10)
        .padding(.bottom, 10)
    }
    
    @ViewBuilder
    func glassButton(
        system: String,
        size: CGFloat,
        isPrimary: Bool = false,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {
            Image(systemName: system)
                .font(.system(size: size, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: isPrimary ? 72 : 52,
                       height: isPrimary ? 72 : 52)
                .background {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay {
                            Circle()
                                .stroke(.white.opacity(0.18), lineWidth: 1)
                        }
                }
        }
        .buttonStyle(PressScaleStyle())
    }
}

struct PressScaleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7),
                       value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TimeControlModel.self, inMemory: true)
}
