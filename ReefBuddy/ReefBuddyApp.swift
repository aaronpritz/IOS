import SwiftUI

@main
struct ReefBuddyApp: App {
    @StateObject private var store = DiveStore()
    @StateObject private var units = UnitSettings()
    @StateObject private var favStore = FavoriteSitesStore()
    @AppStorage("rapidAPIKey") private var apiKey = ""

    init() {
        // Load saved API key on startup
        let savedKey = UserDefaults.standard.string(forKey: "rapidAPIKey") ?? ""
        DiveSiteAPIService.apiKey = savedKey
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                DiveListView()
                    .tabItem {
                        Label("Dives", systemImage: "water.waves")
                    }

                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar")
                    }

                PlanView()
                    .tabItem {
                        Label("Plan", systemImage: "map")
                    }

                NavigationStack {
                    DiveWeatherView()
                }
                    .tabItem {
                        Label("Weather", systemImage: "cloud.sun.fill")
                    }

                ExploreView()
                    .tabItem {
                        Label("Explore", systemImage: "globe")
                    }

                ReferenceView()
                    .tabItem {
                        Label("Reference", systemImage: "book")
                    }

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            .environmentObject(store)
            .environmentObject(units)
            .environmentObject(favStore)
            .tint(.cyan)
        }
    }
}
