import SwiftUI

struct SafetyChecklistView: View {
    let checklist: SafetyChecklist
    @State private var checkedItems: Set<UUID> = []

    var progress: Double {
        guard !checklist.items.isEmpty else { return 0 }
        return Double(checkedItems.count) / Double(checklist.items.count)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Progress bar
                VStack(spacing: 8) {
                    HStack {
                        Text("\(checkedItems.count) of \(checklist.items.count)")
                            .font(.subheadline.bold())
                        Spacer()
                        if checkedItems.count == checklist.items.count {
                            Label("All Done!", systemImage: "checkmark.seal.fill")
                                .font(.subheadline.bold())
                                .foregroundStyle(.green)
                        }
                    }

                    ProgressView(value: progress)
                        .tint(checkedItems.count == checklist.items.count ? .green : .cyan)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Checklist items
                ForEach(checklist.items) { item in
                    ChecklistItemView(
                        item: item,
                        isChecked: checkedItems.contains(item.id),
                        onToggle: {
                            withAnimation(.spring(response: 0.3)) {
                                if checkedItems.contains(item.id) {
                                    checkedItems.remove(item.id)
                                } else {
                                    checkedItems.insert(item.id)
                                }
                            }
                        }
                    )
                }

                // Reset button
                if !checkedItems.isEmpty {
                    Button {
                        withAnimation {
                            checkedItems.removeAll()
                        }
                    } label: {
                        Label("Reset Checklist", systemImage: "arrow.counterclockwise")
                            .font(.subheadline)
                    }
                    .padding(.top, 8)
                }
            }
            .padding()
        }
        .navigationTitle(checklist.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChecklistItemView: View {
    let item: SafetyItem
    let isChecked: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isChecked ? .green : .secondary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .strikethrough(isChecked)
                        .foregroundStyle(isChecked ? .secondary : .primary)

                    Text(item.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding()
            .background(isChecked ? Color.green.opacity(0.05) : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SafetyChecklistView(checklist: .buddyCheck)
    }
}
