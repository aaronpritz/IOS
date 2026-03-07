import SwiftUI

struct DiveListView: View {
    @EnvironmentObject var store: DiveStore
    @EnvironmentObject var units: UnitSettings
    @State private var showingAddDive = false

    var body: some View {
        NavigationStack {
            ZStack {
                if store.dives.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "water.waves")
                            .font(.system(size: 60))
                            .foregroundStyle(.cyan.opacity(0.5))

                        Text("No Dives Yet")
                            .font(.title2.bold())

                        Text("Tap + to log your first dive!")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    List {
                        ForEach(store.dives) { dive in
                            NavigationLink(destination: DiveDetailView(dive: dive)) {
                                DiveRowView(dive: dive)
                            }
                        }
                        .onDelete(perform: store.deleteDive)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("ReefBuddy")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddDive = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddDive) {
                AddDiveView()
            }
        }
    }
}

// MARK: - Dive Row Component

struct DiveRowView: View {
    let dive: Dive
    @EnvironmentObject var units: UnitSettings

    var body: some View {
        HStack(spacing: 12) {
            // Depth indicator circle
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 50, height: 50)

                Text(units.depthDisplay(dive.maxDepth))
                    .font(.caption.bold())
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(dive.diveSite)
                    .font(.headline)

                Text(dive.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    Label(dive.bottomTimeDisplay, systemImage: "clock")
                    Label(dive.formattedDate, systemImage: "calendar")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(.caption2)
                Text("\(dive.rating)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DiveListView()
        .environmentObject(DiveStore())
        .environmentObject(UnitSettings())
}
