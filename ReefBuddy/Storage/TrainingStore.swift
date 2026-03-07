import SwiftUI

/// Persistence for training skills and practice logs
class TrainingStore: ObservableObject {
    @Published var skills: [TrainingSkill] = []

    private let saveKey = "ReefBuddyTrainingSkills"

    init() {
        load()
        if skills.isEmpty {
            skills = TrainingSkill.defaultSkills
        }
    }

    func logPractice(for skillID: UUID, confidence: SkillPractice.ConfidenceLevel, note: String) {
        guard let index = skills.firstIndex(where: { $0.id == skillID }) else { return }
        let practice = SkillPractice(date: Date(), confidence: confidence, note: note)
        skills[index].practiceLog.append(practice)
        save()
    }

    func addSkill(_ skill: TrainingSkill) {
        skills.append(skill)
        save()
    }

    func deleteSkill(_ skill: TrainingSkill) {
        skills.removeAll { $0.id == skill.id }
        save()
    }

    func updateNotes(for skillID: UUID, notes: String) {
        guard let index = skills.firstIndex(where: { $0.id == skillID }) else { return }
        skills[index].notes = notes
        save()
    }

    func skills(for category: TrainingSkill.SkillCategory) -> [TrainingSkill] {
        skills.filter { $0.category == category }
    }

    var masteredCount: Int {
        skills.filter(\.isMastered).count
    }

    var totalPractices: Int {
        skills.reduce(0) { $0 + $1.practiceCount }
    }

    var overallProgress: Double {
        guard !skills.isEmpty else { return 0 }
        return skills.reduce(0.0) { $0 + $1.progress } / Double(skills.count)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(skills) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([TrainingSkill].self, from: data) {
            skills = decoded
        }
    }
}
