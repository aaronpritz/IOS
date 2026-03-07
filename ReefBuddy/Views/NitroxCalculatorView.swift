import SwiftUI

struct NitroxCalculatorView: View {
    @EnvironmentObject var units: UnitSettings

    @State private var fO2: Double = 32    // % oxygen (EAN32 default)
    @State private var plannedDepth: Double = 60   // feet
    @State private var ppO2Max: Double = 1.4       // max partial pressure

    // Maximum Operating Depth (MOD) in feet
    var modFeet: Double {
        guard fO2 > 0 else { return 0 }
        return ((ppO2Max / (fO2 / 100.0)) - 1.0) * 33.0
    }

    // Equivalent Air Depth (EAD) in feet
    var eadFeet: Double {
        let fN2 = (100.0 - fO2) / 100.0
        return ((fN2 * (plannedDepth / 33.0 + 1.0)) / 0.79 - 1.0) * 33.0
    }

    // Partial pressure of O2 at planned depth
    var ppO2AtDepth: Double {
        (fO2 / 100.0) * (1.0 + plannedDepth / 33.0)
    }

    var ppO2Status: (text: String, color: Color) {
        if ppO2AtDepth <= 1.4 { return ("Safe", .green) }
        if ppO2AtDepth <= 1.6 { return ("Caution", .orange) }
        return ("DANGER - CNS Toxicity Risk", .red)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Disclaimer
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("Nitrox diving requires proper certification. These are estimates only.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Mix Selection
                PlannerSection(title: "Nitrox Mix", icon: "aqi.medium", color: .green) {
                    VStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("EAN\(Int(fO2))")
                                    .font(.title2.bold())
                                    .foregroundStyle(.green)
                                Spacer()
                                Text("\(Int(fO2))% O\u{2082} / \(Int(100 - fO2))% N\u{2082}")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $fO2, in: 21...40, step: 1)
                                .tint(.green)
                        }

                        HStack(spacing: 16) {
                            Button("EAN32") { fO2 = 32 }
                                .buttonStyle(.bordered)
                                .tint(fO2 == 32 ? .green : .gray)
                            Button("EAN36") { fO2 = 36 }
                                .buttonStyle(.bordered)
                                .tint(fO2 == 36 ? .green : .gray)
                            Button("Air (21%)") { fO2 = 21 }
                                .buttonStyle(.bordered)
                                .tint(fO2 == 21 ? .green : .gray)
                        }
                        .font(.caption)
                    }
                }

                // MARK: - ppO2 Limit
                PlannerSection(title: "ppO\u{2082} Limit", icon: "gauge.with.needle.fill", color: .orange) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(String(format: "%.1f", ppO2Max)) ATA")
                                .font(.headline)
                            Spacer()
                            Text(ppO2Max <= 1.4 ? "Recreational" : "Technical")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(ppO2Max <= 1.4 ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                                .foregroundStyle(ppO2Max <= 1.4 ? .green : .orange)
                                .clipShape(Capsule())
                        }
                        Slider(value: $ppO2Max, in: 1.2...1.6, step: 0.1)
                            .tint(.orange)

                        Text("1.4 standard recreational limit; 1.6 contingency/deco")
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
                    }
                }

                // MARK: - Results
                VStack(spacing: 16) {
                    Text("Nitrox Results")
                        .font(.headline)

                    // MOD
                    VStack(spacing: 4) {
                        Text("Maximum Operating Depth")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(units.depthDisplay(max(modFeet, 0)))
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(plannedDepth > modFeet ? .red : .green)
                    }

                    if plannedDepth > modFeet {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.octagon.fill")
                                .foregroundStyle(.red)
                            Text("Planned depth EXCEEDS the MOD for EAN\(Int(fO2))!")
                                .font(.caption.bold())
                                .foregroundStyle(.red)
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ResultCard(label: "EAD at Depth", value: units.depthDisplay(max(eadFeet, 0)), color: .cyan)
                        ResultCard(label: "ppO\u{2082} at Depth", value: String(format: "%.2f ATA", ppO2AtDepth), color: ppO2Status.color)
                    }

                    // ppO2 status
                    HStack {
                        Image(systemName: ppO2AtDepth <= 1.4 ? "checkmark.circle.fill" :
                                (ppO2AtDepth <= 1.6 ? "exclamationmark.triangle.fill" : "xmark.octagon.fill"))
                            .foregroundStyle(ppO2Status.color)
                        Text(ppO2Status.text)
                            .font(.subheadline.bold())
                            .foregroundStyle(ppO2Status.color)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ppO2Status.color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    // EAD explanation
                    VStack(alignment: .leading, spacing: 4) {
                        Text("What is EAD?")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                        Text("Equivalent Air Depth — the depth at which air would have the same nitrogen partial pressure. Use EAD to look up no-deco limits on standard air tables when diving nitrox.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Nitrox Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NitroxCalculatorView()
            .environmentObject(UnitSettings())
    }
}
