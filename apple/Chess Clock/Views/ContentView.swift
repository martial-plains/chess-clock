//
//  ContentView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftData
import SwiftUI

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
          increment: 5
        )
      ]
    )
  )

  @State private var isTapLocked = false
  @State private var pressedPlayer: Player?
  @State private var showingSettings = false
  @State private var showingResetConfirmation = false

  @AppStorage("activePresetID") private var activePresetID: String = "standard_1 min"
  @Query private var customPresets: [TimeControlModel]

  var body: some View {
    GeometryReader { geo in
      let isLandscape = geo.size.width > geo.size.height

      ZStack {
        Group {
          if isLandscape {
            HStack(spacing: 0) {
              playerView(.black, isLandscape: true)
              playerView(.white, isLandscape: true)
            }
          } else {
            VStack(spacing: 0) {
              playerView(.black, isLandscape: false)
              playerView(.white, isLandscape: false)
            }
          }
        }

        controlView
      }
      .animation(
        .easeInOut(duration: 0.25),
        value: isLandscape
      )
    }
    .sheet(isPresented: $showingSettings) {
      SettingsView()
    }
    .confirmationDialog(
      "Reset Clock",
      isPresented: $showingResetConfirmation,
      titleVisibility: .visible
    ) {
      Button("Confirm", role: .destructive) {
        engine.reset()
        HapticsManager.tap()
      }
    } message: {
        Text("Are you sure you want to reset the clock?")
    }
    .onAppear {
      applyActivePreset()
    }
    .onChange(of: activePresetID) { _, _ in
      applyActivePreset()
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

  private func applyActivePreset() {
    if activePresetID.hasPrefix("custom_") {
      let uuidString = activePresetID.replacingOccurrences(of: "custom_", with: "")
      if let custom = customPresets.first(where: { $0.id.uuidString == uuidString }) {
        engine.reset(with: custom.control)
      }
    } else if let standard = Preset.defaults.first(where: { $0.id == activePresetID }) {
      engine.reset(with: standard.control)
    }
  }

  private var isRunning: Bool {
    engine.state.activePlayer != nil
  }

  private var middleButtonIcon: String {
    if engine.state.isGameOver {
      return "pause.fill"
    }

    if engine.state.isPaused {
      return "play.fill"
    }

    if engine.state.activePlayer == nil {
      return "play.fill"
    }

    return "pause.fill"
  }

  private func middleButtonAction() {
    if engine.state.isGameOver {
      return
    }

    if engine.state.isPaused {
      engine.resume()
    } else if engine.state.activePlayer != nil {
      engine.pause()
    } else {
      engine.start(player: .white)
    }

    HapticsManager.tap()
  }

  private var controlView: some View {
    HStack(spacing: 12) {
      if !isRunning {
        controlButton(
          systemName: "arrow.counterclockwise",
          action: {
              showingResetConfirmation = true
          }
        )
        .transition(.scale.combined(with: .opacity))
      }

      controlButton(
        systemName: middleButtonIcon,
        action: {
          middleButtonAction()
        }
      )
      .disabled(engine.state.isGameOver)

      if !isRunning {
        controlButton(
          systemName: "gearshape",
          action: {
            showingSettings = true
          }
        )
        .transition(.scale.combined(with: .opacity))
      }
    }
    .animation(
      .spring(duration: 0.3),
      value: isRunning
    )
  }

  private var isPaused: Bool {
    engine.state.isPaused
  }

  private func togglePause() {
    if isPaused {
      engine.resume()
    } else {
      engine.pause()
    }

    HapticsManager.tap()
  }

  private func restart() {
    engine.reset()
    HapticsManager.tap()
  }

  func tap(_ player: Player) {
    guard !isTapLocked, !engine.state.isPaused else { return }

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
  func playerView(
    _ player: Player,
    isLandscape: Bool
  ) -> some View {
    PlayerClockView(
      engine: engine,
      player: player,
      rotate: rotateFor(
        player,
        isLandscape: isLandscape
      )
    ) {
      tap(player)
    }
    .contentShape(Rectangle())
  }

  @ViewBuilder
  private func controlButton(
    systemName: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: systemName)
        .font(.system(size: 20, weight: .semibold))
        .frame(width: 48, height: 48)
    }
    .buttonStyle(.glass)
  }
}

#Preview {
  ContentView()
    .modelContainer(
      for: TimeControlModel.self,
      inMemory: true
    )
}
