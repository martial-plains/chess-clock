//
//  ThemeColor.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

import SwiftUI

enum ThemeColor: String, CaseIterable, Identifiable, Codable {
    case green = "Green"
    case blue = "Blue"
    case orange = "Orange"
    case aqua = "Aqua"
    case gold = "Gold"
    case rose = "Rose"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .green: return .green
        case .blue: return .blue
        case .orange: return .orange
        case .aqua: return .mint
        case .gold: return .yellow
        case .rose: return .pink
        }
    }
}
