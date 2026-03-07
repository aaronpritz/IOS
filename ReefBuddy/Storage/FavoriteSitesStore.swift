import SwiftUI

/// Manages favorite dive sites and user-added custom sites
class FavoriteSitesStore: ObservableObject {
    @Published var favoriteIDs: Set<String> = []  // site names as IDs
    @Published var customSites: [DiveSite] = []

    private let favKey = "ReefBuddyFavSites"
    private let customKey = "ReefBuddyCustomSites"

    init() {
        loadFavorites()
        loadCustomSites()
    }

    func isFavorite(_ site: DiveSite) -> Bool {
        favoriteIDs.contains(site.name)
    }

    func toggleFavorite(_ site: DiveSite) {
        if favoriteIDs.contains(site.name) {
            favoriteIDs.remove(site.name)
        } else {
            favoriteIDs.insert(site.name)
        }
        saveFavorites()
    }

    var allSitesIncludingCustom: [DiveSite] {
        DiveSite.allSites + customSites
    }

    func favoriteSites() -> [DiveSite] {
        allSitesIncludingCustom.filter { favoriteIDs.contains($0.name) }
    }

    func addCustomSite(_ site: DiveSite) {
        customSites.append(site)
        saveCustomSites()
    }

    func deleteCustomSite(_ site: DiveSite) {
        customSites.removeAll { $0.name == site.name }
        favoriteIDs.remove(site.name)
        saveCustomSites()
        saveFavorites()
    }

    // MARK: - Persistence

    private func saveFavorites() {
        let array = Array(favoriteIDs)
        UserDefaults.standard.set(array, forKey: favKey)
    }

    private func loadFavorites() {
        if let array = UserDefaults.standard.stringArray(forKey: favKey) {
            favoriteIDs = Set(array)
        }
    }

    // Custom sites stored as JSON (subset of fields)
    private func saveCustomSites() {
        struct CustomSiteData: Codable {
            let name: String
            let location: String
            let country: String
            let region: String
            let description: String
            let maxDepthFeet: Int
            let difficulty: String
            let highlights: [String]
            let rating: Double
        }

        let data = customSites.map { site in
            CustomSiteData(
                name: site.name,
                location: site.location,
                country: site.country,
                region: site.region.rawValue,
                description: site.description,
                maxDepthFeet: site.maxDepthFeet,
                difficulty: site.difficulty.rawValue,
                highlights: site.highlights,
                rating: site.rating
            )
        }

        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: customKey)
        }
    }

    private func loadCustomSites() {
        struct CustomSiteData: Codable {
            let name: String
            let location: String
            let country: String
            let region: String
            let description: String
            let maxDepthFeet: Int
            let difficulty: String
            let highlights: [String]
            let rating: Double
        }

        guard let data = UserDefaults.standard.data(forKey: customKey),
              let decoded = try? JSONDecoder().decode([CustomSiteData].self, from: data) else { return }

        customSites = decoded.map { d in
            DiveSite(
                name: d.name,
                location: d.location,
                country: d.country,
                region: DiveSite.DiveRegion(rawValue: d.region) ?? .americas,
                description: d.description,
                maxDepthFeet: d.maxDepthFeet,
                difficulty: DiveSite.DiveDifficulty(rawValue: d.difficulty) ?? .beginner,
                highlights: d.highlights,
                bestMonths: "Year-round",
                waterTempRangeFahrenheit: "—",
                visibilityFeet: "—",
                rating: d.rating
            )
        }
    }
}
