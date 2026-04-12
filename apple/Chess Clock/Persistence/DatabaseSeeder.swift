//
//  DatabaseSeeder.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.04.10.
//

import SwiftData

enum DatabaseSeeder {
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<TimeControlModel>()
        let existing = (try? context.fetch(descriptor)) ?? []

        guard existing.isEmpty else { return }

        let defaults = DefaultPresets.all
        for (index, preset) in defaults.enumerated() {
            let model = TimeControlModel(
                name: preset.name,
                control: preset.control
            )
            model.isDefault = index == 0
            context.insert(model)
        }
        try? context.save()
    }
}
