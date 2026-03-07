import SwiftUI

/// Persistence for dive site condition reports
class SiteConditionsStore: ObservableObject {
    @Published var conditions: [SiteCondition] = []

    private let saveKey = "ReefBuddySiteConditions"

    init() {
        load()
    }

    func add(_ condition: SiteCondition) {
        conditions.insert(condition, at: 0)
        save()
    }

    func delete(_ condition: SiteCondition) {
        conditions.removeAll { $0.id == condition.id }
        save()
    }

    func conditions(for siteName: String) -> [SiteCondition] {
        conditions
            .filter { $0.siteName.lowercased() == siteName.lowercased() }
            .sorted { $0.date > $1.date }
    }

    /// All unique site names that have condition reports
    var reportedSites: [String] {
        Array(Set(conditions.map(\.siteName))).sorted()
    }

    /// Average rating for a site
    func averageRating(for siteName: String) -> Double {
        let siteConditions = conditions(for: siteName)
        guard !siteConditions.isEmpty else { return 0 }
        return Double(siteConditions.reduce(0) { $0 + $1.overallRating }) / Double(siteConditions.count)
    }

    /// Most recent condition for a site
    func latestCondition(for siteName: String) -> SiteCondition? {
        conditions(for: siteName).first
    }

    private func save() {
        if let data = try? JSONEncoder().encode(conditions) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([SiteCondition].self, from: data) {
            conditions = decoded
        }
    }
}
