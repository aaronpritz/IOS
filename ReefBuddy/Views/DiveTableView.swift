import SwiftUI

struct DiveTableView: View {
    @EnvironmentObject var units: UnitSettings
    @State private var selectedDepthIndex: Int = 4 // default to 70ft/21m

    var selectedEntry: DiveTableEntry {
        DiveTableData.entries[selectedDepthIndex]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Disclaimer
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("Reference only — always use your dive computer for actual diving.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Quick Planner
                VStack(spacing: 16) {
                    Text("Quick No-Deco Lookup")
                        .font(.headline)

                    VStack(spacing: 8) {
                        Text("Planned Depth")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(depthLabel(for: selectedEntry))
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(.cyan)

                        Slider(
                            value: Binding(
                                get: { Double(selectedDepthIndex) },
                                set: { selectedDepthIndex = Int($0) }
                            ),
                            in: 0...Double(DiveTableData.entries.count - 1),
                            step: 1
                        )
                        .tint(.cyan)
                    }

                    // Result
                    VStack(spacing: 4) {
                        Text("No-Deco Limit")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("\(selectedEntry.noDecoLimit) min")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(noDecoColor(minutes: selectedEntry.noDecoLimit))

                        Text("Pressure Group: \(selectedEntry.pressureGroup)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // MARK: - Full Table
                VStack(alignment: .leading, spacing: 12) {
                    Text("Full No-Deco Table")
                        .font(.headline)

                    // Table header
                    HStack {
                        Text("Depth")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("No-Deco Limit")
                            .frame(maxWidth: .infinity)
                        Text("Group")
                            .frame(width: 50, alignment: .trailing)
                    }
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)

                    // Table rows
                    ForEach(Array(DiveTableData.entries.enumerated()), id: \.element.id) { index, entry in
                        HStack {
                            Text(depthLabel(for: entry))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("\(entry.noDecoLimit) min")
                                .foregroundStyle(noDecoColor(minutes: entry.noDecoLimit))
                                .frame(maxWidth: .infinity)

                            Text(entry.pressureGroup)
                                .frame(width: 50, alignment: .trailing)
                                .foregroundStyle(.secondary)
                        }
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            index == selectedDepthIndex
                            ? Color.cyan.opacity(0.15)
                            : (index % 2 == 0 ? Color(.systemGray6) : Color.clear)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture {
                            withAnimation { selectedDepthIndex = index }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6).opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // MARK: - Safety Reminder
                VStack(alignment: .leading, spacing: 8) {
                    Label("Safety Tips", systemImage: "shield.checkered")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 6) {
                        safetyTip("Always do a 3-minute safety stop at 15 ft / 5m")
                        safetyTip("Plan your dive, dive your plan")
                        safetyTip("Stay well within no-deco limits — they are maximums, not targets")
                        safetyTip("Ascend no faster than 30 ft / 9m per minute")
                        safetyTip("Wait at least 1 hour between repetitive dives")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Dive Tables")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func depthLabel(for entry: DiveTableEntry) -> String {
        switch units.unitSystem {
        case .imperial:
            return "\(entry.depthFeet) ft"
        case .metric:
            return "\(entry.depthMeters) m"
        }
    }

    private func noDecoColor(minutes: Int) -> Color {
        if minutes >= 80 { return .green }
        if minutes >= 30 { return .cyan }
        if minutes >= 16 { return .orange }
        return .red
    }

    private func safetyTip(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.caption)
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    NavigationStack {
        DiveTableView()
            .environmentObject(UnitSettings())
    }
}
