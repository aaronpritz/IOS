import SwiftUI

struct WeightCalculatorView: View {
    @State private var bodyWeight: Double = 170  // lbs
    @State private var suitType: SuitType = .shortie3mm
    @State private var waterType: WaterType = .salt
    @State private var tankType: TankMaterial = .aluminum
    @State private var experience: ExperienceLevel = .intermediate

    enum SuitType: String, CaseIterable {
        case swimsuit = "Swimsuit / Rashguard"
        case shortie3mm = "3mm Shortie"
        case full3mm = "3mm Full Suit"
        case full5mm = "5mm Full Suit"
        case full7mm = "7mm Full Suit"
        case drysuit = "Drysuit"

        var weightFactor: Double {
            switch self {
            case .swimsuit: return 0.0
            case .shortie3mm: return 0.03
            case .full3mm: return 0.05
            case .full5mm: return 0.07
            case .full7mm: return 0.10
            case .drysuit: return 0.12
            }
        }
    }

    enum WaterType: String, CaseIterable {
        case salt = "Salt Water"
        case fresh = "Fresh Water"

        var adjustment: Double {
            switch self {
            case .salt: return 0.0
            case .fresh: return -4.0
            }
        }
    }

    enum TankMaterial: String, CaseIterable {
        case aluminum = "Aluminum (AL80)"
        case steel = "Steel (HP100)"

        var adjustment: Double {
            switch self {
            case .aluminum: return 2.0    // AL tanks are buoyant when empty
            case .steel: return -2.0      // Steel tanks are negative
            }
        }
    }

    enum ExperienceLevel: String, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case experienced = "Experienced"

        var adjustment: Double {
            switch self {
            case .beginner: return 2.0
            case .intermediate: return 0.0
            case .experienced: return -2.0
            }
        }
    }

    var estimatedWeight: Double {
        let suitWeight = bodyWeight * suitType.weightFactor
        let total = suitWeight + waterType.adjustment + tankType.adjustment + experience.adjustment
        return max(total, 0)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Disclaimer
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("This is an estimate. Always do a buoyancy check in the water before diving.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Body Weight
                PlannerSection(title: "Body Weight", icon: "figure.stand", color: .cyan) {
                    VStack(alignment: .leading) {
                        Text("\(Int(bodyWeight)) lbs")
                            .font(.title2.bold())
                            .foregroundStyle(.cyan)
                        Slider(value: $bodyWeight, in: 90...300, step: 5)
                            .tint(.cyan)
                    }
                }

                // MARK: - Exposure Suit
                PlannerSection(title: "Exposure Suit", icon: "tshirt.fill", color: .teal) {
                    Picker("Suit", selection: $suitType) {
                        ForEach(SuitType.allCases, id: \.self) { suit in
                            Text(suit.rawValue).tag(suit)
                        }
                    }
                    .pickerStyle(.menu)
                }

                // MARK: - Environment
                PlannerSection(title: "Environment", icon: "water.waves", color: .blue) {
                    VStack(spacing: 12) {
                        Picker("Water", selection: $waterType) {
                            ForEach(WaterType.allCases, id: \.self) { water in
                                Text(water.rawValue).tag(water)
                            }
                        }
                        .pickerStyle(.segmented)

                        Picker("Tank", selection: $tankType) {
                            ForEach(TankMaterial.allCases, id: \.self) { tank in
                                Text(tank.rawValue).tag(tank)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }

                // MARK: - Experience
                PlannerSection(title: "Experience", icon: "person.fill", color: .indigo) {
                    Picker("Level", selection: $experience) {
                        ForEach(ExperienceLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // MARK: - Result
                VStack(spacing: 12) {
                    Text("Estimated Weight")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(Int(estimatedWeight)) lbs")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundStyle(.cyan)

                    Text("(\(String(format: "%.1f", estimatedWeight * 0.4536)) kg)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // Breakdown
                    VStack(alignment: .leading, spacing: 6) {
                        WeightRow(label: "Suit buoyancy", value: bodyWeight * suitType.weightFactor)
                        WeightRow(label: "Water type", value: waterType.adjustment)
                        WeightRow(label: "Tank type", value: tankType.adjustment)
                        WeightRow(label: "Experience adj.", value: experience.adjustment)
                    }
                    .padding(.top, 8)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // MARK: - Tips
                VStack(alignment: .leading, spacing: 8) {
                    Label("Buoyancy Check Tips", systemImage: "lightbulb")
                        .font(.subheadline.bold())

                    VStack(alignment: .leading, spacing: 4) {
                        Text("1. At the surface with a full tank and BCD deflated, you should float at eye level")
                        Text("2. When you inhale, you should rise slightly; exhale and sink slightly")
                        Text("3. At the end of a dive with ~500 PSI, you should be able to hold a 15ft safety stop without air in your BCD")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Weight Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WeightRow: View {
    let label: String
    let value: Double

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value >= 0 ? "+\(String(format: "%.1f", value)) lbs" : "\(String(format: "%.1f", value)) lbs")
                .font(.caption.bold())
                .foregroundStyle(value >= 0 ? .primary : .green)
        }
    }
}

#Preview {
    NavigationStack {
        WeightCalculatorView()
            .environmentObject(UnitSettings())
    }
}
