import SwiftUI

struct ShareDiveView: View {
    let dive: Dive
    @EnvironmentObject var units: UnitSettings
    @State private var showingShareSheet = false

    var shareText: String {
        var text = """
        Dive Log — \(dive.diveSite)
        \(dive.location) | \(dive.formattedDate)

        Max Depth: \(units.depthDisplay(dive.maxDepth))
        Bottom Time: \(dive.bottomTimeDisplay)
        """

        if let temp = dive.waterTemp {
            text += "\nWater Temp: \(units.tempDisplay(temp))"
        }
        if let vis = dive.visibility {
            text += "\nVisibility: \(units.visibilityDisplay(vis))"
        }
        if !dive.buddyName.isEmpty {
            text += "\nBuddy: \(dive.buddyName)"
        }

        let stars = String(repeating: "★", count: dive.rating) + String(repeating: "☆", count: 5 - dive.rating)
        text += "\nRating: \(stars)"

        if !dive.notes.isEmpty {
            text += "\n\nNotes: \(dive.notes)"
        }

        text += "\n\n— Logged with ReefBuddy"
        return text
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Preview Card
                VStack(spacing: 16) {
                    Text("Share Card Preview")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    // The shareable card
                    VStack(spacing: 12) {
                        // Header
                        VStack(spacing: 4) {
                            Text(dive.diveSite)
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                            Text(dive.location)
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.8))
                            Text(dive.formattedDate)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.6))
                        }

                        // Stats row
                        HStack(spacing: 20) {
                            ShareStat(label: "Depth", value: units.depthDisplay(dive.maxDepth))
                            ShareStat(label: "Time", value: dive.bottomTimeDisplay)
                            if let temp = dive.waterTemp {
                                ShareStat(label: "Temp", value: units.tempDisplay(temp))
                            }
                        }

                        // Rating
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= dive.rating ? "star.fill" : "star")
                                    .foregroundStyle(star <= dive.rating ? .yellow : .white.opacity(0.3))
                                    .font(.caption)
                            }
                        }

                        if !dive.notes.isEmpty {
                            Text("\"\(dive.notes)\"")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                                .italic()
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }

                        Text("ReefBuddy")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.04, green: 0.24, blue: 0.57),
                                     Color(red: 0.02, green: 0.12, blue: 0.25)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                // MARK: - Share Options
                VStack(spacing: 12) {
                    // Share as text
                    ShareLink(item: shareText) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Dive Log")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // Copy to clipboard
                    Button {
                        UIPasteboard.general.string = shareText
                    } label: {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copy to Clipboard")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                // MARK: - Text Preview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Text Preview")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)

                    Text(shareText)
                        .font(.caption)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()
        }
        .navigationTitle("Share Dive")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ShareStat: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline.bold())
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.6))
        }
    }
}

#Preview {
    NavigationStack {
        ShareDiveView(dive: Dive.example)
            .environmentObject(UnitSettings())
    }
}
