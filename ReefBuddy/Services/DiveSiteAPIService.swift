import Foundation

/// Service layer for fetching dive sites from the World Scuba Diving Sites API
/// API docs: https://rapidapi.com/the-dive-api-the-dive-api-default/api/world-scuba-diving-sites-api
///
/// To enable online search:
/// 1. Sign up for a free API key at RapidAPI
/// 2. Set DiveSiteAPIService.apiKey in your app startup
///
/// Without an API key, the app works fully offline using the built-in 87-site directory.
class DiveSiteAPIService: ObservableObject {
    static let shared = DiveSiteAPIService()

    /// Set this to your RapidAPI key to enable online search
    static var apiKey: String = ""
    static var apiHost: String = "world-scuba-diving-sites-api.p.rapidapi.com"

    @Published var searchResults: [OnlineDiveSite] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var isConfigured: Bool {
        !Self.apiKey.isEmpty
    }

    /// A dive site returned from the API
    struct OnlineDiveSite: Identifiable, Codable {
        var id: String { name + "\(lat)" }
        let name: String
        let region: String?
        let lat: Double
        let lng: Double
        let ocean: String?
        let location: String?
    }

    struct APIResponse: Codable {
        let data: [OnlineDiveSite]?
    }

    /// Search for dive sites by country
    func searchByCountry(_ country: String) async {
        guard isConfigured else {
            await MainActor.run {
                errorMessage = "API key not configured. Go to Settings > API Key to enable online search."
            }
            return
        }

        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        let encodedCountry = country.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? country
        guard let url = URL(string: "https://\(Self.apiHost)/country/\(encodedCountry)") else {
            await MainActor.run {
                isLoading = false
                errorMessage = "Invalid search query."
            }
            return
        }

        var request = URLRequest(url: url)
        request.setValue(Self.apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(Self.apiHost, forHTTPHeaderField: "x-rapidapi-host")
        request.httpMethod = "GET"
        request.timeoutInterval = 15

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Invalid response."
                }
                return
            }

            guard httpResponse.statusCode == 200 else {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "API returned status \(httpResponse.statusCode). Check your API key."
                }
                return
            }

            let decoder = JSONDecoder()

            // Try parsing as { data: [...] } or as a raw array
            if let apiResponse = try? decoder.decode(APIResponse.self, from: data),
               let sites = apiResponse.data {
                await MainActor.run {
                    searchResults = sites
                    isLoading = false
                }
            } else if let sites = try? decoder.decode([OnlineDiveSite].self, from: data) {
                await MainActor.run {
                    searchResults = sites
                    isLoading = false
                }
            } else {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Could not parse API response."
                }
            }

        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = "Network error: \(error.localizedDescription)"
            }
        }
    }

    /// Convert an API result to our local DiveSite model for display
    static func toLocalSite(_ online: OnlineDiveSite) -> DiveSite {
        let region: DiveSite.DiveRegion = {
            let r = (online.region ?? "").lowercased()
            let o = (online.ocean ?? "").lowercased()
            if r.contains("caribbean") { return .caribbean }
            if r.contains("mediterranean") || r.contains("europe") { return .mediterranean }
            if r.contains("asia") || r.contains("southeast") { return .southeastAsia }
            if r.contains("red sea") || r.contains("middle east") { return .redSea }
            if o.contains("indian") { return .indianOcean }
            if o.contains("pacific") { return .pacific }
            return .americas
        }()

        return DiveSite(
            name: online.name,
            location: online.location ?? online.region ?? "Unknown",
            country: online.location ?? "Unknown",
            region: region,
            description: "Dive site from online database. Tap to view on map.",
            maxDepthFeet: 0,
            difficulty: .beginner,
            highlights: [online.ocean ?? "Ocean diving"].compactMap { $0 },
            bestMonths: "—",
            waterTempRangeFahrenheit: "—",
            visibilityFeet: "—",
            rating: 0,
            latitude: online.lat,
            longitude: online.lng
        )
    }
}
