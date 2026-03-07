import SwiftUI

struct ShareDiveView: View {
    let dive: Dive
    @EnvironmentObject var units: UnitSettings
    @State private var selectedStyle: CardStyle = .ocean
    @State private var renderedImage: UIImage?
    @State private var showCopied = false

    enum CardStyle: String, CaseIterable {
        case ocean = "Ocean"
        case sunset = "Sunset"
        case deep = "Deep"
        case coral = "Coral"

        var gradient: [Color] {
            switch self {
            case .ocean:
                return [Color(red: 0.04, green: 0.24, blue: 0.57),
                        Color(red: 0.02, green: 0.12, blue: 0.25)]
            case .sunset:
                return [Color(red: 0.85, green: 0.35, blue: 0.15),
                        Color(red: 0.45, green: 0.12, blue: 0.35)]
            case .deep:
                return [Color(red: 0.05, green: 0.05, blue: 0.2),
                        Color(red: 0.0, green: 0.0, blue: 0.08)]
            case .coral:
                return [Color(red: 0.0, green: 0.55, blue: 0.55),
                        Color(red: 0.0, green: 0.25, blue: 0.35)]
            }
        }
    }

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
                // MARK: - Style Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Card Style")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)

                    HStack(spacing: 10) {
                        ForEach(CardStyle.allCases, id: \.self) { style in
                            Button {
                                selectedStyle = style
                                renderCard()
                            } label: {
                                VStack(spacing: 4) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(LinearGradient(colors: style.gradient, startPoint: .top, endPoint: .bottom))
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(selectedStyle == style ? Color.cyan : Color.clear, lineWidth: 2)
                                        )
                                    Text(style.rawValue)
                                        .font(.caption2)
                                        .foregroundStyle(selectedStyle == style ? .primary : .secondary)
                                }
                            }
                        }
                    }
                }

                // MARK: - Card Preview
                diveCard
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                // MARK: - Share Options
                VStack(spacing: 12) {
                    // Share as image
                    if let image = renderedImage {
                        ShareLink(item: Image(uiImage: image), preview: SharePreview(dive.diveSite, image: Image(uiImage: image))) {
                            HStack {
                                Image(systemName: "photo")
                                    .foregroundStyle(.cyan)
                                Text("Share as Image")
                                    .font(.subheadline.bold())
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        // Save to Photos
                        Button {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            showCopied = true
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                    .foregroundStyle(.cyan)
                                Text("Save to Photos")
                                    .font(.subheadline.bold())
                                Spacer()
                                if showCopied {
                                    Text("Saved!")
                                        .font(.caption)
                                        .foregroundStyle(.green)
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

                    // Share as text
                    ShareLink(item: shareText) {
                        HStack {
                            Image(systemName: "text.quote")
                                .foregroundStyle(.cyan)
                            Text("Share as Text")
                                .font(.subheadline.bold())
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
                                .foregroundStyle(.cyan)
                            Text("Copy Text to Clipboard")
                                .font(.subheadline.bold())
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
            }
            .padding()
        }
        .navigationTitle("Share Dive")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            renderCard()
        }
    }

    // MARK: - Dive Card View

    @ViewBuilder
    var diveCard: some View {
        VStack(spacing: 14) {
            // Site name & location
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

            // Stats
            HStack(spacing: 20) {
                ShareStat(label: "Depth", value: units.depthDisplay(dive.maxDepth))
                ShareStat(label: "Time", value: dive.bottomTimeDisplay)
                if let temp = dive.waterTemp {
                    ShareStat(label: "Temp", value: units.tempDisplay(temp))
                }
                if let vis = dive.visibility {
                    ShareStat(label: "Vis", value: units.visibilityDisplay(vis))
                }
            }

            // Conditions chips
            if dive.currentStrength != nil || dive.entryType != nil {
                HStack(spacing: 8) {
                    if let current = dive.currentStrength {
                        Text(current.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.white.opacity(0.15))
                            .clipShape(Capsule())
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    if let entry = dive.entryType {
                        Text(entry.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.white.opacity(0.15))
                            .clipShape(Capsule())
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
            }

            // Species sightings
            if let sightings = dive.speciesSightings, !sightings.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "fish.fill")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.6))
                    Text(sightings.prefix(3).compactMap { $0.species?.commonName }.joined(separator: ", "))
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.7))
                    if sightings.count > 3 {
                        Text("+\(sightings.count - 3) more")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.5))
                    }
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

            // Notes excerpt
            if !dive.notes.isEmpty {
                Text("\"\(dive.notes.prefix(120))\(dive.notes.count > 120 ? "..." : "")\"")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Buddy
            if !dive.buddyName.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.caption2)
                    Text("with \(dive.buddyName)")
                        .font(.caption2)
                }
                .foregroundStyle(.white.opacity(0.6))
            }

            // Branding
            HStack(spacing: 4) {
                Image(systemName: "water.waves")
                    .font(.system(size: 8))
                Text("ReefBuddy")
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(.white.opacity(0.35))
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: selectedStyle.gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    // MARK: - Render to Image

    @MainActor
    private func renderCard() {
        let renderer = ImageRenderer(content:
            diveCard
                .frame(width: 400)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        )
        renderer.scale = 3.0 // High resolution for social media
        renderedImage = renderer.uiImage
    }
}

// MARK: - Share Stat

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
