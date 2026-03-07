import SwiftUI

/// Build a dive plan with site, depth, gas, buddy, and generate a summary
struct DivePlanBuilderView: View {
    @EnvironmentObject var units: UnitSettings
    @EnvironmentObject var buddyStore: BuddyStore

    @State private var diveSite = ""
    @State private var plannedDepth = 60.0     // feet
    @State private var plannedTime = 40        // minutes
    @State private var gasType: GasType = .air
    @State private var entryType: Dive.EntryType = .boat
    @State private var buddyName = ""
    @State private var notes = ""
    @State private var showPlan = false

    enum GasType: String, CaseIterable {
        case air = "Air (21%)"
        case ean32 = "EAN32 (32%)"
        case ean36 = "EAN36 (36%)"
    }

    // No-deco limit (simplified)
    var noDecoLimit: Int {
        let depthFt = units.unitSystem == .imperial ? plannedDepth : plannedDepth * 3.281
        switch depthFt {
        case ..<35: return 999
        case 35..<50: return 205
        case 50..<60: return 80
        case 60..<70: return 55
        case 70..<80: return 40
        case 80..<90: return 30
        case 90..<100: return 25
        case 100..<110: return 20
        case 110..<120: return 15
        case 120..<131: return 10
        default: return 5
        }
    }

    var exceedsNoDecoLimit: Bool {
        plannedTime > noDecoLimit
    }

    // Gas consumption estimate (SAC rate of 0.75 cuft/min at surface)
    var estimatedGasUsage: Int {
        let depthFt = units.unitSystem == .imperial ? plannedDepth : plannedDepth * 3.281
        let ata = (depthFt / 33.0) + 1.0
        let sacRate = 0.75 // cu ft/min at surface (average)
        let consumption = sacRate * ata * Double(plannedTime)
        let safetyStop = sacRate * 1.45 * 3 // 15ft for 3 min
        let ascent = sacRate * (ata / 2) * (depthFt / 30) // ~30ft/min
        return Int(consumption + safetyStop + ascent)
    }

    var tankHasEnoughGas: Bool {
        estimatedGasUsage < 70 // ~70 cuft in an AL80 after reserve
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Site & Buddy
                VStack(alignment: .leading, spacing: 12) {
                    Label("Dive Details", systemImage: "mappin.circle")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)

                    TextField("Dive Site", text: $diveSite)
                        .textFieldStyle(.roundedBorder)

                    BuddyPickerField(buddyName: $buddyName)
                        .padding(8)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4), lineWidth: 0.5))

                    Picker("Entry", selection: $entryType) {
                        ForEach(Dive.EntryType.allCases, id: \.self) { entry in
                            Text(entry.rawValue).tag(entry)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Depth & Time
                VStack(alignment: .leading, spacing: 12) {
                    Label("Depth & Time", systemImage: "arrow.down.to.line")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading) {
                        Text("Planned Depth: \(Int(plannedDepth)) \(units.depthUnit)")
                            .font(.subheadline)
                        Slider(value: $plannedDepth, in: units.depthRange, step: 1)
                    }

                    Stepper("Bottom Time: \(plannedTime) min", value: $plannedTime, in: 5...120, step: 5)

                    // NDL warning
                    HStack {
                        Image(systemName: exceedsNoDecoLimit ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                            .foregroundStyle(exceedsNoDecoLimit ? .red : .green)
                        Text(exceedsNoDecoLimit
                             ? "Exceeds no-deco limit (\(noDecoLimit) min)"
                             : "Within no-deco limit (\(noDecoLimit) min)")
                            .font(.caption)
                            .foregroundStyle(exceedsNoDecoLimit ? .red : .green)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Gas
                VStack(alignment: .leading, spacing: 12) {
                    Label("Gas Mix", systemImage: "aqi.medium")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)

                    Picker("Gas", selection: $gasType) {
                        ForEach(GasType.allCases, id: \.self) { gas in
                            Text(gas.rawValue).tag(gas)
                        }
                    }
                    .pickerStyle(.segmented)

                    HStack {
                        Image(systemName: tankHasEnoughGas ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .foregroundStyle(tankHasEnoughGas ? .green : .orange)
                        Text("Est. gas: ~\(estimatedGasUsage) cuft (AL80 = 77.4 cuft)")
                            .font(.caption)
                            .foregroundStyle(tankHasEnoughGas ? .green : .orange)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Notes
                VStack(alignment: .leading, spacing: 8) {
                    Label("Notes", systemImage: "note.text")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)

                    TextField("Special notes, objectives, hazards...", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Generate Plan
                Button {
                    showPlan = true
                } label: {
                    Label("View Dive Plan", systemImage: "doc.text")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(diveSite.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Dive Plan Builder")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPlan) {
            DivePlanSummarySheet(
                site: diveSite,
                depth: Int(plannedDepth),
                depthUnit: units.depthUnit,
                time: plannedTime,
                gas: gasType.rawValue,
                entry: entryType.rawValue,
                buddy: buddyName,
                ndl: noDecoLimit,
                gasUsage: estimatedGasUsage,
                notes: notes
            )
        }
    }
}

// MARK: - Plan Summary Sheet

struct DivePlanSummarySheet: View {
    let site: String
    let depth: Int
    let depthUnit: String
    let time: Int
    let gas: String
    let entry: String
    let buddy: String
    let ndl: Int
    let gasUsage: Int
    let notes: String
    @Environment(\.dismiss) var dismiss

    private var planText: String {
        var text = """
        DIVE PLAN — \(site)
        \(Date().formatted(date: .abbreviated, time: .shortened))

        Planned Depth: \(depth) \(depthUnit)
        Bottom Time: \(time) min
        No-Deco Limit: \(ndl) min
        Gas Mix: \(gas)
        Est. Gas Usage: ~\(gasUsage) cuft
        Entry: \(entry)
        """
        if !buddy.isEmpty { text += "\nBuddy: \(buddy)" }
        if !notes.isEmpty { text += "\n\nNotes: \(notes)" }
        text += "\n\nSafety Stop: 15ft / 5m for 3 min"
        text += "\nMax Ascent Rate: 30ft / 9m per min"
        text += "\n\n— Generated by ReefBuddy"
        return text
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Plan card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .font(.title2)
                                .foregroundStyle(.cyan)
                            VStack(alignment: .leading) {
                                Text("Dive Plan")
                                    .font(.headline)
                                Text(site)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Divider()

                        PlanRow(label: "Depth", value: "\(depth) \(depthUnit)")
                        PlanRow(label: "Bottom Time", value: "\(time) min")
                        PlanRow(label: "No-Deco Limit", value: "\(ndl) min", warning: time > ndl)
                        PlanRow(label: "Gas Mix", value: gas)
                        PlanRow(label: "Est. Gas", value: "~\(gasUsage) cuft")
                        PlanRow(label: "Entry", value: entry)
                        if !buddy.isEmpty {
                            PlanRow(label: "Buddy", value: buddy)
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Safety Reminders")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                            Text("• Safety stop: 15ft / 5m for 3 min")
                                .font(.caption)
                            Text("• Max ascent: 30ft / 9m per minute")
                                .font(.caption)
                            Text("• Turn pressure: 50% of starting gas")
                                .font(.caption)
                        }

                        if !notes.isEmpty {
                            Divider()
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Notes")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                                Text(notes)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Share
                    ShareLink(item: planText) {
                        Label("Share Dive Plan", systemImage: "square.and.arrow.up")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button {
                        UIPasteboard.general.string = planText
                    } label: {
                        Label("Copy to Clipboard", systemImage: "doc.on.doc")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }
            .navigationTitle("Dive Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct PlanRow: View {
    let label: String
    let value: String
    var warning: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
                .foregroundStyle(warning ? .red : .primary)
            if warning {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DivePlanBuilderView()
            .environmentObject(UnitSettings())
            .environmentObject(BuddyStore())
    }
}
