import SwiftUI

/// View and log condition reports for a specific dive site
struct SiteConditionsView: View {
    let siteName: String
    @EnvironmentObject var conditionsStore: SiteConditionsStore
    @EnvironmentObject var units: UnitSettings
    @State private var showingAddReport = false

    var siteConditions: [SiteCondition] {
        conditionsStore.conditions(for: siteName)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Summary
                if !siteConditions.isEmpty {
                    summaryCard
                }

                // MARK: - Reports
                if siteConditions.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)
                        Text("No condition reports yet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Log conditions after your dive to help future visits")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(32)
                } else {
                    ForEach(siteConditions) { condition in
                        conditionCard(condition)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Site Conditions")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddReport = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddReport) {
            AddConditionReportView(siteName: siteName)
        }
    }

    // MARK: - Summary Card

    @ViewBuilder
    var summaryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Conditions Summary", systemImage: "chart.bar.doc.horizontal")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("\(siteConditions.count)")
                        .font(.title2.bold())
                    Text("Reports")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Divider().frame(height: 36)

                VStack(spacing: 4) {
                    HStack(spacing: 2) {
                        let avg = conditionsStore.averageRating(for: siteName)
                        Text(String(format: "%.1f", avg))
                            .font(.title2.bold())
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                    }
                    Text("Avg Rating")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Divider().frame(height: 36)

                if let latest = siteConditions.first {
                    VStack(spacing: 4) {
                        Text(latest.currentStrength.rawValue)
                            .font(.subheadline.bold())
                        Text("Last Current")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)

            // Most common conditions
            if siteConditions.count >= 2 {
                Divider()

                let currents = Dictionary(grouping: siteConditions, by: \.currentStrength)
                    .mapValues(\.count)
                    .sorted { $0.value > $1.value }

                if let topCurrent = currents.first {
                    HStack(spacing: 6) {
                        Image(systemName: topCurrent.key.icon)
                            .font(.caption)
                            .foregroundStyle(.cyan)
                        Text("Most common: \(topCurrent.key.rawValue) current (\(topCurrent.value)x)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Condition Card

    @ViewBuilder
    func conditionCard(_ condition: SiteCondition) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header
            HStack {
                Text(condition.formattedDate)
                    .font(.subheadline.bold())
                Spacer()
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= condition.overallRating ? "star.fill" : "star")
                            .font(.system(size: 10))
                            .foregroundStyle(star <= condition.overallRating ? .yellow : Color(.systemGray4))
                    }
                }
            }

            // Conditions grid
            HStack(spacing: 12) {
                if let temp = condition.waterTemp {
                    ConditionChip(icon: "thermometer.medium", text: units.tempDisplay(temp))
                }
                if let vis = condition.visibility {
                    ConditionChip(icon: "eye", text: units.visibilityDisplay(vis))
                }
                ConditionChip(icon: condition.currentStrength.icon, text: condition.currentStrength.rawValue)
                ConditionChip(icon: "water.waves", text: condition.surfaceConditions.rawValue)
            }

            // Notes
            if !condition.entryNotes.isEmpty {
                NoteRow(label: "Entry", text: condition.entryNotes, icon: "arrow.down.circle")
            }
            if !condition.exitNotes.isEmpty {
                NoteRow(label: "Exit", text: condition.exitNotes, icon: "arrow.up.circle")
            }
            if !condition.hazards.isEmpty {
                NoteRow(label: "Hazards", text: condition.hazards, icon: "exclamationmark.triangle")
            }
            if !condition.tips.isEmpty {
                NoteRow(label: "Tips", text: condition.tips, icon: "lightbulb")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contextMenu {
            Button(role: .destructive) {
                withAnimation {
                    conditionsStore.delete(condition)
                }
            } label: {
                Label("Delete Report", systemImage: "trash")
            }
        }
    }
}

// MARK: - Condition Chip

struct ConditionChip: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 9))
            Text(text)
                .font(.caption2)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.systemGray5))
        .clipShape(Capsule())
    }
}

// MARK: - Note Row

struct NoteRow: View {
    let label: String
    let text: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 16)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                Text(text)
                    .font(.caption)
            }
        }
    }
}

// MARK: - Add Condition Report

struct AddConditionReportView: View {
    let siteName: String
    @EnvironmentObject var conditionsStore: SiteConditionsStore
    @EnvironmentObject var units: UnitSettings
    @Environment(\.dismiss) var dismiss

    @State private var date = Date()
    @State private var waterTemp = 78.0
    @State private var hasTemp = true
    @State private var visibility = 50
    @State private var hasVisibility = true
    @State private var currentStrength: SiteCondition.CurrentLevel = .mild
    @State private var surfaceConditions: SiteCondition.SurfaceLevel = .calm
    @State private var entryNotes = ""
    @State private var exitNotes = ""
    @State private var hazards = ""
    @State private var tips = ""
    @State private var rating = 3

    var body: some View {
        NavigationStack {
            Form {
                Section("Date & Site") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    HStack {
                        Text("Site")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(siteName)
                            .bold()
                    }
                }

                Section("Water Conditions") {
                    Toggle("Log Water Temp", isOn: $hasTemp)
                    if hasTemp {
                        VStack(alignment: .leading) {
                            Text("Water Temp: \(Int(waterTemp))° \(units.tempUnit)")
                                .font(.subheadline)
                            Slider(value: $waterTemp, in: units.tempRange, step: 1)
                        }
                    }

                    Toggle("Log Visibility", isOn: $hasVisibility)
                    if hasVisibility {
                        Stepper("Visibility: \(visibility) \(units.visibilityUnit)",
                                value: $visibility,
                                in: units.visibilityRange,
                                step: units.unitSystem == .imperial ? 5 : 1)
                    }

                    Picker("Current", selection: $currentStrength) {
                        ForEach(SiteCondition.CurrentLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }

                    Picker("Surface", selection: $surfaceConditions) {
                        ForEach(SiteCondition.SurfaceLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                }

                Section("Entry & Exit") {
                    TextField("Entry notes (e.g. giant stride from boat)", text: $entryNotes, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Exit notes (e.g. ladder exit, watch surge)", text: $exitNotes, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Hazards & Tips") {
                    TextField("Hazards (e.g. strong surge, boat traffic)", text: $hazards, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Tips for future visits", text: $tips, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Overall Rating") {
                    HStack {
                        Text("Conditions")
                        Spacer()
                        ForEach(1...5, id: \.self) { star in
                            Button {
                                rating = star
                            } label: {
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .foregroundStyle(star <= rating ? .yellow : Color(.systemGray4))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Log Conditions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveReport()
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveReport() {
        let condition = SiteCondition(
            siteName: siteName,
            date: date,
            waterTemp: hasTemp ? units.toStoredTemp(waterTemp) : nil,
            visibility: hasVisibility ? units.toStoredVisibility(visibility) : nil,
            currentStrength: currentStrength,
            surfaceConditions: surfaceConditions,
            entryNotes: entryNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            exitNotes: exitNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            hazards: hazards.trimmingCharacters(in: .whitespacesAndNewlines),
            tips: tips.trimmingCharacters(in: .whitespacesAndNewlines),
            overallRating: rating
        )
        conditionsStore.add(condition)
    }
}

// MARK: - All Sites Conditions (browse all reported sites)

struct AllSiteConditionsView: View {
    @EnvironmentObject var conditionsStore: SiteConditionsStore

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if conditionsStore.reportedSites.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)
                        Text("No condition reports yet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Visit a dive site and log conditions from the site detail page")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(40)
                } else {
                    ForEach(conditionsStore.reportedSites, id: \.self) { siteName in
                        NavigationLink(destination: SiteConditionsView(siteName: siteName)) {
                            HStack(spacing: 12) {
                                Image(systemName: "water.waves")
                                    .font(.title3)
                                    .foregroundStyle(.cyan)
                                    .frame(width: 28)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(siteName)
                                        .font(.subheadline.bold())
                                        .foregroundStyle(.primary)

                                    let count = conditionsStore.conditions(for: siteName).count
                                    let avg = conditionsStore.averageRating(for: siteName)
                                    HStack(spacing: 8) {
                                        Text("\(count) report\(count == 1 ? "" : "s")")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        HStack(spacing: 2) {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 8))
                                                .foregroundStyle(.yellow)
                                            Text(String(format: "%.1f", avg))
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }

                                Spacer()

                                if let latest = conditionsStore.latestCondition(for: siteName) {
                                    Text(latest.formattedDate)
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                }

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Site Conditions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SiteConditionsView(siteName: "Blue Corner")
            .environmentObject(SiteConditionsStore())
            .environmentObject(UnitSettings())
    }
}
