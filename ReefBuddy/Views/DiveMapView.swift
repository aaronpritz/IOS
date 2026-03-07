import SwiftUI
import MapKit

/// An annotation for a dive site on the map
struct DiveSiteAnnotation: Identifiable {
    let id = UUID()
    let site: DiveSite
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: site.latitude, longitude: site.longitude)
    }
}

struct DiveMapView: View {
    @EnvironmentObject var units: UnitSettings
    @EnvironmentObject var favStore: FavoriteSitesStore

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10, longitude: 40),
        span: MKCoordinateSpan(latitudeDelta: 120, longitudeDelta: 120)
    )
    @State private var selectedSite: DiveSite?
    @State private var filterRegion: DiveSite.DiveRegion?

    var displayedSites: [DiveSite] {
        let sites = favStore.allSitesIncludingCustom.isEmpty
            ? DiveSite.allSites
            : DiveSite.allSites + favStore.customSites
        if let filter = filterRegion {
            return sites.filter { $0.region == filter && $0.latitude != 0 }
        }
        return sites.filter { $0.latitude != 0 }
    }

    var annotations: [DiveSiteAnnotation] {
        displayedSites.map { DiveSiteAnnotation(site: $0) }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    Button {
                        selectedSite = annotation.site
                    } label: {
                        VStack(spacing: 2) {
                            Image(systemName: favStore.isFavorite(annotation.site) ? "heart.fill" : "mappin.circle.fill")
                                .font(.title2)
                                .foregroundStyle(favStore.isFavorite(annotation.site) ? .red : colorForRegion(annotation.site.region))
                                .background(
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 24, height: 24)
                                )
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)

            // Region filter chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(label: "All", isSelected: filterRegion == nil) {
                        withAnimation { filterRegion = nil }
                        zoomToFit(nil)
                    }
                    ForEach(DiveSite.DiveRegion.allCases, id: \.self) { region in
                        FilterChip(label: region.rawValue, isSelected: filterRegion == region) {
                            withAnimation { filterRegion = region }
                            zoomToFit(region)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .background(.ultraThinMaterial)
        }
        .sheet(item: $selectedSite) { site in
            NavigationStack {
                DiveSiteDetailView(site: site)
            }
            .presentationDetents([.medium, .large])
        }
        .navigationTitle("Dive Map")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func zoomToFit(_ region: DiveSite.DiveRegion?) {
        let sites: [DiveSite]
        if let region = region {
            sites = DiveSite.sites(for: region).filter { $0.latitude != 0 }
        } else {
            sites = DiveSite.allSites.filter { $0.latitude != 0 }
        }
        guard !sites.isEmpty else { return }

        let lats = sites.map(\.latitude)
        let lngs = sites.map(\.longitude)
        let center = CLLocationCoordinate2D(
            latitude: (lats.min()! + lats.max()!) / 2,
            longitude: (lngs.min()! + lngs.max()!) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max((lats.max()! - lats.min()!) * 1.5, 5),
            longitudeDelta: max((lngs.max()! - lngs.min()!) * 1.5, 5)
        )
        withAnimation {
            self.region = MKCoordinateRegion(center: center, span: span)
        }
    }

    private func colorForRegion(_ region: DiveSite.DiveRegion) -> Color {
        switch region {
        case .caribbean: return .cyan
        case .southeastAsia: return .green
        case .pacific: return .blue
        case .redSea: return .orange
        case .americas: return .teal
        case .mediterranean: return .indigo
        case .indianOcean: return .purple
        }
    }
}

// Make DiveSite identifiable for sheet presentation
extension DiveSite: Equatable {
    static func == (lhs: DiveSite, rhs: DiveSite) -> Bool {
        lhs.name == rhs.name && lhs.latitude == rhs.latitude
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(isSelected ? Color.cyan : Color(.systemGray5))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    NavigationStack {
        DiveMapView()
            .environmentObject(UnitSettings())
            .environmentObject(FavoriteSitesStore())
    }
}
