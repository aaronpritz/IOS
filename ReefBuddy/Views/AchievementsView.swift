import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var store: DiveStore

    private var unlockedCount: Int {
        Achievement.all.filter { $0.isUnlocked(dives: store.dives) }.count
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Progress Header
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(Color(.systemGray4), lineWidth: 6)
                            .frame(width: 80, height: 80)
                        Circle()
                            .trim(from: 0, to: CGFloat(unlockedCount) / CGFloat(Achievement.all.count))
                            .stroke(Color.cyan, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                        VStack(spacing: 0) {
                            Text("\(unlockedCount)")
                                .font(.title2.bold())
                            Text("of \(Achievement.all.count)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text("Achievements Unlocked")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)

                // MARK: - Badge Grid by Category
                ForEach(Achievement.byCategory, id: \.category) { group in
                    VStack(alignment: .leading, spacing: 12) {
                        Label(group.category.rawValue, systemImage: group.category.icon)
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(group.achievements) { achievement in
                                AchievementBadge(
                                    achievement: achievement,
                                    isUnlocked: achievement.isUnlocked(dives: store.dives)
                                )
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Achievements")
    }
}

// MARK: - Achievement Badge

struct AchievementBadge: View {
    let achievement: Achievement
    let isUnlocked: Bool
    @State private var showDetail = false

    var body: some View {
        Button {
            showDetail = true
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isUnlocked ? Color.cyan.opacity(0.15) : Color(.systemGray5))
                        .frame(width: 56, height: 56)
                    Image(systemName: achievement.icon)
                        .font(.title3)
                        .foregroundStyle(isUnlocked ? .cyan : Color(.systemGray3))
                }

                Text(achievement.name)
                    .font(.caption2)
                    .fontWeight(isUnlocked ? .bold : .regular)
                    .foregroundStyle(isUnlocked ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .opacity(isUnlocked ? 1.0 : 0.5)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDetail) {
            AchievementDetailSheet(achievement: achievement, isUnlocked: isUnlocked)
                .presentationDetents([.height(280)])
        }
    }
}

// MARK: - Achievement Detail Sheet

struct AchievementDetailSheet: View {
    let achievement: Achievement
    let isUnlocked: Bool
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.cyan.opacity(0.15) : Color(.systemGray5))
                    .frame(width: 72, height: 72)
                Image(systemName: achievement.icon)
                    .font(.title)
                    .foregroundStyle(isUnlocked ? .cyan : Color(.systemGray3))
            }

            Text(achievement.name)
                .font(.title3.bold())

            Text(achievement.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if isUnlocked {
                Label("Unlocked!", systemImage: "checkmark.seal.fill")
                    .font(.subheadline.bold())
                    .foregroundStyle(.green)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.green.opacity(0.1))
                    .clipShape(Capsule())
            } else {
                Label("Locked", systemImage: "lock.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
            }

            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        AchievementsView()
            .environmentObject(DiveStore())
    }
}
