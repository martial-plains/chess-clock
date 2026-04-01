//
//  AppLifecycle.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftUI
import Combine

final class AppLifecycle: ObservableObject {
    

    func appMovedToBackground(engine: ClockEngine) {
        engine.pause()
    }

    func appReturned(engine: ClockEngine) {
        // timestamps automatically recover
    }
}
