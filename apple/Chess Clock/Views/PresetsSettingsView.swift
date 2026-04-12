//
//  GeneralSettingsView.swift
//  Chess Clock
//
//  Created by Allister Isaiah Harvey on 2026.04.07.
//

import SwiftData
import SwiftUI


struct PresetsSettingsView: View {


    @Environment(\.modelContext) private var context
    @Query(sort: \TimeControlModel.sortIndex)
    private var presets: [TimeControlModel]


    @State private var selection = Set<PersistentIdentifier>()
    @State private var isPresentingAddPreset = false
    @State private var isShowingDeleteConfirm = false


    var body: some View {
        List(selection: $selection) {

            Section {
                ForEach(presets) { preset in
                    PresetRowView(
                        preset: preset,
                        isDefault: preset.isDefault
                    )
                    .tag(preset.id)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        setDefault(preset)
                    }
                    .swipeActions(edge: .trailing) {
#if os(iOS)
                        if presets.count > 1 {
                            Button(role: .destructive) {
                                deletePreset(preset)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
#endif
                    }
                }

                .onMove(perform: movePreset)
                .onDelete(perform: deletePresets)
            }
        }
        .navigationTitle("Time Presets")
        .toolbar { toolbar }
        .sheet(isPresented: $isPresentingAddPreset) {
            AddPresetView { newPreset in
                addPreset(preset: newPreset)
            }
        }
        .alert("Delete Presets?", isPresented: $isShowingDeleteConfirm) {
            Button("Delete", role: .destructive) {
                deleteSelected()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently delete \(selection.count) preset(s).")
        }
    }


    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {

        ToolbarItem(placement: .primaryAction) {
            Button {
                isPresentingAddPreset = true
            } label: {
                Image(systemName: "plus")
            }
        }

#if os(iOS)
        ToolbarItem(placement: .secondaryAction) {
            EditButton()
        }
#endif
    }


    private struct PresetRowView: View {
        let preset: TimeControlModel
        let isDefault: Bool

        var body: some View {
            HStack(spacing: 12) {

                Image(systemName: isDefault
                      ? "largecircle.fill.circle"
                      : "circle")
                    .foregroundStyle(isDefault ? .blue : .secondary)

                Text(preset.name)
                    .font(.body.weight(isDefault ? .semibold : .regular))
                    .foregroundStyle(isDefault ? .primary : .secondary)

                Spacer()
            }
            .padding(.vertical, 4)
        }
    }


    func addPreset(preset: TimeControlModel) {
        context.insert(preset)
        try? context.save()
    }

    func deletePresets(at offsets: IndexSet) {
        for index in offsets {
            context.delete(presets[index])
        }
        try? context.save()
    }

    func deletePreset(_ preset: TimeControlModel) {
        guard presets.count > 1 else { return }

        let wasDefault = preset.isDefault
        context.delete(preset)

        if wasDefault {
            presets.first?.isDefault = true
        }

        try? context.save()
    }

    func deleteSelected() {
        let toDelete = presets.filter { selection.contains($0.id) }

        for item in toDelete {
            let wasDefault = item.isDefault
            context.delete(item)

            if wasDefault {
                presets.first(where: { !selection.contains($0.id) })?.isDefault = true
            }
        }

        selection.removeAll()
        try? context.save()
    }

    func movePreset(from source: IndexSet, to destination: Int) {
        var updated = presets
        updated.move(fromOffsets: source, toOffset: destination)

        for (index, preset) in updated.enumerated() {
            preset.sortIndex = index
        }

        try? context.save()
    }

    func setDefault(_ selected: TimeControlModel) {
        for preset in presets {
            preset.isDefault = (preset.id == selected.id)
        }

        try? context.save()
    }
}
