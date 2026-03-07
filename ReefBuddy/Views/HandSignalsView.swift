import SwiftUI

struct HandSignalsView: View {
    @State private var selectedCategory: HandSignal.SignalCategory = .essential
    @State private var expandedSignal: UUID?

    var filteredSignals: [HandSignal] {
        HandSignal.allSignals.filter { $0.category == selectedCategory }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Category picker
                Picker("Category", selection: $selectedCategory) {
                    ForEach(HandSignal.SignalCategory.allCases, id: \.self) { cat in
                        Text(cat.rawValue).tag(cat)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Signal cards
                ForEach(filteredSignals) { signal in
                    SignalCard(signal: signal, isExpanded: expandedSignal == signal.id)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                if expandedSignal == signal.id {
                                    expandedSignal = nil
                                } else {
                                    expandedSignal = signal.id
                                }
                            }
                        }
                }
            }
            .padding()
        }
        .navigationTitle("Hand Signals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SignalCard: View {
    let signal: HandSignal
    let isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: signal.icon)
                    .font(.title2)
                    .foregroundStyle(.cyan)
                    .frame(width: 40, height: 40)
                    .background(Color.cyan.opacity(0.15))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(signal.name)
                        .font(.headline)
                    Text("Tap for details")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("How to signal:")
                            .font(.caption.bold())
                            .foregroundStyle(.cyan)
                        Text(signal.description)
                            .font(.subheadline)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("When to use:")
                            .font(.caption.bold())
                            .foregroundStyle(.orange)
                        Text(signal.meaning)
                            .font(.subheadline)
                    }
                }
                .padding(.top, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        HandSignalsView()
    }
}
