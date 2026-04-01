//
//  ClockView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftUI

struct ClockView: View {

    let time: TimeInterval
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(format(time))
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(isActive ? Color.green : Color.gray.opacity(0.3))
                .foregroundColor(.primary)
        }
    }
}

func format(_ time: TimeInterval) -> String {

    let t = max(0, Int(time))
    let m = t / 60
    let s = t % 60

    return String(format: "%02d:%02d", m, s)
}
