import SwiftUI

enum DiveSortOption: String, CaseIterable {
    case dateNewest = "Newest"
    case dateOldest = "Oldest"
    case deepest = "Deepest"
    case shallowest = "Shallowest"
    case highestRated = "Top Rated"
}

enum DiveFilterOption: String, CaseIterable {
    case all = "All"
    case fiveStar = "5 Stars"
    case fourPlus = "4+ Stars"
    case deep = "Deep (80+ ft)"
    case shallow = "Shallow (<40 ft)"
}

struct DiveListView: View {
    @EnvironmentObject var store: DiveStore
    @EnvironmentObject var units: UnitSettings
    @State private var showingAddDive = false
    @State private var sortOption: DiveSortOption = .dateNewest
    @State private var filterOption: DiveFilterOption = .all
    @State private var searchText = ""

    var filteredAndSortedDives: [Dive] {
        var result = store.dives

        // Search
        if !searchText.isEmpty {
            result = result.filter {
                $0.diveSite.localizedCaseInsensitiveContains(searchText) ||
                $0.location.localizedCaseInsensitiveContains(searchText) ||
                $0.buddyName.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Filter
        switch filterOption {
        case .all: break
        case .fiveStar: result = result.filter { $0.rating == 5 }
        case .fourPlus: result = result.filter { $0.rating >= 4 }
        case .deep: result = result.filter { $0.maxDepth >= 80 }
        case .shallow: result = result.filter { $0.maxDepth < 40 }
        }

        // Sort
        switch sortOption {
        case .dateNewest: result.sort { $0.date > $1.date }
        case .dateOldest: result.sort { $0.date < $1.date }
        case .deepest: result.sort { $0.maxDepth > $1.maxDepth }
        case .shallowest: result.sort { $0.maxDepth < $1.maxDepth }
        case .highestRated: result.sort { $0.rating > $1.rating }
        }

        return result
    }

    /// Returns the dive number (chronological order, oldest = #1)
    func diveNumber(for dive: Dive) -> Int {
        let sorted = store.dives.sorted { $0.date < $1.date }
        if let index = sorted.firstIndex(where: { $0.id == dive.id }) {
            return index + 1
        }
        return 0
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if store.dives.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "water.waves")
                            .font(.system(size: 60))
                            .foregroundStyle(.cyan.opacity(0.5))

                        Text("No Dives Yet")
                            .font(.title2.bold())

                        Text("Tap + to log your first dive!")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    VStack(spacing: 0) {
                        // Sort & Filter bar
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                Menu {
                                    ForEach(DiveSortOption.allCases, id: \.self) { option in
                                        Button {
                                            sortOption = option
                                        } label: {
                                            if sortOption == option {
                                                Label(option.rawValue, systemImage: "checkmark")
                                            } else {
                                                Text(option.rawValue)
                                            }
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "arrow.up.arrow.down")
                                        Text(sortOption.rawValue)
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color(.systemGray5))
                                    .clipShape(Capsule())
                                }

                                ForEach(DiveFilterOption.allCases, id: \.self) { option in
                                    Button {
                                        withAnimation { filterOption = option }
                                    } label: {
                                        Text(option.rawValue)
                                            .font(.caption)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(
                                                filterOption == option
                                                ? Color.cyan
                                                : Color(.systemGray5)
                                            )
                                            .foregroundStyle(
                                                filterOption == option ? .white : .primary
                                            )
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }

                        List {
                            ForEach(filteredAndSortedDives) { dive in
                                NavigationLink(destination: DiveDetailView(dive: dive)) {
                                    DiveRowView(dive: dive, diveNumber: diveNumber(for: dive))
                                }
                            }
                            .onDelete { offsets in
                                let divesToDelete = offsets.map { filteredAndSortedDives[$0] }
                                for dive in divesToDelete {
                                    store.deleteDive(dive)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("ReefBuddy")
            .searchable(text: $searchText, prompt: "Search dives...")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddDive = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddDive) {
                AddDiveView()
            }
        }
    }
}

// MARK: - Dive Row Component

struct DiveRowView: View {
    let dive: Dive
    var diveNumber: Int = 0
    @EnvironmentObject var units: UnitSettings

    var body: some View {
        HStack(spacing: 12) {
            // Depth indicator circle with dive number
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 50, height: 50)

                VStack(spacing: 0) {
                    if diveNumber > 0 {
                        Text("#\(diveNumber)")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    Text(units.depthDisplay(dive.maxDepth))
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(dive.diveSite)
                    .font(.headline)

                Text(dive.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    Label(dive.bottomTimeDisplay, systemImage: "clock")
                    Label(dive.formattedDate, systemImage: "calendar")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(.caption2)
                Text("\(dive.rating)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DiveListView()
        .environmentObject(DiveStore())
        .environmentObject(UnitSettings())
}
