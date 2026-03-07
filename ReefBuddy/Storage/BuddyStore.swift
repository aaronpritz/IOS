import SwiftUI

/// Manages saving and loading dive buddies
class BuddyStore: ObservableObject {
    @Published var buddies: [DiveBuddy] = []

    private let saveKey = "ReefBuddyBuddies"

    init() {
        loadBuddies()
    }

    var favoriteBuddies: [DiveBuddy] {
        buddies.filter(\.isFavorite)
    }

    func addBuddy(_ buddy: DiveBuddy) {
        buddies.insert(buddy, at: 0)
        saveBuddies()
    }

    func updateBuddy(_ buddy: DiveBuddy) {
        if let index = buddies.firstIndex(where: { $0.id == buddy.id }) {
            buddies[index] = buddy
            saveBuddies()
        }
    }

    func deleteBuddy(_ buddy: DiveBuddy) {
        buddies.removeAll { $0.id == buddy.id }
        saveBuddies()
    }

    func deleteBuddy(at offsets: IndexSet) {
        buddies.remove(atOffsets: offsets)
        saveBuddies()
    }

    func toggleFavorite(_ buddy: DiveBuddy) {
        if let index = buddies.firstIndex(where: { $0.id == buddy.id }) {
            buddies[index].isFavorite.toggle()
            saveBuddies()
        }
    }

    /// Get the number of dives shared with a buddy by name
    func sharedDiveCount(buddyName: String, dives: [Dive]) -> Int {
        dives.filter { $0.buddyName.localizedCaseInsensitiveContains(buddyName) ||
                       buddyName.localizedCaseInsensitiveContains($0.buddyName) }.count
    }

    /// Get dives shared with a buddy
    func sharedDives(buddyName: String, dives: [Dive]) -> [Dive] {
        dives.filter { $0.buddyName.localizedCaseInsensitiveContains(buddyName) ||
                       buddyName.localizedCaseInsensitiveContains($0.buddyName) }
    }

    private func saveBuddies() {
        if let data = try? JSONEncoder().encode(buddies) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func loadBuddies() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([DiveBuddy].self, from: data) {
            buddies = decoded
        }
    }
}
