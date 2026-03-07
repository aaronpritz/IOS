import SwiftUI

@main
struct ReefBuddyApp: App {
    @StateObject private var store = DiveStore()
    @StateObject private var units = UnitSettings()

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

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            .environmentObject(store)
            .environmentObject(units)
            .tint(.cyan)
        }
    }
}
