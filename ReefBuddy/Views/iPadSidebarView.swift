import SwiftUI

/// Sidebar navigation for iPad — shows a sidebar list with detail in a split view
struct iPadSidebarView: View {
    @State private var selection: SidebarItem? = .dives

    enum SidebarItem: String, CaseIterable {
        case dives = "Dives"
        case stats = "Stats"
        case plan = "Plan"
        case weather = "Weather"
        case explore = "Explore"
        case gear = "Gear"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .dives: return "water.waves"
            case .stats: return "chart.bar"
            case .plan: return "map"
            case .weather: return "cloud.sun.fill"
            case .explore: return "globe"
            case .gear: return "bag.fill"
            case .settings: return "gearshape"
            }
        }

        var section: SidebarSection {
            switch self {
            case .dives, .stats, .plan: return .diving
            case .weather, .explore: return .discover
            case .gear: return .equipment
            case .settings: return .app
            }
        }
    }

    enum SidebarSection: String, CaseIterable {
        case diving = "Diving"
        case discover = "Discover"
        case equipment = "Equipment"
        case app = "App"
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(SidebarSection.allCases, id: \.self) { section in
                    Section(section.rawValue) {
                        ForEach(SidebarItem.allCases.filter { $0.section == section }, id: \.self) { item in
                            Label(item.rawValue, systemImage: item.icon)
                                .tag(item)
                        }
                    }
                }
            }
            .navigationTitle("ReefBuddy")
            .listStyle(.sidebar)
        } detail: {
            NavigationStack {
                switch selection {
                case .dives:
                    DiveListView()
                case .stats:
                    StatsView()
                case .plan:
                    PlanView()
                case .weather:
                    DiveWeatherView()
                case .explore:
                    ExploreView()
                case .gear:
                    GearListView()
                case .settings:
                    SettingsView()
                case nil:
                    ContentUnavailableView {
                        Label("ReefBuddy", systemImage: "water.waves")
                    } description: {
                        Text("Select an item from the sidebar to get started.")
                    }
                }
            }
        }
    }
}

#Preview {
    iPadSidebarView()
        .environmentObject(DiveStore())
        .environmentObject(UnitSettings())
        .environmentObject(FavoriteSitesStore())
        .environmentObject(GearStore())
}
