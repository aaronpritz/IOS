import SwiftUI

struct DiveDetailView: View {
    let dive: Dive
    @EnvironmentObject var units: UnitSettings
    @State private var showingEdit = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Header Card
                VStack(spacing: 8) {
                    Text(dive.diveSite)
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text(dive.location)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))

                    Text(dive.formattedDate)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))

                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= dive.rating ? "star.fill" : "star")
                                .foregroundStyle(star <= dive.rating ? .yellow : .white.opacity(0.3))
                                .font(.caption)
                        }
                    }
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.04, green: 0.24, blue: 0.57),
                                 Color(red: 0.04, green: 0.09, blue: 0.15)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // MARK: - Key Stats Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    StatCard(icon: "arrow.down.to.line", label: "Max Depth",
                             value: units.depthDisplay(dive.maxDepth))
                    StatCard(icon: "clock", label: "Bottom Time",
                             value: dive.bottomTimeDisplay)

                    if let temp = dive.waterTemp {
                        StatCard(icon: "thermometer.medium", label: "Water Temp",
                                 value: units.tempDisplay(temp))
                    }

                    if let vis = dive.visibility {
                        StatCard(icon: "eye", label: "Visibility",
                                 value: units.visibilityDisplay(vis))
                    }
                }

                // MARK: - Conditions
                if dive.currentStrength != nil || dive.entryType != nil {
                    HStack(spacing: 12) {
                        if let current = dive.currentStrength {
                            HStack(spacing: 6) {
                                Image(systemName: "wind")
                                    .foregroundStyle(.cyan)
                                Text(current.rawValue)
                                    .font(.subheadline)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        }
                        if let entry = dive.entryType {
                            HStack(spacing: 6) {
                                Image(systemName: entry == .boat ? "sailboat" : (entry == .shore ? "figure.walk" : "rectangle.split.3x1"))
                                    .foregroundStyle(.teal)
                                Text(entry.rawValue)
                                    .font(.subheadline)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                }

                // MARK: - Dive Profile
                DiveProfileChart(depth: dive.maxDepth, bottomTime: dive.bottomTime)

                // MARK: - Buddy
                if !dive.buddyName.isEmpty {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundStyle(.cyan)
                        Text("Dive Buddy")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(dive.buddyName)
                            .font(.subheadline.bold())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // MARK: - Notes
                if !dive.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Notes", systemImage: "note.text")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(dive.notes)
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .navigationTitle("Dive Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 12) {
                    Button {
                        showingEdit = true
                    } label: {
                        Image(systemName: "pencil")
                    }

                    NavigationLink(destination: ShareDiveView(dive: dive)) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $showingEdit) {
            AddDiveView(editingDive: dive)
        }
    }
}

// MARK: - Dive Profile Chart

struct DiveProfileChart: View {
    let depth: Double
    let bottomTime: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Dive Profile", systemImage: "chart.line.downtrend.xyaxis")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                let safetyStopDepth: CGFloat = 15 / CGFloat(depth) * h * 0.8

                Path { path in
                    // Surface start
                    path.move(to: CGPoint(x: 0, y: 0))
                    // Descent (first 15% of time)
                    path.addLine(to: CGPoint(x: w * 0.15, y: h * 0.8))
                    // Bottom time (15% to 65%)
                    path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.8))
                    // Ascent to safety stop (65% to 75%)
                    path.addLine(to: CGPoint(x: w * 0.75, y: safetyStopDepth))
                    // Safety stop (75% to 88%)
                    path.addLine(to: CGPoint(x: w * 0.88, y: safetyStopDepth))
                    // Final ascent (88% to 100%)
                    path.addLine(to: CGPoint(x: w, y: 0))
                }
                .stroke(
                    LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing),
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                )

                // Fill under curve
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: w * 0.15, y: h * 0.8))
                    path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.8))
                    path.addLine(to: CGPoint(x: w * 0.75, y: safetyStopDepth))
                    path.addLine(to: CGPoint(x: w * 0.88, y: safetyStopDepth))
                    path.addLine(to: CGPoint(x: w, y: 0))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(colors: [.cyan.opacity(0.3), .blue.opacity(0.1)],
                                   startPoint: .top, endPoint: .bottom)
                )

                // Safety stop label
                Text("SS 15ft/3min")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                    .position(x: w * 0.815, y: safetyStopDepth - 12)

                // Depth label
                Text("\(Int(depth)) ft")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.cyan)
                    .position(x: w * 0.4, y: h * 0.8 + 14)
            }
            .frame(height: 100)

            HStack {
                Text("0 min")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(bottomTime) min")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Stat Card Component

struct StatCard: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.cyan)

            Text(value)
                .font(.title3.bold())

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        DiveDetailView(dive: Dive.example)
            .environmentObject(UnitSettings())
    }
}
