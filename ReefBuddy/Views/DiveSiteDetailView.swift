import SwiftUI

struct DiveSiteDetailView: View {
    let site: DiveSite
    @EnvironmentObject var units: UnitSettings
    @EnvironmentObject var favStore: FavoriteSitesStore

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Header
                VStack(spacing: 8) {
                    Text(site.name)
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text("\(site.location), \(site.country)")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))

                    HStack(spacing: 12) {
                        // Rating
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: Double(star) <= site.rating ? "star.fill" :
                                        (Double(star) - 0.5 <= site.rating ? "star.leadinghalf.filled" : "star"))
                                    .foregroundStyle(.yellow)
                                    .font(.caption)
                            }
                            Text(String(format: "%.1f", site.rating))
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                        }

                        DifficultyBadge(difficulty: site.difficulty)
                    }
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.0, green: 0.3, blue: 0.5),
                                 Color(red: 0.0, green: 0.1, blue: 0.2)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // MARK: - Description
                VStack(alignment: .leading, spacing: 8) {
                    Label("About", systemImage: "info.circle")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)

                    Text(site.description)
                        .font(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Quick Facts
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    StatCard(icon: "arrow.down.to.line", label: "Max Depth",
                             value: units.depthDisplay(Double(site.maxDepthFeet)))
                    StatCard(icon: "calendar", label: "Best Time",
                             value: site.bestMonths)
                    StatCard(icon: "thermometer.medium", label: "Water Temp",
                             value: site.waterTempRangeFahrenheit)
                    StatCard(icon: "eye", label: "Visibility",
                             value: site.visibilityFeet)
                }

                // MARK: - Highlights
                VStack(alignment: .leading, spacing: 12) {
                    Label("Highlights", systemImage: "sparkles")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)

                    ForEach(site.highlights, id: \.self) { highlight in
                        HStack(spacing: 10) {
                            Image(systemName: "water.waves")
                                .foregroundStyle(.cyan)
                                .font(.caption)
                            Text(highlight)
                                .font(.subheadline)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Site Conditions
                NavigationLink(destination: SiteConditionsView(siteName: site.name)) {
                    HStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.title2)
                            .foregroundStyle(.teal)
                        VStack(alignment: .leading) {
                            Text("Site Conditions")
                                .font(.subheadline.bold())
                                .foregroundStyle(.primary)
                            Text("Entry/exit notes, currents, and tips")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // MARK: - Weather
                NavigationLink {
                    DiveWeatherView()
                } label: {
                    HStack {
                        Image(systemName: "cloud.sun.fill")
                            .font(.title2)
                            .foregroundStyle(.cyan)
                        VStack(alignment: .leading) {
                            Text("Check Weather")
                                .font(.subheadline.bold())
                                .foregroundStyle(.primary)
                            Text("Current conditions at this site")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // MARK: - Log a Dive Here
                VStack(spacing: 8) {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundStyle(.cyan)
                    Text("Visited this site?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Go to the Dives tab to log your dive!")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle(site.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    favStore.toggleFavorite(site)
                } label: {
                    Image(systemName: favStore.isFavorite(site) ? "heart.fill" : "heart")
                        .foregroundStyle(favStore.isFavorite(site) ? .red : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DiveSiteDetailView(site: DiveSite.allSites[0])
            .environmentObject(UnitSettings())
            .environmentObject(FavoriteSitesStore())
    }
}
