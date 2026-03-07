import SwiftUI

struct AddDiveView: View {
    @EnvironmentObject var store: DiveStore
    @EnvironmentObject var units: UnitSettings
    @Environment(\.dismiss) var dismiss

    // Optional dive for edit mode
    var editingDive: Dive? = nil
    var isEditing: Bool { editingDive != nil }

    @State private var date = Date()
    @State private var location = ""
    @State private var diveSite = ""
    @State private var maxDepth = 30.0    // display value in current unit
    @State private var bottomTime = 30
    @State private var waterTemp = 77.0   // display value in current unit
    @State private var visibility = 30     // display value in current unit
    @State private var buddyName = ""
    @State private var notes = ""
    @State private var rating = 3
    @State private var currentStrength: Dive.CurrentStrength = .none
    @State private var entryType: Dive.EntryType = .boat

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - When & Where
                Section {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Location (e.g. Bali, Indonesia)", text: $location)
                    TextField("Dive Site (e.g. Blue Corner)", text: $diveSite)
                } header: {
                    Label("When & Where", systemImage: "mappin.and.ellipse")
                }

                // MARK: - Dive Details
                Section {
                    VStack(alignment: .leading) {
                        Text("Max Depth: \(Int(maxDepth)) \(units.depthUnit)")
                        Slider(value: $maxDepth, in: units.depthRange, step: 1)
                    }
                    Stepper("Bottom Time: \(bottomTime) min", value: $bottomTime, in: 1...120)
                } header: {
                    Label("Dive Details", systemImage: "arrow.down.to.line")
                }

                // MARK: - Conditions
                Section {
                    VStack(alignment: .leading) {
                        Text("Water Temp: \(Int(waterTemp))\(units.tempUnit)")
                        Slider(value: $waterTemp, in: units.tempRange, step: 1)
                    }
                    Stepper("Visibility: \(visibility) \(units.visibilityUnit)",
                            value: $visibility,
                            in: units.visibilityRange)

                    Picker("Current", selection: $currentStrength) {
                        ForEach(Dive.CurrentStrength.allCases, id: \.self) { strength in
                            Text(strength.rawValue).tag(strength)
                        }
                    }

                    Picker("Entry", selection: $entryType) {
                        ForEach(Dive.EntryType.allCases, id: \.self) { entry in
                            Text(entry.rawValue).tag(entry)
                        }
                    }
                } header: {
                    Label("Conditions", systemImage: "thermometer.medium")
                }

                // MARK: - Buddy & Notes
                Section {
                    TextField("Buddy Name", text: $buddyName)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Label("Buddy & Notes", systemImage: "person.2")
                }

                // MARK: - Rating
                Section {
                    HStack {
                        Text("Rating")
                        Spacer()
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .foregroundStyle(star <= rating ? .yellow : .gray)
                                .onTapGesture {
                                    rating = star
                                }
                        }
                    }
                } header: {
                    Label("How was it?", systemImage: "star")
                }
            }
            .navigationTitle(isEditing ? "Edit Dive" : "Log a Dive")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Update" : "Save") {
                        saveDive()
                    }
                    .disabled(location.isEmpty || diveSite.isEmpty)
                    .bold()
                }
            }
            .onAppear {
                if let dive = editingDive {
                    // Populate fields from existing dive
                    date = dive.date
                    location = dive.location
                    diveSite = dive.diveSite
                    maxDepth = units.toDisplayDepth(dive.maxDepth)
                    bottomTime = dive.bottomTime
                    waterTemp = dive.waterTemp.map { units.toDisplayTemp($0) } ?? (units.unitSystem == .imperial ? 77 : 25)
                    visibility = dive.visibility.map { units.toDisplayVisibility($0) } ?? (units.unitSystem == .imperial ? 30 : 10)
                    buddyName = dive.buddyName
                    notes = dive.notes
                    rating = dive.rating
                    currentStrength = dive.currentStrength ?? .none
                    entryType = dive.entryType ?? .boat
                } else if units.unitSystem == .metric {
                    maxDepth = 10
                    waterTemp = 25
                    visibility = 10
                }
            }
        }
    }

    private func saveDive() {
        var dive = Dive(
            id: editingDive?.id ?? UUID(),
            date: date,
            location: location,
            diveSite: diveSite,
            maxDepth: units.toStoredDepth(maxDepth),
            bottomTime: bottomTime,
            waterTemp: units.toStoredTemp(waterTemp),
            visibility: units.toStoredVisibility(visibility),
            buddyName: buddyName,
            notes: notes,
            rating: rating,
            currentStrength: currentStrength,
            entryType: entryType
        )

        if isEditing {
            store.updateDive(dive)
        } else {
            store.addDive(dive)
        }
        dismiss()
    }
}

#Preview {
    AddDiveView()
        .environmentObject(DiveStore())
        .environmentObject(UnitSettings())
}
