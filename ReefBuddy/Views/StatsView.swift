import SwiftUI

struct StatsView: View {
    @EnvironmentObject var store: DiveStore
    @EnvironmentObject var units: UnitSettings

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Hero Stats
                    HStack(spacing: 12) {
                        HeroStatCard(
                            icon: "number",
                            value: "\(store.totalDives)",
                            label: "Total Dives",
                            color: .cyan
                        )
                        HeroStatCard(
                            icon: "arrow.down.to.line",
                            value: units.depthDisplay(store.deepestDive),
                            label: "Deepest",
                            color: .blue
                        )
                    }

                    HStack(spacing: 12) {
                        HeroStatCard(
                            icon: "clock",
                            value: formatTime(store.totalBottomTime),
                            label: "Total Time",
                            color: .teal
                        )
                        HeroStatCard(
                            icon: "arrow.down.forward",
                            value: units.depthDisplay(store.averageDepth),
                            label: "Avg Depth",
                            color: .indigo
                        )
                    }

                    // MARK: - Favorite Location
                    VStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .foregroundStyle(.pink)

                        Text("Favorite Spot")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(store.favoriteLocation)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // MARK: - Recent Dives Preview
                    if !store.dives.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Dives")
                                .font(.headline)
                                .padding(.horizontal, 4)

                            ForEach(store.dives.prefix(3)) { dive in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(dive.diveSite)
                                            .font(.subheadline.bold())
                                        Text(dive.formattedDate)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(units.depthDisplay(dive.maxDepth))
                                        .font(.subheadline)
                                        .foregroundStyle(.cyan)
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
            .navigationTitle("Stats")
        }
    }

    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if hours > 0 {
            return "\(hours)h \(mins)m"
        }
        return "\(mins)m"
    }
}

// MARK: - Hero Stat Card

struct HeroStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title.bold())

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    StatsView()
        .environmentObject(DiveStore())
        .environmentObject(UnitSettings())
}
