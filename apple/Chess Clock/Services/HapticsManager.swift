//
//  HapticsManager.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

#if os(iOS)
import UIKit
#endif

enum HapticsManager {
    static func flagFall() {
#if os(iOS)
        UINotificationFeedbackGenerator().notificationOccurred(.error)
#endif
    }

    static func tap() {
#if os(iOS)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
#endif
    }
}
