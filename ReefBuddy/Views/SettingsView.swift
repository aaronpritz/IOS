import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var units: UnitSettings
    @AppStorage("rapidAPIKey") private var apiKey = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Unit System", selection: $units.unitSystem) {
                        ForEach(UnitSystem.allCases, id: \.self) { system in
                            Text(system.rawValue).tag(system)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Label("Units", systemImage: "ruler")
                } footer: {
                    switch units.unitSystem {
                    case .imperial:
                        Text("Depth in feet, temperature in °F, visibility in feet")
                    case .metric:
                        Text("Depth in meters, temperature in °C, visibility in meters")
                    }
                }

                Section {
                    NavigationLink(destination: CertificationView()) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.cyan)
                            Text("Certifications")
                        }
                    }

                    NavigationLink(destination: DataManagementView()) {
                        HStack {
                            Image(systemName: "externaldrive")
                                .foregroundStyle(.teal)
                            Text("Data Management")
                        }
                    }
                } header: {
                    Label("Profile & Data", systemImage: "person.crop.circle")
                }

                Section {
                    SecureField("RapidAPI Key", text: $apiKey)
                        .onChange(of: apiKey) { _, newValue in
                            DiveSiteAPIService.apiKey = newValue
                        }
                } header: {
                    Label("Online Dive Sites API", systemImage: "globe")
                } footer: {
                    Text("Optional. Get a free key from rapidapi.com to search 15,000+ dive sites online.")
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("2.1.0")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Label("About", systemImage: "info.circle")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UnitSettings())
}
