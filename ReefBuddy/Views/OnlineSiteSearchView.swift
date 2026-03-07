import SwiftUI
import MapKit

struct OnlineSiteSearchView: View {
    @StateObject private var api = DiveSiteAPIService()
    @EnvironmentObject var favStore: FavoriteSitesStore
    @State private var country = ""
    @State private var hasSearched = false

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search by country (e.g. Australia)", text: $country)
                    .textFieldStyle(.plain)
                    .submitLabel(.search)
                    .onSubmit { search() }

                if !country.isEmpty {
                    Button { country = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }

                Button("Search") { search() }
                    .buttonStyle(.borderedProminent)
                    .tint(.cyan)
                    .disabled(country.isEmpty || api.isLoading)
            }
            .padding()

            if !api.isConfigured {
                // No API key configured
                VStack(spacing: 16) {
                    Image(systemName: "key.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.orange)

                    Text("API Key Required")
                        .font(.headline)

                    Text("To search 15,000+ dive sites online, you need a free API key from RapidAPI.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Sign up at rapidapi.com", systemImage: "1.circle.fill")
                        Label("Subscribe to 'World Scuba Diving Sites API'", systemImage: "2.circle.fill")
                        Label("Copy your API key", systemImage: "3.circle.fill")
                        Label("Paste it in Settings > API Key", systemImage: "4.circle.fill")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(32)
                Spacer()
            } else if api.isLoading {
                Spacer()
                ProgressView("Searching \(country)...")
                    .padding()
                Spacer()
            } else if let error = api.errorMessage {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.title)
                        .foregroundStyle(.orange)
                    Text(error)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                Spacer()
            } else if api.searchResults.isEmpty && hasSearched {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "water.waves.slash")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    Text("No sites found for '\(country)'")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                Spacer()
            } else {
                // Results list
                List(api.searchResults) { site in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(site.name)
                            .font(.subheadline.bold())

                        HStack(spacing: 12) {
                            if let location = site.location {
                                Label(location, systemImage: "mappin")
                            }
                            if let ocean = site.ocean {
                                Label(ocean, systemImage: "water.waves")
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)

                        HStack {
                            Text("Lat: \(String(format: "%.4f", site.lat))")
                            Text("Lng: \(String(format: "%.4f", site.lng))")
                        }
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .swipeActions(edge: .trailing) {
                        Button {
                            addToCustomSites(site)
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                        .tint(.cyan)
                    }
                }
                .listStyle(.plain)

                if !api.searchResults.isEmpty {
                    Text("Swipe left on a site to add it to your directory")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 8)
                }
            }
        }
        .navigationTitle("Online Search")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func search() {
        hasSearched = true
        Task {
            await api.searchByCountry(country)
        }
    }

    private func addToCustomSites(_ online: DiveSiteAPIService.OnlineDiveSite) {
        let site = DiveSiteAPIService.toLocalSite(online)
        favStore.addCustomSite(site)
    }
}

#Preview {
    NavigationStack {
        OnlineSiteSearchView()
            .environmentObject(FavoriteSitesStore())
    }
}
