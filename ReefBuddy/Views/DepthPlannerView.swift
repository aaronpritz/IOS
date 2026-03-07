import SwiftUI

struct DepthPlannerView: View {
    @EnvironmentObject var units: UnitSettings

    // Dive 1
    @State private var dive1Depth: Double = 60       // ft
    @State private var dive1Time: Double = 30        // min

    // Surface interval
    @State private var surfaceInterval: Double = 60  // min

    // Dive 2
    @State private var dive2Depth: Double = 40       // ft

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Disclaimer
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("Planning tool only — always use your dive computer for actual diving.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Dive 1
                PlannerSection(title: "First Dive", icon: "1.circle.fill", color: .cyan) {
                    VStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            Text("Planned Depth: \(Int(units.toDisplayDepth(dive1Depth))) \(units.depthUnit)")
                                .font(.subheadline)
                            Slider(value: $dive1Depth, in: 20...130, step: 5)
                                .tint(.cyan)
                        }

                        let noDecoLimit1 = DiveTableData.noDecoLimit(forDepthFeet: Int(dive1Depth)) ?? 0

                        VStack(alignment: .leading) {
                            HStack {
                                Text("Bottom Time: \(Int(dive1Time)) min")
                                    .font(.subheadline)
                                Spacer()
                                Text("Max: \(noDecoLimit1) min")
                                    .font(.caption)
                                    .foregroundStyle(dive1Time > Double(noDecoLimit1) ? .red : .secondary)
                            }
                            Slider(value: $dive1Time, in: 5...Double(max(noDecoLimit1, 10)), step: 5)
                                .tint(dive1Time > Double(noDecoLimit1) * 0.8 ? .orange : .cyan)
                        }

                        // Status
                        if dive1Time > Double(noDecoLimit1) {
                            Label("Exceeds no-deco limit!", systemImage: "exclamationmark.triangle.fill")
                                .font(.subheadline.bold())
                                .foregroundStyle(.red)
                        } else {
                            let remaining = noDecoLimit1 - Int(dive1Time)
                            Label("\(remaining) min remaining within no-deco limit", systemImage: "checkmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                        }
                    }
                }

                // MARK: - Surface Interval
                PlannerSection(title: "Surface Interval", icon: "clock.fill", color: .teal) {
                    VStack(spacing: 8) {
                        Text("\(Int(surfaceInterval)) minutes")
                            .font(.title2.bold())
                            .foregroundStyle(.teal)

                        Slider(value: $surfaceInterval, in: 0...360, step: 15)
                            .tint(.teal)

                        HStack {
                            Text("0 min")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("6 hours")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        if surfaceInterval < 60 {
                            Label("Minimum 1 hour recommended between dives", systemImage: "info.circle")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                    }
                }

                // MARK: - Dive 2 (Repetitive)
                PlannerSection(title: "Second Dive", icon: "2.circle.fill", color: .blue) {
                    VStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            Text("Planned Depth: \(Int(units.toDisplayDepth(dive2Depth))) \(units.depthUnit)")
                                .font(.subheadline)
                            Slider(value: $dive2Depth, in: 20...130, step: 5)
                                .tint(.blue)
                        }

                        let adjustedLimit = adjustedNoDecoLimit

                        VStack(spacing: 4) {
                            Text("Adjusted No-Deco Limit")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(adjustedLimit) min")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(adjustedLimit < 15 ? .orange : .blue)
                        }

                        if dive2Depth > dive1Depth {
                            Label("Second dive should be shallower than the first", systemImage: "info.circle")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                    }
                }

                // MARK: - Summary
                VStack(spacing: 12) {
                    Text("Plan Summary")
                        .font(.headline)

                    HStack(spacing: 16) {
                        SummaryItem(label: "Dive 1", value: "\(Int(units.toDisplayDepth(dive1Depth))) \(units.depthUnit) / \(Int(dive1Time)) min")
                        SummaryItem(label: "Interval", value: "\(Int(surfaceInterval)) min")
                        SummaryItem(label: "Dive 2", value: "\(Int(units.toDisplayDepth(dive2Depth))) \(units.depthUnit) / \(adjustedNoDecoLimit) min max")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // MARK: - Safety Reminders
                VStack(alignment: .leading, spacing: 8) {
                    Text("Planning Rules of Thumb")
                        .font(.subheadline.bold())

                    planningTip("Make the deeper dive first")
                    planningTip("Wait at least 1 hour between dives")
                    planningTip("Plan shallower and shorter for repetitive dives")
                    planningTip("Always do a 3-min safety stop at 15 ft / 5m")
                    planningTip("Ascend no faster than 30 ft / 9m per minute")
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Dive Planner")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Simplified repetitive dive adjustment
    private var adjustedNoDecoLimit: Int {
        let baseLimit = DiveTableData.noDecoLimit(forDepthFeet: Int(dive2Depth)) ?? 0
        // Reduce based on nitrogen loading from dive 1
        // More time at depth = more reduction, more surface interval = less reduction
        let loadingFactor = dive1Time / 60.0
        let offgassingFactor = min(surfaceInterval / 180.0, 1.0)
        let penalty = Int(Double(baseLimit) * loadingFactor * (1.0 - offgassingFactor))
        return max(baseLimit - penalty, 5)
    }

    private func planningTip(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.caption)
            Text(text)
                .font(.caption)
        }
    }
}

// MARK: - Supporting Views

struct PlannerSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundStyle(color)

            content
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct SummaryItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.bold())
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        DepthPlannerView()
            .environmentObject(UnitSettings())
    }
}
