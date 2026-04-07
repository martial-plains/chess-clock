//
//  SoundManager.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import AVFoundation

final class SoundManager {

    static let shared = SoundManager()

    private var player: AVAudioPlayer?

    func playFlagFall() {

        guard
            let url = Bundle.main.url(
                forResource: "flag",
                withExtension: "wav")
        else { return }

        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }

}
