import SwiftUI

struct StatsView: View {
    @EnvironmentObject var store: DiveStore
    @EnvironmentObject var units: UnitSettings

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Hero Stats
                    HStack(spacing: 12) {
                        HeroStatCard(
                            icon: "number",
                            value: "\(store.totalDives)",
                            label: "Total Dives",
                            color: .cyan
                        )
                        HeroStatCard(
                            icon: "arrow.down.to.line",
                            value: units.depthDisplay(store.deepestDive),
                            label: "Deepest",
                            color: .blue
                        )
                    }

                    HStack(spacing: 12) {
                        HeroStatCard(
                            icon: "clock",
                            value: formatTime(store.totalBottomTime),
                            label: "Total Time",
                            color: .teal
                        )
                        HeroStatCard(
                            icon: "arrow.down.forward",
                            value: units.depthDisplay(store.averageDepth),
                            label: "Avg Depth",
                            color: .indigo
                        )
                    }

                    // MARK: - Favorite Location
                    VStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .foregroundStyle(.pink)

                        Text("Favorite Spot")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(store.favoriteLocation)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // MARK: - Monthly Activity Chart
                    if store.dives.count >= 2 {
                        MonthlyActivityChart(dives: store.dives)
                    }

                    // MARK: - Depth Distribution
                    if store.dives.count >= 2 {
                        DepthDistributionChart(dives: store.dives, units: units)
                    }

                    // MARK: - Recent Dives Preview
                    if !store.dives.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Dives")
                                .font(.headline)
                                .padding(.horizontal, 4)

                            ForEach(store.dives.prefix(3)) { dive in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(dive.diveSite)
                                            .font(.subheadline.bold())
                                        Text(dive.formattedDate)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(units.depthDisplay(dive.maxDepth))
                                        .font(.subheadline)
                                        .foregroundStyle(.cyan)
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
            .navigationTitle("Stats")
        }
    }

    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if hours > 0 {
            return "\(hours)h \(mins)m"
        }
        return "\(mins)m"
    }
}

// MARK: - Monthly Activity Chart

struct MonthlyActivityChart: View {
    let dives: [Dive]

    var monthlyData: [(label: String, count: Int)] {
        let calendar = Calendar.current
        let now = Date()
        var data: [(label: String, count: Int)] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        for i in stride(from: 5, through: 0, by: -1) {
            if let month = calendar.date(byAdding: .month, value: -i, to: now) {
                let components = calendar.dateComponents([.year, .month], from: month)
                let count = dives.filter {
                    let dc = calendar.dateComponents([.year, .month], from: $0.date)
                    return dc.year == components.year && dc.month == components.month
                }.count
                data.append((label: formatter.string(from: month), count: count))
            }
        }
        return data
    }

    var maxCount: Int {
        max(monthlyData.map(\.count).max() ?? 1, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Monthly Activity", systemImage: "chart.bar.fill")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(monthlyData, id: \.label) { item in
                    VStack(spacing: 4) {
                        Text("\(item.count)")
                            .font(.caption2.bold())
                            .foregroundStyle(item.count > 0 ? .cyan : .secondary)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(item.count > 0 ?
                                  LinearGradient(colors: [.cyan, .blue], startPoint: .top, endPoint: .bottom) :
                                    LinearGradient(colors: [Color(.systemGray4)], startPoint: .top, endPoint: .bottom))
                            .frame(height: item.count > 0 ? CGFloat(item.count) / CGFloat(maxCount) * 80 : 4)

                        Text(item.label)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 110)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Depth Distribution

struct DepthDistributionChart: View {
    let dives: [Dive]
    let units: UnitSettings

    struct DepthBucket {
        let label: String
        let range: ClosedRange<Double>
        var count: Int = 0
    }

    var buckets: [DepthBucket] {
        var b = [
            DepthBucket(label: "0-30ft", range: 0...30),
            DepthBucket(label: "31-60ft", range: 31...60),
            DepthBucket(label: "61-90ft", range: 61...90),
            DepthBucket(label: "91-130ft", range: 91...130),
        ]
        for dive in dives {
            for i in b.indices {
                if b[i].range.contains(dive.maxDepth) {
                    b[i].count += 1
                }
            }
        }
        return b
    }

    var maxCount: Int { max(buckets.map(\.count).max() ?? 1, 1) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Depth Distribution", systemImage: "arrow.down.to.line")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            ForEach(buckets, id: \.label) { bucket in
                HStack(spacing: 8) {
                    Text(bucket.label)
                        .font(.caption)
                        .frame(width: 60, alignment: .trailing)

                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
                            .frame(width: bucket.count > 0 ? CGFloat(bucket.count) / CGFloat(maxCount) * geo.size.width : 0)
                    }
                    .frame(height: 20)

                    Text("\(bucket.count)")
                        .font(.caption.bold())
                        .frame(width: 24, alignment: .leading)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Hero Stat Card

struct HeroStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title.bold())

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    StatsView()
        .environmentObject(DiveStore())
        .environmentObject(UnitSettings())
}
