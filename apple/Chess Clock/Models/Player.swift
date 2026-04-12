//
//  Player.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.03.31.
//

enum Player: String, Codable {
    case white
    case black

    var opponent: Player {
        self == .white ? .black : .white
    }
}
