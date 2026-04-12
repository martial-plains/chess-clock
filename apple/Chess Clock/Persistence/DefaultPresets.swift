//
//  DefaultPresets.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.04.10.
//

enum DefaultPresets {
    static let all: [TimeControlModel] = [
        TimeControlModel(
            name: "1 min",
            control: TimeControl(
                mode: .fischer,
                stages: [ClockStage(movesRequired: nil, baseTime: 60, increment: 0)]
            ),
        ),
        TimeControlModel(
            name: "1 min | 1 sec",
            control: TimeControl(
                mode: .simple,
                stages: [ClockStage(movesRequired: nil, baseTime: 60, increment: 1)]
            )
        ),
        TimeControlModel(
            name: "2 min | 1 sec",
            control: TimeControl(
                mode: .fischer,
                stages: [ClockStage(movesRequired: nil, baseTime: 120, increment: 1)]
            ),
        ),
        TimeControlModel(
            name: "3 min",
            control: TimeControl(
                mode: .fischer,
                stages: [ClockStage(movesRequired: nil, baseTime: 300, increment: 0)]
            ),
        ),
        TimeControlModel(
            name: "3 min | 2 sec",
            control: TimeControl(
                mode: .fischer,
                stages: [ClockStage(movesRequired: nil, baseTime: 180, increment: 2)]
            ),
        ),
        TimeControlModel(
            name: "5 min",
            control: TimeControl(
                mode: .fischer,
                stages: [ClockStage(movesRequired: nil, baseTime: 300, increment: 0)]
            ),
        ),
        TimeControlModel(
            name: "5 min | 5 sec",
            control: TimeControl(
                mode: .fischer,
                stages: [ClockStage(movesRequired: nil, baseTime: 300, increment: 5)]
            ),
        ),
        TimeControlModel(
            name: "10 min",
            control: TimeControl(
                mode: .fischer,
                stages: [ClockStage(movesRequired: nil, baseTime: 600, increment: 0)]
            ),
            isDefault: true
        ),
        TimeControlModel(
            name: "15 min | 10 sec",
            control: TimeControl(
                mode: .fischer,
                stages: [ClockStage(movesRequired: nil, baseTime: 900, increment: 0)]
            ),
        ),
        TimeControlModel(
            name: "20 min",
            control: TimeControl(
                mode: .fischer,
                stages: [ClockStage(movesRequired: nil, baseTime: 1200, increment: 0)]
            ),
        ),
        TimeControlModel(
            name: "30 min",
            control: TimeControl(
                mode: .fischer,
                stages: [ClockStage(movesRequired: nil, baseTime: 1800, increment: 0)]
            ),
        )
    ]
}
