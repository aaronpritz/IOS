import SwiftUI
import Charts

/// Advanced dive analytics with Swift Charts visualizations
struct DiveAnalyticsView: View {
    @EnvironmentObject var store: DiveStore
    @EnvironmentObject var units: UnitSettings

    private let calendar = Calendar.current

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if store.dives.count < 2 {
                    emptyState
                } else {
                    depthTrendChart
                    diveFrequencyChart
                    temperatureTrendChart
                    durationVsDepthChart
                    topSitesChart
                    personalRecords
                }
            }
            .padding()
        }
        .navigationTitle("Dive Analytics")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Empty State

    @ViewBuilder
    var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Log at least 2 dives to see analytics")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }

    // MARK: - Depth Trend

    @ViewBuilder
    var depthTrendChart: some View {
        let sorted = store.dives.sorted { $0.date < $1.date }

        VStack(alignment: .leading, spacing: 8) {
            Label("Depth Over Time", systemImage: "arrow.down.to.line")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            Chart(sorted) { dive in
                LineMark(
                    x: .value("Date", dive.date),
                    y: .value("Depth", units.toDisplayDepth(dive.maxDepth))
                )
                .foregroundStyle(.cyan)
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Date", dive.date),
                    y: .value("Depth", units.toDisplayDepth(dive.maxDepth))
                )
                .foregroundStyle(.cyan)
                .symbolSize(30)
            }
            .chartYScale(domain: .automatic(includesZero: true))
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let v = value.as(Double.self) {
                            Text("\(Int(v))")
                        }
                    }
                    AxisGridLine()
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) { value in
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                    AxisGridLine()
                }
            }
            .frame(height: 200)

            Text("Max depth per dive (\(units.depthUnit))")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Dive Frequency

    @ViewBuilder
    var diveFrequencyChart: some View {
        let monthlyData = last12MonthsData

        VStack(alignment: .leading, spacing: 8) {
            Label("Monthly Dive Frequency", systemImage: "chart.bar.fill")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            Chart(monthlyData, id: \.month) { item in
                BarMark(
                    x: .value("Month", item.label),
                    y: .value("Dives", item.count)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .blue],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(4)
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let v = value.as(Int.self) {
                            Text("\(v)")
                        }
                    }
                    AxisGridLine()
                }
            }
            .frame(height: 180)

            let total = monthlyData.reduce(0) { $0 + $1.count }
            let avg = monthlyData.isEmpty ? 0.0 : Double(total) / Double(monthlyData.count)
            Text("Avg: \(String(format: "%.1f", avg)) dives/month over last 12 months")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Temperature Trend

    @ViewBuilder
    var temperatureTrendChart: some View {
        let divesWithTemp = store.dives
            .filter { $0.waterTemp != nil }
            .sorted { $0.date < $1.date }

        if divesWithTemp.count >= 2 {
            VStack(alignment: .leading, spacing: 8) {
                Label("Water Temperature", systemImage: "thermometer.medium")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)

                Chart(divesWithTemp) { dive in
                    AreaMark(
                        x: .value("Date", dive.date),
                        y: .value("Temp", units.toDisplayTemp(dive.waterTemp ?? 0))
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange.opacity(0.3), .orange.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)

                    LineMark(
                        x: .value("Date", dive.date),
                        y: .value("Temp", units.toDisplayTemp(dive.waterTemp ?? 0))
                    )
                    .foregroundStyle(.orange)
                    .interpolationMethod(.catmullRom)

                    PointMark(
                        x: .value("Date", dive.date),
                        y: .value("Temp", units.toDisplayTemp(dive.waterTemp ?? 0))
                    )
                    .foregroundStyle(.orange)
                    .symbolSize(25)
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel {
                            if let v = value.as(Double.self) {
                                Text("\(Int(v))°")
                            }
                        }
                        AxisGridLine()
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { value in
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                        AxisGridLine()
                    }
                }
                .frame(height: 180)

                let temps = divesWithTemp.map { units.toDisplayTemp($0.waterTemp ?? 0) }
                let avg = temps.reduce(0, +) / Double(temps.count)
                Text("Avg: \(Int(avg))° \(units.tempUnit)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Duration vs Depth Scatter

    @ViewBuilder
    var durationVsDepthChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Duration vs Depth", systemImage: "chart.dots.scatter")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            Chart(store.dives) { dive in
                PointMark(
                    x: .value("Depth", units.toDisplayDepth(dive.maxDepth)),
                    y: .value("Time", dive.bottomTime)
                )
                .foregroundStyle(colorForRating(dive.rating))
                .symbolSize(50)
            }
            .chartXAxisLabel("Depth (\(units.depthUnit))")
            .chartYAxisLabel("Bottom Time (min)")
            .chartXAxis {
                AxisMarks(position: .bottom) { value in
                    AxisValueLabel {
                        if let v = value.as(Double.self) {
                            Text("\(Int(v))")
                        }
                    }
                    AxisGridLine()
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let v = value.as(Int.self) {
                            Text("\(v)")
                        }
                    }
                    AxisGridLine()
                }
            }
            .frame(height: 200)

            HStack(spacing: 12) {
                ForEach([1, 2, 3, 4, 5], id: \.self) { rating in
                    HStack(spacing: 3) {
                        Circle()
                            .fill(colorForRating(rating))
                            .frame(width: 8, height: 8)
                        Text("\(rating)★")
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Top Sites

    @ViewBuilder
    var topSitesChart: some View {
        let siteData = topSiteData

        if !siteData.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Label("Top Dive Sites", systemImage: "mappin.and.ellipse")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)

                Chart(siteData, id: \.site) { item in
                    BarMark(
                        x: .value("Dives", item.count),
                        y: .value("Site", item.site)
                    )
                    .foregroundStyle(.teal)
                    .cornerRadius(4)
                    .annotation(position: .trailing) {
                        Text("\(item.count)")
                            .font(.caption2.bold())
                            .foregroundStyle(.secondary)
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                    }
                }
                .frame(height: CGFloat(siteData.count) * 36)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Personal Records

    @ViewBuilder
    var personalRecords: some View {
        let dives = store.dives

        VStack(alignment: .leading, spacing: 8) {
            Label("Personal Records", systemImage: "trophy.fill")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            if let deepest = dives.max(by: { $0.maxDepth < $1.maxDepth }) {
                RecordRow(
                    icon: "arrow.down.to.line",
                    label: "Deepest Dive",
                    value: "\(units.depthDisplay(deepest.maxDepth))",
                    detail: "\(deepest.diveSite) — \(deepest.formattedDate)",
                    color: .blue
                )
            }

            if let longest = dives.max(by: { $0.bottomTime < $1.bottomTime }) {
                RecordRow(
                    icon: "clock.fill",
                    label: "Longest Dive",
                    value: "\(longest.bottomTime) min",
                    detail: "\(longest.diveSite) — \(longest.formattedDate)",
                    color: .teal
                )
            }

            if let coldest = dives.filter({ $0.waterTemp != nil }).min(by: { ($0.waterTemp ?? 999) < ($1.waterTemp ?? 999) }) {
                RecordRow(
                    icon: "thermometer.snowflake",
                    label: "Coldest Dive",
                    value: units.tempDisplay(coldest.waterTemp ?? 0),
                    detail: "\(coldest.diveSite) — \(coldest.formattedDate)",
                    color: .cyan
                )
            }

            if let warmest = dives.filter({ $0.waterTemp != nil }).max(by: { ($0.waterTemp ?? 0) < ($1.waterTemp ?? 0) }) {
                RecordRow(
                    icon: "thermometer.sun.fill",
                    label: "Warmest Dive",
                    value: units.tempDisplay(warmest.waterTemp ?? 0),
                    detail: "\(warmest.diveSite) — \(warmest.formattedDate)",
                    color: .orange
                )
            }

            if let clearest = dives.filter({ $0.visibility != nil }).max(by: { ($0.visibility ?? 0) < ($1.visibility ?? 0) }) {
                RecordRow(
                    icon: "eye.fill",
                    label: "Best Visibility",
                    value: units.visibilityDisplay(clearest.visibility ?? 0),
                    detail: "\(clearest.diveSite) — \(clearest.formattedDate)",
                    color: .green
                )
            }

            let uniqueSites = Set(dives.map(\.diveSite)).count
            RecordRow(
                icon: "mappin.circle.fill",
                label: "Sites Explored",
                value: "\(uniqueSites)",
                detail: "\(Set(dives.map(\.location)).count) unique locations",
                color: .purple
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Helpers

    private var last12MonthsData: [(month: Date, label: String, count: Int)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let now = Date()

        return (0..<12).reversed().compactMap { offset -> (month: Date, label: String, count: Int)? in
            guard let month = calendar.date(byAdding: .month, value: -offset, to: now) else { return nil }
            let comps = calendar.dateComponents([.year, .month], from: month)
            let count = store.dives.filter {
                let dc = calendar.dateComponents([.year, .month], from: $0.date)
                return dc.year == comps.year && dc.month == comps.month
            }.count
            return (month: month, label: formatter.string(from: month), count: count)
        }
    }

    private var topSiteData: [(site: String, count: Int)] {
        let grouped = Dictionary(grouping: store.dives, by: \.diveSite)
        return grouped
            .map { (site: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
            .prefix(7)
            .map { $0 }
    }

    private func colorForRating(_ rating: Int) -> Color {
        switch rating {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .teal
        case 5: return .cyan
        default: return .gray
        }
    }
}

// MARK: - Record Row

struct RecordRow: View {
    let icon: String
    let label: String
    let value: String
    let detail: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.bold())
            }

            Spacer()

            Text(detail)
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        DiveAnalyticsView()
            .environmentObject(DiveStore())
            .environmentObject(UnitSettings())
    }
}
