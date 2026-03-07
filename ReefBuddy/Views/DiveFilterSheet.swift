import SwiftUI

/// Advanced multi-criteria filter for the dive list
struct DiveFilterCriteria {
    var minDepth: Double? = nil
    var maxDepth: Double? = nil
    var minRating: Int = 0
    var location: String = ""
    var buddy: String = ""
    var entryType: Dive.EntryType? = nil
    var currentStrength: Dive.CurrentStrength? = nil
    var dateFrom: Date? = nil
    var dateTo: Date? = nil
    var hasPhotos: Bool = false
    var hasSpecies: Bool = false
    var notesContain: String = ""

    var isActive: Bool {
        minDepth != nil || maxDepth != nil || minRating > 0 ||
        !location.isEmpty || !buddy.isEmpty ||
        entryType != nil || currentStrength != nil ||
        dateFrom != nil || dateTo != nil ||
        hasPhotos || hasSpecies || !notesContain.isEmpty
    }

    var activeFilterCount: Int {
        var count = 0
        if minDepth != nil || maxDepth != nil { count += 1 }
        if minRating > 0 { count += 1 }
        if !location.isEmpty { count += 1 }
        if !buddy.isEmpty { count += 1 }
        if entryType != nil { count += 1 }
        if currentStrength != nil { count += 1 }
        if dateFrom != nil || dateTo != nil { count += 1 }
        if hasPhotos { count += 1 }
        if hasSpecies { count += 1 }
        if !notesContain.isEmpty { count += 1 }
        return count
    }

    func matches(_ dive: Dive) -> Bool {
        if let min = minDepth, dive.maxDepth < min { return false }
        if let max = maxDepth, dive.maxDepth > max { return false }
        if minRating > 0, dive.rating < minRating { return false }
        if !location.isEmpty, !dive.location.localizedCaseInsensitiveContains(location) { return false }
        if !buddy.isEmpty, !dive.buddyName.localizedCaseInsensitiveContains(buddy) { return false }
        if let entry = entryType, dive.entryType != entry { return false }
        if let current = currentStrength, dive.currentStrength != current { return false }
        if let from = dateFrom, dive.date < from { return false }
        if let to = dateTo, dive.date > Calendar.current.date(byAdding: .day, value: 1, to: to) ?? to { return false }
        if hasPhotos, (dive.photoFilenames ?? []).isEmpty { return false }
        if hasSpecies, (dive.speciesSightings ?? []).isEmpty { return false }
        if !notesContain.isEmpty, !dive.notes.localizedCaseInsensitiveContains(notesContain) { return false }
        return true
    }

    mutating func reset() {
        self = DiveFilterCriteria()
    }
}

struct DiveFilterSheet: View {
    @Binding var criteria: DiveFilterCriteria
    @EnvironmentObject var store: DiveStore
    @EnvironmentObject var units: UnitSettings
    @Environment(\.dismiss) var dismiss

    // Local state for toggleable date pickers
    @State private var useDepthRange = false
    @State private var depthLow = 0.0
    @State private var depthHigh = 130.0
    @State private var useDateRange = false
    @State private var dateFrom = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
    @State private var dateTo = Date()
    @State private var minRating = 0
    @State private var location = ""
    @State private var buddy = ""
    @State private var entryType: Dive.EntryType? = nil
    @State private var currentStrength: Dive.CurrentStrength? = nil
    @State private var hasPhotos = false
    @State private var hasSpecies = false
    @State private var notesContain = ""

    var uniqueLocations: [String] {
        Array(Set(store.dives.map(\.location))).sorted()
    }

    var uniqueBuddies: [String] {
        Array(Set(store.dives.map(\.buddyName).filter { !$0.isEmpty })).sorted()
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Date Range
                Section("Date Range") {
                    Toggle("Filter by date", isOn: $useDateRange)
                    if useDateRange {
                        DatePicker("From", selection: $dateFrom, displayedComponents: .date)
                        DatePicker("To", selection: $dateTo, displayedComponents: .date)
                    }
                }

                // MARK: - Depth
                Section("Depth") {
                    Toggle("Filter by depth", isOn: $useDepthRange)
                    if useDepthRange {
                        VStack(alignment: .leading) {
                            Text("Min: \(Int(depthLow)) \(units.depthUnit)")
                                .font(.caption)
                            Slider(value: $depthLow, in: 0...units.depthRange.upperBound, step: 5)
                        }
                        VStack(alignment: .leading) {
                            Text("Max: \(Int(depthHigh)) \(units.depthUnit)")
                                .font(.caption)
                            Slider(value: $depthHigh, in: 0...units.depthRange.upperBound, step: 5)
                        }
                    }
                }

                // MARK: - Rating
                Section("Minimum Rating") {
                    HStack {
                        ForEach(0...5, id: \.self) { star in
                            Button {
                                minRating = star
                            } label: {
                                if star == 0 {
                                    Text("Any")
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(minRating == 0 ? Color.cyan : Color(.systemGray5))
                                        .foregroundStyle(minRating == 0 ? .white : .primary)
                                        .clipShape(Capsule())
                                } else {
                                    HStack(spacing: 2) {
                                        Text("\(star)")
                                            .font(.caption)
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 8))
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(minRating == star ? Color.cyan : Color(.systemGray5))
                                    .foregroundStyle(minRating == star ? .white : .primary)
                                    .clipShape(Capsule())
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // MARK: - Location & Buddy
                Section("Location & Buddy") {
                    if !uniqueLocations.isEmpty {
                        Picker("Location", selection: $location) {
                            Text("Any").tag("")
                            ForEach(uniqueLocations, id: \.self) { loc in
                                Text(loc).tag(loc)
                            }
                        }
                    }

                    if !uniqueBuddies.isEmpty {
                        Picker("Buddy", selection: $buddy) {
                            Text("Any").tag("")
                            ForEach(uniqueBuddies, id: \.self) { b in
                                Text(b).tag(b)
                            }
                        }
                    }
                }

                // MARK: - Conditions
                Section("Conditions") {
                    Picker("Entry Type", selection: $entryType) {
                        Text("Any").tag(Dive.EntryType?.none)
                        ForEach(Dive.EntryType.allCases, id: \.self) { entry in
                            Text(entry.rawValue).tag(Dive.EntryType?.some(entry))
                        }
                    }

                    Picker("Current", selection: $currentStrength) {
                        Text("Any").tag(Dive.CurrentStrength?.none)
                        ForEach(Dive.CurrentStrength.allCases, id: \.self) { current in
                            Text(current.rawValue).tag(Dive.CurrentStrength?.some(current))
                        }
                    }
                }

                // MARK: - Content
                Section("Content") {
                    Toggle("Has Photos", isOn: $hasPhotos)
                    Toggle("Has Species Sightings", isOn: $hasSpecies)
                    TextField("Notes contain...", text: $notesContain)
                }
            }
            .navigationTitle("Advanced Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        resetAll()
                    }
                    .foregroundStyle(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        applyFilters()
                        dismiss()
                    }
                    .bold()
                }
            }
            .onAppear {
                loadFromCriteria()
            }
        }
    }

    private func loadFromCriteria() {
        if criteria.minDepth != nil || criteria.maxDepth != nil {
            useDepthRange = true
            depthLow = criteria.minDepth.map { units.toDisplayDepth($0) } ?? 0
            depthHigh = criteria.maxDepth.map { units.toDisplayDepth($0) } ?? units.depthRange.upperBound
        }
        if criteria.dateFrom != nil || criteria.dateTo != nil {
            useDateRange = true
            dateFrom = criteria.dateFrom ?? Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
            dateTo = criteria.dateTo ?? Date()
        }
        minRating = criteria.minRating
        location = criteria.location
        buddy = criteria.buddy
        entryType = criteria.entryType
        currentStrength = criteria.currentStrength
        hasPhotos = criteria.hasPhotos
        hasSpecies = criteria.hasSpecies
        notesContain = criteria.notesContain
    }

    private func applyFilters() {
        criteria.minDepth = useDepthRange ? units.toStoredDepth(depthLow) : nil
        criteria.maxDepth = useDepthRange ? units.toStoredDepth(depthHigh) : nil
        criteria.dateFrom = useDateRange ? dateFrom : nil
        criteria.dateTo = useDateRange ? dateTo : nil
        criteria.minRating = minRating
        criteria.location = location
        criteria.buddy = buddy
        criteria.entryType = entryType
        criteria.currentStrength = currentStrength
        criteria.hasPhotos = hasPhotos
        criteria.hasSpecies = hasSpecies
        criteria.notesContain = notesContain
    }

    private func resetAll() {
        useDepthRange = false
        depthLow = 0
        depthHigh = units.depthRange.upperBound
        useDateRange = false
        dateFrom = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
        dateTo = Date()
        minRating = 0
        location = ""
        buddy = ""
        entryType = nil
        currentStrength = nil
        hasPhotos = false
        hasSpecies = false
        notesContain = ""
        criteria.reset()
    }
}

#Preview {
    DiveFilterSheet(criteria: .constant(DiveFilterCriteria()))
        .environmentObject(DiveStore())
        .environmentObject(UnitSettings())
}
