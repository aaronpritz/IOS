import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var units: UnitSettings

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
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
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
