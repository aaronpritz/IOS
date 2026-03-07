import SwiftUI

struct AddCustomSiteView: View {
    @EnvironmentObject var favStore: FavoriteSitesStore
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var location = ""
    @State private var country = ""
    @State private var region: DiveSite.DiveRegion = .americas
    @State private var description = ""
    @State private var maxDepth = 60
    @State private var difficulty: DiveSite.DiveDifficulty = .beginner
    @State private var highlightsText = ""
    @State private var rating = 4.0

    var body: some View {
        NavigationStack {
            Form {
                Section("Site Info") {
                    TextField("Site Name", text: $name)
                    TextField("Location (e.g. Maui)", text: $location)
                    TextField("Country", text: $country)
                    Picker("Region", selection: $region) {
                        ForEach(DiveSite.DiveRegion.allCases, id: \.self) { r in
                            Text(r.rawValue).tag(r)
                        }
                    }
                }

                Section("Details") {
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    Stepper("Max Depth: \(maxDepth) ft", value: $maxDepth, in: 10...300, step: 5)
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach([DiveSite.DiveDifficulty.beginner, .intermediate, .advanced], id: \.self) { d in
                            Text(d.rawValue).tag(d)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    TextField("e.g. Coral, Turtles, Clear water", text: $highlightsText)
                } header: {
                    Text("Highlights (comma-separated)")
                }

                Section("Rating") {
                    HStack {
                        Text(String(format: "%.1f", rating))
                            .font(.headline)
                        Slider(value: $rating, in: 1...5, step: 0.5)
                            .tint(.yellow)
                    }
                }
            }
            .navigationTitle("Add Dive Site")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let highlights = highlightsText.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
                        let site = DiveSite(
                            name: name,
                            location: location,
                            country: country,
                            region: region,
                            description: description.isEmpty ? "A custom dive site." : description,
                            maxDepthFeet: maxDepth,
                            difficulty: difficulty,
                            highlights: highlights.isEmpty ? ["Custom site"] : highlights,
                            bestMonths: "Year-round",
                            waterTempRangeFahrenheit: "—",
                            visibilityFeet: "—",
                            rating: rating
                        )
                        favStore.addCustomSite(site)
                        dismiss()
                    }
                    .disabled(name.isEmpty || location.isEmpty || country.isEmpty)
                    .bold()
                }
            }
        }
    }
}

#Preview {
    AddCustomSiteView()
        .environmentObject(FavoriteSitesStore())
}
