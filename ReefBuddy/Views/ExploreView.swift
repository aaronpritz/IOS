import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var store: DiveStore
    @EnvironmentObject var units: UnitSettings

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Dive Sites
                    NavigationLink(destination: DiveSiteDirectoryView()) {
                        ReferenceCard(
                            icon: "map.fill",
                            title: "Dive Sites",
                            subtitle: "\(DiveSite.allSites.count) popular sites worldwide",
                            color: .cyan
                        )
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
        }
    }

    private func regionEmoji(_ region: DiveSite.DiveRegion) -> String {
        switch region {
        case .caribbean: return "🏝"
        case .southeastAsia: return "🌏"
        case .pacific: return "🌊"
        case .redSea: return "🐫"
        case .americas: return "🗽"
        }
    }
}

#Preview {
    ExploreView()
        .environmentObject(DiveStore())
        .environmentObject(UnitSettings())
}
