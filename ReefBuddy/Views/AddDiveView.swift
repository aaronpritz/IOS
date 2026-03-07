import SwiftUI

struct AddDiveView: View {
    @EnvironmentObject var store: DiveStore
    @EnvironmentObject var units: UnitSettings
    @Environment(\.dismiss) var dismiss

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
            .navigationTitle("Log a Dive")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveDive()
                    }
                    .disabled(location.isEmpty || diveSite.isEmpty)
                    .bold()
                }
            }
            .onAppear {
                // Set defaults based on current unit system
                if units.unitSystem == .metric {
                    maxDepth = 10
                    waterTemp = 25
                    visibility = 10
                }
            }
        }
    }

    private func saveDive() {
        let dive = Dive(
            date: date,
            location: location,
            diveSite: diveSite,
            maxDepth: units.toStoredDepth(maxDepth),
            bottomTime: bottomTime,
            waterTemp: units.toStoredTemp(waterTemp),
            visibility: units.toStoredVisibility(visibility),
            buddyName: buddyName,
            notes: notes,
            rating: rating
        )
        store.addDive(dive)
        dismiss()
    }
}

#Preview {
    AddDiveView()
        .environmentObject(DiveStore())
        .environmentObject(UnitSettings())
}
