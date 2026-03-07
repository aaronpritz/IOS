import SwiftUI

struct GasCalculatorView: View {
    @EnvironmentObject var units: UnitSettings

    @State private var tankSize: Double = 80       // cubic feet (AL80)
    @State private var startPressure: Double = 3000 // PSI
    @State private var sacRate: Double = 15         // PSI/min at surface (beginner default)
    @State private var plannedDepth: Double = 60    // feet
    @State private var reservePressure: Double = 500 // PSI

    // Common tank sizes in cubic feet
    let tankOptions: [(name: String, cuFt: Double)] = [
        ("AL63", 63),
        ("AL80 (Standard)", 80),
        ("LP85", 85),
        ("HP100", 100),
        ("HP120", 120),
    ]

    var ambientPressure: Double {
        // Every 33 feet = 1 atmosphere
        1.0 + (plannedDepth / 33.0)
    }

    var consumptionAtDepth: Double {
        // SAC rate * ambient pressure = actual consumption at depth (PSI/min)
        sacRate * ambientPressure
    }

    var usablePressure: Double {
        max(startPressure - reservePressure, 0)
    }

    var availableTime: Double {
        guard consumptionAtDepth > 0 else { return 0 }
        return usablePressure / consumptionAtDepth
    }

    var turnPressure: Double {
        // Pressure at which to turn the dive (halfway through usable gas + reserve)
        let halfUsable = usablePressure / 2.0
        return startPressure - halfUsable
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Disclaimer
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("Estimates only — always monitor your actual SPG during the dive.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Tank Setup
                PlannerSection(title: "Tank Setup", icon: "cylinder.fill", color: .cyan) {
                    VStack(spacing: 12) {
                        // Tank size picker
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tank Size")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Picker("Tank", selection: $tankSize) {
                                ForEach(tankOptions, id: \.cuFt) { tank in
                                    Text(tank.name).tag(tank.cuFt)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        VStack(alignment: .leading) {
                            Text("Start Pressure: \(Int(startPressure)) PSI")
                                .font(.subheadline)
                            Slider(value: $startPressure, in: 2000...3500, step: 100)
                                .tint(.cyan)
                        }

                        VStack(alignment: .leading) {
                            Text("Reserve: \(Int(reservePressure)) PSI")
                                .font(.subheadline)
                            Slider(value: $reservePressure, in: 300...1000, step: 50)
                                .tint(.orange)
                        }
                    }
                }

                // MARK: - SAC Rate
                PlannerSection(title: "SAC Rate", icon: "lungs.fill", color: .teal) {
                    VStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(Int(sacRate)) PSI/min")
                                    .font(.subheadline)
                                Spacer()
                                Text(sacRateLabel)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(sacRateColor.opacity(0.2))
                                    .foregroundStyle(sacRateColor)
                                    .clipShape(Capsule())
                            }
                            Slider(value: $sacRate, in: 8...30, step: 1)
                                .tint(.teal)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Typical SAC Rates:")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                            Text("Experienced: 10-15 PSI/min")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Beginner: 15-25 PSI/min")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Stressed/Working Hard: 25-30+ PSI/min")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // MARK: - Planned Depth
                PlannerSection(title: "Planned Depth", icon: "arrow.down.to.line", color: .blue) {
                    VStack(alignment: .leading) {
                        Text("\(Int(units.toDisplayDepth(plannedDepth))) \(units.depthUnit)")
                            .font(.title2.bold())
                            .foregroundStyle(.blue)
                        Slider(value: $plannedDepth, in: 15...130, step: 5)
                            .tint(.blue)

                        Text("Ambient pressure: \(String(format: "%.1f", ambientPressure)) ATM")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: - Results
                VStack(spacing: 16) {
                    Text("Gas Plan Results")
                        .font(.headline)

                    // Available bottom time
                    VStack(spacing: 4) {
                        Text("Available Bottom Time")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(Int(availableTime)) min")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(availableTime < 20 ? .orange : .cyan)
                    }

                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ResultCard(label: "Consumption at Depth", value: "\(Int(consumptionAtDepth)) PSI/min", color: .teal)
                        ResultCard(label: "Usable Gas", value: "\(Int(usablePressure)) PSI", color: .cyan)
                        ResultCard(label: "Turn Pressure", value: "\(Int(turnPressure)) PSI", color: .orange)
                        ResultCard(label: "Reserve", value: "\(Int(reservePressure)) PSI", color: .red)
                    }

                    // No-deco comparison
                    let noDecoLimit = DiveTableData.noDecoLimit(forDepthFeet: Int(plannedDepth)) ?? 0
                    if noDecoLimit > 0 {
                        HStack {
                            Image(systemName: availableTime > Double(noDecoLimit) ? "info.circle.fill" : "checkmark.circle.fill")
                                .foregroundStyle(availableTime > Double(noDecoLimit) ? .orange : .green)
                            if availableTime > Double(noDecoLimit) {
                                Text("No-deco limit (\(noDecoLimit) min) is your limiting factor — you'll hit it before running low on air.")
                                    .font(.caption)
                            } else {
                                Text("Gas supply (\(Int(availableTime)) min) is your limiting factor — plan accordingly.")
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // MARK: - Rule of Thirds
                VStack(alignment: .leading, spacing: 8) {
                    Label("Rule of Thirds", systemImage: "divide.circle")
                        .font(.subheadline.bold())

                    Text("A common gas management strategy:")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    let third = usablePressure / 3.0 + reservePressure
                    HStack(spacing: 0) {
                        ThirdBar(label: "Out", psi: Int(startPressure - third), color: .cyan)
                        ThirdBar(label: "Back", psi: Int(startPressure - third), color: .teal)
                        ThirdBar(label: "Reserve", psi: Int(third), color: .orange)
                    }
                    .frame(height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    Text("1/3 going out, 1/3 coming back, 1/3 reserve for emergencies")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Gas Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var sacRateLabel: String {
        if sacRate <= 12 { return "Efficient" }
        if sacRate <= 18 { return "Average" }
        if sacRate <= 25 { return "High" }
        return "Very High"
    }

    private var sacRateColor: Color {
        if sacRate <= 12 { return .green }
        if sacRate <= 18 { return .cyan }
        if sacRate <= 25 { return .orange }
        return .red
    }
}

struct ResultCard: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ThirdBar: View {
    let label: String
    let psi: Int
    let color: Color

    var body: some View {
        ZStack {
            color
            VStack(spacing: 0) {
                Text(label)
                    .font(.caption2.bold())
                Text("\(psi) PSI")
                    .font(.caption2)
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    NavigationStack {
        GasCalculatorView()
            .environmentObject(UnitSettings())
    }
}
