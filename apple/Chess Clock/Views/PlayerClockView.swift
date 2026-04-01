//
//  PlayerClockView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftUI

struct PlayerClockView: View {

    let player: Player
    let rotate: Bool
    let time: TimeInterval
    let isActive: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            Text(format(time))
                .font(.system(size: 64,
                              weight: .bold,
                              design: .monospaced))
                .rotationEffect(
                    rotate && player == .black
                    ? .degrees(180)
                    : .zero
                )
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .background(isActive ? .green : .black)
                .foregroundStyle(.white)
        }
    }
}
