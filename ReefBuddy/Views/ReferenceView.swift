import SwiftUI

struct ReferenceView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Hand Signals
                    NavigationLink(destination: HandSignalsView()) {
                        ReferenceCard(
                            icon: "hand.raised.fill",
                            title: "Hand Signals",
                            subtitle: "20 essential underwater signals",
                            color: .cyan
                        )
                    }

                    // MARK: - Dive Tables
                    NavigationLink(destination: DiveTableView()) {
                        ReferenceCard(
                            icon: "tablecells",
                            title: "Dive Tables",
                            subtitle: "No-decompression limits by depth",
                            color: .blue
                        )
                    }

                    // MARK: - Safety Checklists
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Safety Checklists")
                            .font(.headline)
                            .padding(.horizontal, 4)

                        ForEach(SafetyChecklist.allChecklists) { checklist in
                            NavigationLink(destination: SafetyChecklistView(checklist: checklist)) {
                                HStack(spacing: 12) {
                                    Image(systemName: checklist.icon)
                                        .font(.title3)
                                        .foregroundStyle(.orange)
                                        .frame(width: 36)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(checklist.title)
                                            .font(.subheadline.bold())
                                            .foregroundStyle(.primary)
                                        Text("\(checklist.items.count) items")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
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
            .navigationTitle("Reference")
        }
    }
}

struct ReferenceCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(color.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ReferenceView()
        .environmentObject(UnitSettings())
}
