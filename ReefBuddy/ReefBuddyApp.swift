import SwiftUI

@main
struct ReefBuddyApp: App {
    @StateObject private var store = DiveStore()
    @StateObject private var units = UnitSettings()
    @StateObject private var favStore = FavoriteSitesStore()
    @StateObject private var gearStore = GearStore()
    @StateObject private var buddyStore = BuddyStore()
    @AppStorage("rapidAPIKey") private var apiKey = ""

    init() {
        // Load saved API key on startup
        let savedKey = UserDefaults.standard.string(forKey: "rapidAPIKey") ?? ""
        DiveSiteAPIService.apiKey = savedKey
    }

    var body: some Scene {
        WindowGroup {
            AdaptiveRootView()
                .environmentObject(store)
                .environmentObject(units)
                .environmentObject(favStore)
                .environmentObject(gearStore)
                .environmentObject(buddyStore)
                .tint(.cyan)
        }
    }
}

/// Switches between TabView (iPhone) and sidebar NavigationSplitView (iPad)
struct AdaptiveRootView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        if horizontalSizeClass == .regular {
            iPadSidebarView()
        } else {
            iPhoneTabView()
        }
    }
}

/// Tab-based navigation for iPhone
struct iPhoneTabView: View {
    var body: some View {
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

            NavigationStack {
                GearListView()
            }
                .tabItem {
                    Label("Gear", systemImage: "bag.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}
