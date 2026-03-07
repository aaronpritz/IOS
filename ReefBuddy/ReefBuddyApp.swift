import SwiftUI

@main
struct ReefBuddyApp: App {
    @StateObject private var store = DiveStore()
    @StateObject private var units = UnitSettings()
    @StateObject private var favStore = FavoriteSitesStore()

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
