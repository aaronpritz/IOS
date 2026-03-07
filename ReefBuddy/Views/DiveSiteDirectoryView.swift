import SwiftUI

struct DiveSiteDirectoryView: View {
    @State private var selectedRegion: DiveSite.DiveRegion = .caribbean
    @State private var searchText = ""

    var filteredSites: [DiveSite] {
        let regionSites = DiveSite.sites(for: selectedRegion)
        if searchText.isEmpty {
            return regionSites
        }
        return regionSites.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.location.localizedCaseInsensitiveContains(searchText) ||
            $0.country.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Region picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(DiveSite.DiveRegion.allCases, id: \.self) { region in
                            Button {
                                withAnimation { selectedRegion = region }
                            } label: {
                                Text(region.rawValue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedRegion == region
                                        ? Color.cyan
                                        : Color(.systemGray5)
                                    )
                                    .foregroundStyle(
                                        selectedRegion == region ? .white : .primary
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Site cards
                ForEach(filteredSites) { site in
                    NavigationLink(destination: DiveSiteDetailView(site: site)) {
                        SiteCard(site: site)
                    }
                }

                if filteredSites.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        Text("No sites found")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)
                }
            }
            .padding()
        }
        .navigationTitle("Dive Sites")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search sites...")
    }
}

struct SiteCard: View {
    let site: DiveSite

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(site.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("\(site.location), \(site.country)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Rating
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", site.rating))
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                }
            }

            // Tags
            HStack(spacing: 8) {
                DifficultyBadge(difficulty: site.difficulty)

                Label("\(site.maxDepthFeet) ft", systemImage: "arrow.down.to.line")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Highlights
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(site.highlights, id: \.self) { highlight in
                        Text(highlight)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.cyan.opacity(0.15))
                            .foregroundStyle(.cyan)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct DifficultyBadge: View {
    let difficulty: DiveSite.DiveDifficulty

    var color: Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }

    var body: some View {
        Text(difficulty.rawValue)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.2))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

#Preview {
    NavigationStack {
        DiveSiteDirectoryView()
    }
}
