import SwiftUI

/// BWRAF pre-dive buddy check + safety checklist
struct PreDiveChecklistView: View {
    @State private var checks: [CheckSection] = CheckSection.defaultChecklist
    @State private var showConfetti = false

    var totalItems: Int { checks.flatMap(\.items).count }
    var checkedItems: Int { checks.flatMap(\.items).filter(\.isChecked).count }
    var allComplete: Bool { checkedItems == totalItems }
    var progress: Double {
        guard totalItems > 0 else { return 0 }
        return Double(checkedItems) / Double(totalItems)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Progress
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .stroke(Color(.systemGray4), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(allComplete ? Color.green : Color.cyan, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                            .animation(.spring, value: progress)
                        VStack(spacing: 0) {
                            Text("\(checkedItems)")
                                .font(.title2.bold())
                            Text("of \(totalItems)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if allComplete {
                        Label("All Clear — Safe to Dive!", systemImage: "checkmark.seal.fill")
                            .font(.subheadline.bold())
                            .foregroundStyle(.green)
                    } else {
                        Text("Complete all checks before entering the water")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()

                // MARK: - Checklist Sections
                ForEach($checks) { $section in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: section.icon)
                                .foregroundStyle(section.accentColor)
                            Text(section.title)
                                .font(.headline)
                            Spacer()
                            let done = section.items.filter(\.isChecked).count
                            Text("\(done)/\(section.items.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        if !section.subtitle.isEmpty {
                            Text(section.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        ForEach($section.items) { $item in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    item.isChecked.toggle()
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundStyle(item.isChecked ? .green : .secondary)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.title)
                                            .font(.subheadline)
                                            .strikethrough(item.isChecked)
                                            .foregroundStyle(item.isChecked ? .secondary : .primary)
                                        if !item.detail.isEmpty {
                                            Text(item.detail)
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }

                                    Spacer()
                                }
                                .padding(.horizontal, 4)
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Reset button
                Button {
                    withAnimation {
                        for i in checks.indices {
                            for j in checks[i].items.indices {
                                checks[i].items[j].isChecked = false
                            }
                        }
                    }
                } label: {
                    Label("Reset Checklist", systemImage: "arrow.counterclockwise")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.secondary)
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("Pre-Dive Safety Check")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Data Models

struct CheckSection: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let accentColor: Color
    var items: [CheckItem]

    static var defaultChecklist: [CheckSection] {
        [
            // BWRAF - Begin With Review And Friend
            CheckSection(
                title: "B — BCD / Buoyancy",
                subtitle: "BWRAF buddy check",
                icon: "figure.water.fitness",
                accentColor: .cyan,
                items: [
                    CheckItem(title: "BCD inflates and deflates", detail: "Test oral and power inflator"),
                    CheckItem(title: "Dump valves work", detail: "Check all dump valves release air"),
                    CheckItem(title: "BCD fits snugly", detail: "Adjust straps and cummerbund"),
                ]
            ),
            CheckSection(
                title: "W — Weights",
                subtitle: "",
                icon: "scalemass.fill",
                accentColor: .blue,
                items: [
                    CheckItem(title: "Correct weight amount", detail: "Check weight for conditions and exposure suit"),
                    CheckItem(title: "Quick-release works", detail: "Both you and buddy know how to ditch weights"),
                    CheckItem(title: "Weights secured", detail: "Weight pouches or belt properly fastened"),
                ]
            ),
            CheckSection(
                title: "R — Releases",
                subtitle: "",
                icon: "link",
                accentColor: .teal,
                items: [
                    CheckItem(title: "All clips and buckles secured", detail: "Tank band, chest clip, waist buckle"),
                    CheckItem(title: "Nothing dangling", detail: "Console, octo, and gauges clipped or tucked"),
                    CheckItem(title: "Tank valve fully open", detail: "Open all the way, then back a quarter turn"),
                ]
            ),
            CheckSection(
                title: "A — Air",
                subtitle: "",
                icon: "wind",
                accentColor: .green,
                items: [
                    CheckItem(title: "Tank is full", detail: "Check pressure — should read 200 bar / 3000 psi"),
                    CheckItem(title: "Breathe from primary", detail: "Take several breaths, check gauge drops and returns"),
                    CheckItem(title: "Breathe from alternate", detail: "Test buddy's octopus / alternate air source"),
                    CheckItem(title: "Agree on turn pressure", detail: "Set turn-around and safety stop pressure"),
                ]
            ),
            CheckSection(
                title: "F — Final Check",
                subtitle: "",
                icon: "person.2.fill",
                accentColor: .orange,
                items: [
                    CheckItem(title: "Mask clean and fitted", detail: "Defog applied, strap adjusted"),
                    CheckItem(title: "Fins on and secure", detail: "Straps adjusted, no loose buckles"),
                    CheckItem(title: "Dive computer on", detail: "Check battery, mode, and gas mix"),
                    CheckItem(title: "Dive plan reviewed", detail: "Max depth, bottom time, entry/exit, signals"),
                    CheckItem(title: "Buddy check complete", detail: "Both divers give OK signal"),
                ]
            ),

            // Emergency
            CheckSection(
                title: "Emergency Prep",
                subtitle: "Know before you go",
                icon: "cross.circle.fill",
                accentColor: .red,
                items: [
                    CheckItem(title: "Emergency contact noted", detail: "DAN, local chamber, boat captain phone"),
                    CheckItem(title: "O₂ kit location known", detail: "Know where the emergency oxygen is"),
                    CheckItem(title: "First aid kit accessible", detail: "Verify location and basic contents"),
                    CheckItem(title: "Communication plan", detail: "Lost buddy procedure, recall signals agreed"),
                ]
            ),
        ]
    }
}

struct CheckItem: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    var isChecked = false
}

#Preview {
    NavigationStack {
        PreDiveChecklistView()
    }
}
