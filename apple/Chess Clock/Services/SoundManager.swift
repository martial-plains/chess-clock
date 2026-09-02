//
//  SoundManager.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import AVFoundation
import AudioToolbox

final class SoundManager {

  static let shared = SoundManager()

  private var flagFallSoundID: SystemSoundID = 0
  private var moveSoundID: SystemSoundID = 1104

  init() {
    configureAudioSession()
    registerSoundAssets()
  }

  private func configureAudioSession() {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playback, mode: .default, options: [])
      try session.setActive(true)
    } catch {
      print("Failed to force background playback session: \(error)")
    }
  }

  private func registerSoundAssets() {
    if let flagURL = Bundle.main.url(forResource: "flag", withExtension: "wav") {
      AudioServicesCreateSystemSoundID(flagURL as CFURL, &flagFallSoundID)
    }

    if let moveURL = Bundle.main.url(forResource: "move", withExtension: "wav") {
      AudioServicesCreateSystemSoundID(moveURL as CFURL, &moveSoundID)
    }
  }

  func playFlagFall() {
    if flagFallSoundID != 0 {
      AudioServicesPlaySystemSound(flagFallSoundID)
    }
  }

  func playMove() {
    AudioServicesPlaySystemSound(moveSoundID)
  }
}
