import SwiftUI

/// Manages saving and loading dives using JSON stored on device
class DiveStore: ObservableObject {
    @Published var dives: [Dive] = []

    private let saveKey = "ReefBuddyDives"

    init() {
        loadDives()
        // If first launch with no saved dives, load samples
        if dives.isEmpty {
            dives = Dive.sampleDives
        }
    }

    func addDive(_ dive: Dive) {
        dives.insert(dive, at: 0)
        saveDives()
    }

    func deleteDive(at offsets: IndexSet) {
        for index in offsets {
            PhotoStorage.shared.deletePhotos(for: dives[index].id)
        }
        dives.remove(atOffsets: offsets)
        saveDives()
    }

    func deleteDive(_ dive: Dive) {
        PhotoStorage.shared.deletePhotos(for: dive.id)
        dives.removeAll { $0.id == dive.id }
        saveDives()
    }

    func updateDive(_ dive: Dive) {
        if let index = dives.firstIndex(where: { $0.id == dive.id }) {
            dives[index] = dive
            saveDives()
        }
    }

    // MARK: - Stats

    var totalDives: Int {
        dives.count
    }

    var totalBottomTime: Int {
        dives.reduce(0) { $0 + $1.bottomTime }
    }

    var deepestDive: Double {
        dives.map(\.maxDepth).max() ?? 0
    }

    var averageDepth: Double {
        guard !dives.isEmpty else { return 0 }
        return dives.map(\.maxDepth).reduce(0, +) / Double(dives.count)
    }

    var favoriteLocation: String {
        guard !dives.isEmpty else { return "—" }
        let locations = dives.map(\.location)
        let counts = Dictionary(grouping: locations, by: { $0 }).mapValues(\.count)
        return counts.max(by: { $0.value < $1.value })?.key ?? "—"
    }

    // MARK: - Persistence

    private func saveDives() {
        if let data = try? JSONEncoder().encode(dives) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func loadDives() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Dive].self, from: data) {
            dives = decoded
        }
    }
}
