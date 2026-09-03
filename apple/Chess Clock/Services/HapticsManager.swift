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

    static func flagFall(isEnabled: Bool = true) {
        guard isEnabled else { return }
#if os(iOS)
        UINotificationFeedbackGenerator()
            .notificationOccurred(.error)
#endif
    }

    static func tap(isEnabled: Bool = true) {
        guard isEnabled else { return }
#if os(iOS)
        UIImpactFeedbackGenerator(style: .medium)
            .impactOccurred()
#endif
    }

    static func lowTimeWarning(isEnabled: Bool = true) {
        guard isEnabled else { return }
#if os(iOS)
        UINotificationFeedbackGenerator()
            .notificationOccurred(.warning)
#endif
    }
}
