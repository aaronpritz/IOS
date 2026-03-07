import SwiftUI

/// A visual timeline and calendar heatmap of all dives
struct DiveTimelineView: View {
    @EnvironmentObject var store: DiveStore
    @EnvironmentObject var units: UnitSettings
    @State private var selectedMonth = Date()

    private let calendar = Calendar.current

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Year Heatmap
                yearHeatmap

                // MARK: - Month Calendar
                monthCalendar

                // MARK: - Dives in Selected Month
                monthDiveList
            }
            .padding()
        }
        .navigationTitle("Dive Timeline")
    }

    // MARK: - Year Heatmap

    @ViewBuilder
    var yearHeatmap: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Last 12 Months", systemImage: "calendar")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            let months = last12Months
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 6), spacing: 4) {
                ForEach(months, id: \.self) { month in
                    let count = divesInMonth(month)
                    Button {
                        selectedMonth = month
                    } label: {
                        VStack(spacing: 2) {
                            Text(monthLabel(month))
                                .font(.system(size: 9))
                                .foregroundStyle(.secondary)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(heatColor(count))
                                .frame(height: 32)
                                .overlay {
                                    if count > 0 {
                                        Text("\(count)")
                                            .font(.caption2.bold())
                                            .foregroundStyle(.white)
                                    }
                                }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            // Legend
            HStack(spacing: 4) {
                Text("Less")
                    .font(.system(size: 8))
                    .foregroundStyle(.secondary)
                ForEach([0, 1, 3, 5, 8], id: \.self) { level in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(heatColor(level))
                        .frame(width: 12, height: 12)
                }
                Text("More")
                    .font(.system(size: 8))
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Month Calendar

    @ViewBuilder
    var monthCalendar: some View {
        VStack(spacing: 12) {
            // Month navigation
            HStack {
                Button {
                    selectedMonth = calendar.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
                } label: {
                    Image(systemName: "chevron.left")
                }

                Spacer()
                Text(fullMonthLabel(selectedMonth))
                    .font(.headline)
                Spacer()

                Button {
                    selectedMonth = calendar.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
                } label: {
                    Image(systemName: "chevron.right")
                }
            }

            // Day headers
            let dayNames = ["S", "M", "T", "W", "T", "F", "S"]
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 4) {
                ForEach(dayNames, id: \.self) { day in
                    Text(day)
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                }
            }

            // Calendar grid
            let days = calendarDays(for: selectedMonth)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 4) {
                ForEach(days, id: \.self) { day in
                    if let day = day {
                        let count = divesOnDay(day)
                        VStack(spacing: 2) {
                            Text("\(calendar.component(.day, from: day))")
                                .font(.caption)
                                .fontWeight(count > 0 ? .bold : .regular)
                                .foregroundStyle(count > 0 ? .primary : .secondary)

                            if count > 0 {
                                Circle()
                                    .fill(Color.cyan)
                                    .frame(width: 6, height: 6)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .frame(height: 36)
                    } else {
                        Color.clear.frame(height: 36)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Month Dive List

    @ViewBuilder
    var monthDiveList: some View {
        let dives = divesForSelectedMonth
        if dives.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "water.waves.slash")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text("No dives in \(fullMonthLabel(selectedMonth))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            VStack(alignment: .leading, spacing: 8) {
                Label("\(dives.count) dive\(dives.count == 1 ? "" : "s") in \(fullMonthLabel(selectedMonth))", systemImage: "water.waves")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)

                ForEach(dives) { dive in
                    NavigationLink(destination: DiveDetailView(dive: dive)) {
                        HStack(spacing: 12) {
                            // Day number
                            VStack {
                                Text("\(calendar.component(.day, from: dive.date))")
                                    .font(.title3.bold())
                                Text(dayOfWeekShort(dive.date))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 36)

                            // Vertical line
                            Rectangle()
                                .fill(Color.cyan)
                                .frame(width: 2)

                            // Dive info
                            VStack(alignment: .leading, spacing: 3) {
                                Text(dive.diveSite)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.primary)
                                HStack(spacing: 12) {
                                    Label(units.depthDisplay(dive.maxDepth), systemImage: "arrow.down.to.line")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Label(dive.bottomTimeDisplay, systemImage: "clock")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                if !dive.buddyName.isEmpty {
                                    Label(dive.buddyName, systemImage: "person.2")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            // Rating
                            HStack(spacing: 1) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= dive.rating ? "star.fill" : "star")
                                        .font(.system(size: 8))
                                        .foregroundStyle(star <= dive.rating ? .yellow : Color(.systemGray4))
                                }
                            }
                        }
                        .padding(.vertical, 6)
                    }

                    if dive.id != dives.last?.id {
                        Divider().padding(.leading, 50)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Helpers

    private var last12Months: [Date] {
        (0..<12).reversed().compactMap {
            calendar.date(byAdding: .month, value: -$0, to: Date())
        }
    }

    private func divesInMonth(_ date: Date) -> Int {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return store.dives.filter {
            let dc = calendar.dateComponents([.year, .month], from: $0.date)
            return dc.year == comps.year && dc.month == comps.month
        }.count
    }

    private func divesOnDay(_ date: Date) -> Int {
        store.dives.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
    }

    private var divesForSelectedMonth: [Dive] {
        let comps = calendar.dateComponents([.year, .month], from: selectedMonth)
        return store.dives.filter {
            let dc = calendar.dateComponents([.year, .month], from: $0.date)
            return dc.year == comps.year && dc.month == comps.month
        }.sorted { $0.date > $1.date }
    }

    private func calendarDays(for date: Date) -> [Date?] {
        let comps = calendar.dateComponents([.year, .month], from: date)
        guard let firstOfMonth = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: firstOfMonth) else { return [] }

        let weekday = calendar.component(.weekday, from: firstOfMonth)
        var days: [Date?] = Array(repeating: nil, count: weekday - 1)

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }

        return days
    }

    private func monthLabel(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMM"
        return f.string(from: date)
    }

    private func fullMonthLabel(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: date)
    }

    private func dayOfWeekShort(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f.string(from: date)
    }

    private func heatColor(_ count: Int) -> Color {
        switch count {
        case 0: return Color(.systemGray5)
        case 1: return Color.cyan.opacity(0.3)
        case 2...3: return Color.cyan.opacity(0.5)
        case 4...6: return Color.cyan.opacity(0.7)
        default: return Color.cyan
        }
    }
}

#Preview {
    NavigationStack {
        DiveTimelineView()
            .environmentObject(DiveStore())
            .environmentObject(UnitSettings())
    }
}
