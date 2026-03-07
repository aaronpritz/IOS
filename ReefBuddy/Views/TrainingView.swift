import SwiftUI

/// Track dive skills practice and training progress
struct TrainingView: View {
    @EnvironmentObject var trainingStore: TrainingStore
    @State private var showingAddSkill = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Progress Summary
                progressCard

                // MARK: - Skills by Category
                ForEach(TrainingSkill.SkillCategory.allCases, id: \.self) { category in
                    let categorySkills = trainingStore.skills(for: category)
                    if !categorySkills.isEmpty {
                        categorySection(category: category, skills: categorySkills)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Skills Tracker")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddSkill = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSkill) {
            AddTrainingSkillView()
        }
    }

    // MARK: - Progress Card

    @ViewBuilder
    var progressCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 20) {
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: 8)
                        .frame(width: 70, height: 70)
                    Circle()
                        .trim(from: 0, to: trainingStore.overallProgress)
                        .stroke(
                            trainingStore.overallProgress >= 1.0 ? Color.green : Color.cyan,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 70, height: 70)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring, value: trainingStore.overallProgress)
                    Text("\(Int(trainingStore.overallProgress * 100))%")
                        .font(.caption.bold())
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("\(trainingStore.masteredCount)")
                                .font(.title3.bold())
                            Text("Mastered")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        VStack(alignment: .leading) {
                            Text("\(trainingStore.skills.count)")
                                .font(.title3.bold())
                            Text("Skills")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        VStack(alignment: .leading) {
                            Text("\(trainingStore.totalPractices)")
                                .font(.title3.bold())
                            Text("Practices")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if trainingStore.masteredCount == trainingStore.skills.count && !trainingStore.skills.isEmpty {
                        Label("All skills mastered!", systemImage: "checkmark.seal.fill")
                            .font(.caption.bold())
                            .foregroundStyle(.green)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Category Section

    @ViewBuilder
    func categorySection(category: TrainingSkill.SkillCategory, skills: [TrainingSkill]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.icon)
                    .foregroundStyle(.cyan)
                Text(category.rawValue)
                    .font(.headline)
                Spacer()
                let mastered = skills.filter(\.isMastered).count
                Text("\(mastered)/\(skills.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(skills) { skill in
                NavigationLink(destination: SkillDetailView(skill: skill)) {
                    SkillRow(skill: skill)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Skill Row

struct SkillRow: View {
    let skill: TrainingSkill

    var body: some View {
        HStack(spacing: 12) {
            // Progress indicator
            ZStack {
                Circle()
                    .stroke(Color(.systemGray4), lineWidth: 3)
                    .frame(width: 32, height: 32)
                Circle()
                    .trim(from: 0, to: skill.progress)
                    .stroke(
                        skill.isMastered ? Color.green : Color.cyan,
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(-90))

                if skill.isMastered {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.green)
                } else {
                    Text("\(skill.practiceCount)")
                        .font(.system(size: 10, weight: .bold))
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(skill.name)
                    .font(.subheadline)
                    .foregroundStyle(skill.isMastered ? .secondary : .primary)
                    .strikethrough(skill.isMastered)

                HStack(spacing: 8) {
                    Text("\(skill.practiceCount)/\(skill.targetPractices) practices")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    if let last = skill.lastPracticed {
                        Text(last, style: .relative)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Skill Detail View

struct SkillDetailView: View {
    let skill: TrainingSkill
    @EnvironmentObject var trainingStore: TrainingStore
    @State private var showingLogPractice = false

    var currentSkill: TrainingSkill {
        trainingStore.skills.first(where: { $0.id == skill.id }) ?? skill
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Progress
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .stroke(Color(.systemGray4), lineWidth: 10)
                            .frame(width: 100, height: 100)
                        Circle()
                            .trim(from: 0, to: currentSkill.progress)
                            .stroke(
                                currentSkill.isMastered ? Color.green : Color.cyan,
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))
                            .animation(.spring, value: currentSkill.progress)

                        VStack(spacing: 2) {
                            Text("\(currentSkill.practiceCount)")
                                .font(.title.bold())
                            Text("of \(currentSkill.targetPractices)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text(currentSkill.name)
                        .font(.headline)

                    Text(currentSkill.category.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if currentSkill.isMastered {
                        Label("Mastered!", systemImage: "checkmark.seal.fill")
                            .font(.subheadline.bold())
                            .foregroundStyle(.green)
                    }
                }
                .padding()

                // Log Practice Button
                Button {
                    showingLogPractice = true
                } label: {
                    Label("Log Practice", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Practice History
                if !currentSkill.practiceLog.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Practice History", systemImage: "clock")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)

                        ForEach(currentSkill.practiceLog.reversed()) { practice in
                            HStack(spacing: 12) {
                                Image(systemName: practice.confidence.icon)
                                    .foregroundStyle(confidenceColor(practice.confidence))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(practice.confidence.rawValue)
                                        .font(.subheadline)
                                    if !practice.note.isEmpty {
                                        Text(practice.note)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }

                                Spacer()

                                Text(practice.date, style: .date)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Notes
                VStack(alignment: .leading, spacing: 8) {
                    Label("Notes", systemImage: "note.text")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)

                    Text(currentSkill.notes.isEmpty ? "No notes yet" : currentSkill.notes)
                        .font(.subheadline)
                        .foregroundStyle(currentSkill.notes.isEmpty ? .tertiary : .primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Skill Detail")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingLogPractice) {
            LogPracticeView(skillID: skill.id, skillName: currentSkill.name)
        }
    }

    private func confidenceColor(_ level: SkillPractice.ConfidenceLevel) -> Color {
        switch level {
        case .learning: return .red
        case .improving: return .orange
        case .comfortable: return .yellow
        case .confident: return .green
        }
    }
}

// MARK: - Log Practice View

struct LogPracticeView: View {
    let skillID: UUID
    let skillName: String
    @EnvironmentObject var trainingStore: TrainingStore
    @Environment(\.dismiss) var dismiss

    @State private var confidence: SkillPractice.ConfidenceLevel = .improving
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Skill") {
                    Text(skillName)
                        .font(.headline)
                }

                Section("How did it go?") {
                    ForEach(SkillPractice.ConfidenceLevel.allCases, id: \.self) { level in
                        Button {
                            confidence = level
                        } label: {
                            HStack {
                                Image(systemName: level.icon)
                                    .foregroundStyle(colorFor(level))
                                Text(level.rawValue)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if confidence == level {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.cyan)
                                }
                            }
                        }
                    }
                }

                Section("Notes (optional)") {
                    TextField("What did you work on?", text: $note, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Log Practice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        trainingStore.logPractice(
                            for: skillID,
                            confidence: confidence,
                            note: note.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }

    private func colorFor(_ level: SkillPractice.ConfidenceLevel) -> Color {
        switch level {
        case .learning: return .red
        case .improving: return .orange
        case .comfortable: return .yellow
        case .confident: return .green
        }
    }
}

// MARK: - Add Custom Skill

struct AddTrainingSkillView: View {
    @EnvironmentObject var trainingStore: TrainingStore
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var category: TrainingSkill.SkillCategory = .buoyancy
    @State private var targetPractices = 5
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Skill Details") {
                    TextField("Skill name", text: $name)

                    Picker("Category", selection: $category) {
                        ForEach(TrainingSkill.SkillCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }

                    Stepper("Target: \(targetPractices) practices", value: $targetPractices, in: 1...50)
                }

                Section("Notes") {
                    TextField("Tips, resources, goals...", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Add Skill")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let skill = TrainingSkill(
                            name: name,
                            category: category,
                            practiceLog: [],
                            targetPractices: targetPractices,
                            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        trainingStore.addSkill(skill)
                        dismiss()
                    }
                    .bold()
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TrainingView()
            .environmentObject(TrainingStore())
    }
}
