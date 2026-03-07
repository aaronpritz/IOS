import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var store: DiveStore
    @EnvironmentObject var units: UnitSettings
    @EnvironmentObject var favStore: FavoriteSitesStore
    @State private var showingAddSite = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Dive Map
                    NavigationLink(destination: DiveMapView()) {
                        ReferenceCard(
                            icon: "map.fill",
                            title: "Dive Map",
                            subtitle: "\(DiveSite.allSites.count) sites on an interactive map",
                            color: .blue
                        )
                    }

                    // MARK: - Dive Sites Directory
                    NavigationLink(destination: DiveSiteDirectoryView()) {
                        ReferenceCard(
                            icon: "list.bullet",
                            title: "Site Directory",
                            subtitle: "\(DiveSite.allSites.count + favStore.customSites.count) sites worldwide",
                            color: .cyan
                        )
                    }

                    // MARK: - Online Search
                    NavigationLink(destination: OnlineSiteSearchView()) {
                        ReferenceCard(
                            icon: "globe",
                            title: "Online Search",
                            subtitle: "Search 15,000+ sites by country",
                            color: .green
                        )
                    }

                    // MARK: - Site Conditions
                    NavigationLink(destination: AllSiteConditionsView()) {
                        ReferenceCard(
                            icon: "doc.text.magnifyingglass",
                            title: "Site Conditions",
                            subtitle: "Entry/exit notes, currents, and tips",
                            color: .teal
                        )
                    }

                    // MARK: - Favorites
                    let favorites = favStore.favoriteSites()
                    if !favorites.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Favorites", systemImage: "heart.fill")
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .padding(.horizontal, 4)

                            ForEach(favorites) { site in
                                NavigationLink(destination: DiveSiteDetailView(site: site)) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "heart.fill")
                                            .foregroundStyle(.red)
                                            .font(.caption)
                                            .frame(width: 28)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(site.name)
                                                .font(.subheadline.bold())
                                                .foregroundStyle(.primary)
                                            Text("\(site.location), \(site.country)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }

                                        Spacer()

                                        HStack(spacing: 2) {
                                            Image(systemName: "star.fill")
                                                .foregroundStyle(.yellow)
                                                .font(.caption2)
                                            Text(String(format: "%.1f", site.rating))
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }

                    // MARK: - Custom Sites
                    if !favStore.customSites.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Sites")
                                .font(.headline)
                                .padding(.horizontal, 4)

                            ForEach(favStore.customSites) { site in
                                NavigationLink(destination: DiveSiteDetailView(site: site)) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundStyle(.orange)
                                            .frame(width: 28)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(site.name)
                                                .font(.subheadline.bold())
                                                .foregroundStyle(.primary)
                                            Text("\(site.location), \(site.country)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        favStore.deleteCustomSite(site)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }

                    // MARK: - Add Custom Site
                    Button { showingAddSite = true } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.cyan)
                            Text("Add Custom Dive Site")
                                .font(.subheadline.bold())
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // MARK: - Share Your Dives
                    if !store.dives.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Share a Dive")
                                .font(.headline)
                                .padding(.horizontal, 4)

                            ForEach(store.dives.prefix(5)) { dive in
                                NavigationLink(destination: ShareDiveView(dive: dive)) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.title3)
                                            .foregroundStyle(.teal)
                                            .frame(width: 36)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(dive.diveSite)
                                                .font(.subheadline.bold())
                                                .foregroundStyle(.primary)
                                            Text("\(dive.location) · \(dive.formattedDate)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }

                    // MARK: - Dive Site Stats
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sites by Region")
                            .font(.headline)
                            .padding(.horizontal, 4)

                        ForEach(DiveSite.DiveRegion.allCases, id: \.self) { region in
                            let count = DiveSite.sites(for: region).count
                            NavigationLink(destination: DiveSiteDirectoryView()) {
                                HStack {
                                    Text(regionEmoji(region))
                                        .font(.title2)
                                        .frame(width: 36)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(region.rawValue)
                                            .font(.subheadline.bold())
                                            .foregroundStyle(.primary)
                                        Text("\(count) \(count == 1 ? "site" : "sites")")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Explore")
            .sheet(isPresented: $showingAddSite) {
                AddCustomSiteView()
            }
        }
    }

    private func regionEmoji(_ region: DiveSite.DiveRegion) -> String {
        switch region {
        case .caribbean: return "🏝"
        case .southeastAsia: return "🌏"
        case .pacific: return "🌊"
        case .redSea: return "🐫"
        case .americas: return "🗽"
        case .mediterranean: return "🏛"
        case .indianOcean: return "🐋"
        }
    }
}

#Preview {
    ExploreView()
        .environmentObject(DiveStore())
        .environmentObject(UnitSettings())
        .environmentObject(FavoriteSitesStore())
}
