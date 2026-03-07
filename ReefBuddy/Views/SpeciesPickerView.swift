import SwiftUI

/// Full-screen species picker for adding sightings to a dive
struct SpeciesPickerView: View {
    @Binding var sightings: [SpeciesSighting]
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""

    private var filteredCategories: [(category: MarineSpecies.Category, species: [MarineSpecies])] {
        if searchText.isEmpty {
            return MarineSpecies.byCategory
        }
        return MarineSpecies.byCategory.compactMap { group in
            let filtered = group.species.filter {
                $0.commonName.localizedCaseInsensitiveContains(searchText) ||
                $0.scientificName.localizedCaseInsensitiveContains(searchText)
            }
            return filtered.isEmpty ? nil : (group.category, filtered)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                // Current sightings summary
                if !sightings.isEmpty {
                    Section {
                        ForEach(sightings) { sighting in
                            if let species = sighting.species {
                                HStack {
                                    Image(systemName: species.icon)
                                        .foregroundStyle(.cyan)
                                        .frame(width: 24)
                                    VStack(alignment: .leading) {
                                        Text(species.commonName)
                                            .font(.subheadline.bold())
                                        if let note = sighting.note, !note.isEmpty {
                                            Text(note)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    Spacer()
                                    Text(sighting.count.rawValue)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.cyan.opacity(0.2))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .onDelete { offsets in
                            sightings.remove(atOffsets: offsets)
                        }
                    } header: {
                        Text("Logged Sightings (\(sightings.count))")
                    }
                }

                // Species catalog
                ForEach(filteredCategories, id: \.category) { group in
                    Section {
                        ForEach(group.species) { species in
                            SpeciesRow(
                                species: species,
                                isAdded: sightings.contains { $0.speciesID == species.id },
                                onAdd: { addSighting(species) },
                                onRemove: { removeSighting(species) }
                            )
                        }
                    } header: {
                        Label(group.category.rawValue, systemImage: group.category.icon)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search species")
            .navigationTitle("Marine Life")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .bold()
                }
            }
        }
    }

    private func addSighting(_ species: MarineSpecies) {
        let sighting = SpeciesSighting(speciesID: species.id, count: .one)
        sightings.append(sighting)
    }

    private func removeSighting(_ species: MarineSpecies) {
        sightings.removeAll { $0.speciesID == species.id }
    }
}

// MARK: - Species Row

struct SpeciesRow: View {
    let species: MarineSpecies
    let isAdded: Bool
    let onAdd: () -> Void
    let onRemove: () -> Void

    @State private var showDetail = false

    var body: some View {
        HStack {
            Image(systemName: species.icon)
                .foregroundStyle(.cyan)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(species.commonName)
                    .font(.subheadline.bold())
                Text(species.scientificName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()
            }

            Spacer()

            if isAdded {
                Button {
                    onRemove()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.title3)
                }
            } else {
                Button {
                    onAdd()
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(.cyan)
                        .font(.title3)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showDetail = true
        }
        .sheet(isPresented: $showDetail) {
            SpeciesDetailSheet(species: species)
        }
    }
}

// MARK: - Species Detail Sheet

struct SpeciesDetailSheet: View {
    let species: MarineSpecies
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: species.icon)
                    .font(.system(size: 48))
                    .foregroundStyle(.cyan)
                    .padding()
                    .background(Circle().fill(Color.cyan.opacity(0.1)))

                VStack(spacing: 4) {
                    Text(species.commonName)
                        .font(.title2.bold())
                    Text(species.scientificName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .italic()
                }

                HStack {
                    Image(systemName: species.category.icon)
                        .foregroundStyle(.cyan)
                    Text(species.category.rawValue)
                        .font(.subheadline)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .clipShape(Capsule())

                Text(species.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 30)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Compact Sighting Editor (for AddDiveView)

struct SightingsSection: View {
    @Binding var sightings: [SpeciesSighting]
    @State private var showPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Sighting chips
            if !sightings.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach($sightings) { $sighting in
                            if let species = sighting.species {
                                SightingChip(species: species, sighting: $sighting) {
                                    sightings.removeAll { $0.id == sighting.id }
                                }
                            }
                        }
                    }
                }
            }

            Button {
                showPicker = true
            } label: {
                Label(sightings.isEmpty ? "Add Species" : "Add More (\(sightings.count) logged)", systemImage: "plus.circle")
                    .font(.subheadline)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
            }
        }
        .sheet(isPresented: $showPicker) {
            SpeciesPickerView(sightings: $sightings)
        }
    }
}

// MARK: - Sighting Chip

struct SightingChip: View {
    let species: MarineSpecies
    @Binding var sighting: SpeciesSighting
    let onRemove: () -> Void

    @State private var showEditor = false

    var body: some View {
        Button {
            showEditor = true
        } label: {
            HStack(spacing: 6) {
                Image(systemName: species.icon)
                    .font(.caption)
                Text(species.commonName)
                    .font(.caption)
                Text("(\(sighting.count.rawValue))")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.cyan.opacity(0.15))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showEditor) {
            SightingEditor(sighting: $sighting, species: species, onRemove: onRemove)
                .presentationDetents([.height(300)])
        }
    }
}

// MARK: - Sighting Editor

struct SightingEditor: View {
    @Binding var sighting: SpeciesSighting
    let species: MarineSpecies
    let onRemove: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: species.icon)
                            .foregroundStyle(.cyan)
                        Text(species.commonName)
                            .font(.headline)
                    }
                }

                Section("How many?") {
                    Picker("Count", selection: $sighting.count) {
                        ForEach(SpeciesSighting.SightingCount.allCases, id: \.self) { count in
                            Text(count.rawValue).tag(count)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Note (optional)") {
                    TextField("e.g. Juveniles, feeding, mating...", text: Binding(
                        get: { sighting.note ?? "" },
                        set: { sighting.note = $0.isEmpty ? nil : $0 }
                    ))
                }

                Section {
                    Button(role: .destructive) {
                        onRemove()
                        dismiss()
                    } label: {
                        Label("Remove Sighting", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Edit Sighting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
