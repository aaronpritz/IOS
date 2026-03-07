import SwiftUI

struct DiveDetailView: View {
    let dive: Dive
    @EnvironmentObject var units: UnitSettings

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
                NavigationLink(destination: ShareDiveView(dive: dive)) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
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
