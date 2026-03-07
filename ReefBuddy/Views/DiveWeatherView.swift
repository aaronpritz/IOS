import SwiftUI

struct DiveWeatherView: View {
    @EnvironmentObject var units: UnitSettings
    @State private var weather: DiveWeather?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedSite: DiveSite?
    @State private var showingSitePicker = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Site Selector
                Button {
                    showingSitePicker = true
                } label: {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.cyan)
                        VStack(alignment: .leading) {
                            Text(selectedSite?.name ?? "Select a Dive Site")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            if let site = selectedSite {
                                Text(site.location)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if isLoading {
                    ProgressView("Fetching conditions...")
                        .padding(.top, 40)
                } else if let error = errorMessage {
                    ContentUnavailableView {
                        Label("Weather Unavailable", systemImage: "cloud.slash")
                    } description: {
                        Text(error)
                    } actions: {
                        if selectedSite != nil {
                            Button("Retry") { fetchWeather() }
                        }
                    }
                } else if let weather = weather {
                    weatherContent(weather)
                } else {
                    ContentUnavailableView {
                        Label("Check Dive Conditions", systemImage: "cloud.sun.fill")
                    } description: {
                        Text("Select a dive site to see current weather and marine conditions.")
                    }
                    .padding(.top, 20)
                }
            }
            .padding()
        }
        .navigationTitle("Dive Weather")
        .sheet(isPresented: $showingSitePicker) {
            WeatherSitePicker(selectedSite: $selectedSite)
        }
        .onChange(of: selectedSite) { _, _ in
            fetchWeather()
        }
    }

    @ViewBuilder
    private func weatherContent(_ weather: DiveWeather) -> some View {
        // MARK: - Dive Condition Rating
        VStack(spacing: 8) {
            Image(systemName: weather.diveConditionRating.icon)
                .font(.system(size: 36))
                .foregroundStyle(conditionColor(weather.diveConditionRating))

            Text("Dive Conditions: \(weather.diveConditionRating.rawValue)")
                .font(.title2.bold())

            Text(weather.weatherDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Updated \(weather.fetchedAt.formatted(date: .omitted, time: .shortened))")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(conditionColor(weather.diveConditionRating).opacity(0.1))
        )

        // MARK: - Current Weather
        VStack(alignment: .leading, spacing: 12) {
            Label("Weather", systemImage: weather.weatherIcon)
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                WeatherStatCard(
                    icon: "thermometer.medium",
                    label: "Air Temp",
                    value: units.unitSystem == .imperial
                        ? "\(Int(weather.current.temperature * 9/5 + 32))°F"
                        : "\(Int(weather.current.temperature))°C"
                )
                WeatherStatCard(
                    icon: "humidity.fill",
                    label: "Humidity",
                    value: "\(weather.current.humidity)%"
                )
                WeatherStatCard(
                    icon: "wind",
                    label: "Wind",
                    value: units.unitSystem == .imperial
                        ? "\(Int(weather.current.windSpeed * 0.621))mph \(weather.windDirectionCompass)"
                        : "\(Int(weather.current.windSpeed))km/h \(weather.windDirectionCompass)"
                )
                WeatherStatCard(
                    icon: "sun.max.fill",
                    label: "UV Index",
                    value: "\(Int(weather.current.uvIndex))"
                )
                WeatherStatCard(
                    icon: "cloud.fill",
                    label: "Cloud Cover",
                    value: "\(weather.current.cloudCover)%"
                )
                WeatherStatCard(
                    icon: "gauge.medium",
                    label: "Pressure",
                    value: "\(Int(weather.current.pressure)) hPa"
                )
            }
        }

        // MARK: - Marine Conditions
        if let marine = weather.marine {
            VStack(alignment: .leading, spacing: 12) {
                Label("Marine Conditions", systemImage: "water.waves")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    WeatherStatCard(
                        icon: "water.waves",
                        label: "Wave Height",
                        value: units.unitSystem == .imperial
                            ? String(format: "%.1f ft", marine.waveHeight * 3.281)
                            : String(format: "%.1f m", marine.waveHeight)
                    )
                    WeatherStatCard(
                        icon: "timer",
                        label: "Wave Period",
                        value: String(format: "%.0fs", marine.wavePeriod)
                    )
                    WeatherStatCard(
                        icon: "thermometer.variable.and.figure",
                        label: "Water Temp",
                        value: units.unitSystem == .imperial
                            ? "\(Int(marine.waterTemperature * 9/5 + 32))°F"
                            : "\(Int(marine.waterTemperature))°C"
                    )
                    WeatherStatCard(
                        icon: "safari",
                        label: "Wave Dir",
                        value: compassDirection(marine.waveDirection)
                    )
                }
            }
        }

        // MARK: - Dive Tips
        VStack(alignment: .leading, spacing: 8) {
            Label("Conditions Summary", systemImage: "lightbulb.fill")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            ForEach(diveTips(weather), id: \.self) { tip in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(.cyan)
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)
                    Text(tip)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func fetchWeather() {
        guard let site = selectedSite else { return }
        isLoading = true
        errorMessage = nil
        weather = nil

        Task {
            do {
                let result = try await WeatherService.shared.fetchWeather(
                    latitude: site.latitude,
                    longitude: site.longitude,
                    locationName: site.name
                )
                await MainActor.run {
                    weather = result
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }

    private func conditionColor(_ condition: DiveWeather.DiveCondition) -> Color {
        switch condition {
        case .excellent: return .green
        case .good: return .cyan
        case .fair: return .orange
        case .poor: return .red
        }
    }

    private func compassDirection(_ degrees: Int) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((Double(degrees) + 22.5) / 45.0) % 8
        return directions[index]
    }

    private func diveTips(_ weather: DiveWeather) -> [String] {
        var tips: [String] = []

        if weather.current.windSpeed > 25 {
            tips.append("High winds — surface conditions may be rough. Consider sheltered sites.")
        } else if weather.current.windSpeed < 10 {
            tips.append("Light winds — excellent surface conditions expected.")
        }

        if let marine = weather.marine {
            if marine.waveHeight > 2.0 {
                tips.append("Large swells — shore entries may be difficult. Boat diving recommended.")
            } else if marine.waveHeight < 0.5 {
                tips.append("Calm seas — great conditions for any entry type.")
            }

            if marine.waterTemperature < 18 {
                tips.append("Cold water — consider a thicker wetsuit or drysuit.")
            } else if marine.waterTemperature > 28 {
                tips.append("Warm water — a 3mm wetsuit or rashguard should be sufficient.")
            }
        }

        if weather.current.uvIndex >= 8 {
            tips.append("Very high UV — apply reef-safe sunscreen before and between dives.")
        }

        if [61, 63, 65, 80, 81, 82].contains(weather.current.weatherCode) {
            tips.append("Rain expected — bring dry bags for electronics and valuables.")
        }

        if [95, 96, 99].contains(weather.current.weatherCode) {
            tips.append("Thunderstorms — diving is not recommended. Wait for conditions to clear.")
        }

        if tips.isEmpty {
            tips.append("Conditions look good for diving. Have a great dive!")
        }

        return tips
    }
}

// MARK: - Weather Stat Card

struct WeatherStatCard: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.cyan)
            Text(value)
                .font(.callout.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Site Picker for Weather

struct WeatherSitePicker: View {
    @Binding var selectedSite: DiveSite?
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""

    private var filteredSites: [DiveSite] {
        if searchText.isEmpty {
            return DiveSite.allSites
        }
        return DiveSite.allSites.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.location.localizedCaseInsensitiveContains(searchText) ||
            $0.country.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredSites) { site in
                Button {
                    selectedSite = site
                    dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(site.name)
                            .font(.subheadline.bold())
                            .foregroundStyle(.primary)
                        Text("\(site.location), \(site.country)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search dive sites")
            .navigationTitle("Select Dive Site")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DiveWeatherView()
            .environmentObject(UnitSettings())
    }
}
