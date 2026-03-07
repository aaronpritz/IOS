import SwiftUI

struct PlanView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    NavigationLink(destination: DepthPlannerView()) {
                        ReferenceCard(
                            icon: "chart.line.downtrend.xyaxis",
                            title: "Dive Planner",
                            subtitle: "Plan depth, time, and surface intervals",
                            color: .cyan
                        )
                    }

                    NavigationLink(destination: GasCalculatorView()) {
                        ReferenceCard(
                            icon: "gauge.with.dots.needle.67percent",
                            title: "Gas Calculator",
                            subtitle: "Air consumption and tank planning",
                            color: .teal
                        )
                    }

                    NavigationLink(destination: NitroxCalculatorView()) {
                        ReferenceCard(
                            icon: "aqi.medium",
                            title: "Nitrox Calculator",
                            subtitle: "MOD, EAD, and ppO\u{2082} for enriched air",
                            color: .green
                        )
                    }

                    NavigationLink(destination: WeightCalculatorView()) {
                        ReferenceCard(
                            icon: "scalemass",
                            title: "Weight Calculator",
                            subtitle: "Estimate your dive weight needs",
                            color: .indigo
                        )
                    }

                    NavigationLink(destination: GearChecklistView()) {
                        ReferenceCard(
                            icon: "checklist",
                            title: "Gear Checklist",
                            subtitle: "Pack your gear — don't forget anything",
                            color: .orange
                        )
                    }

                    NavigationLink(destination: PreDiveChecklistView()) {
                        ReferenceCard(
                            icon: "checkmark.shield",
                            title: "Pre-Dive Safety Check",
                            subtitle: "BWRAF buddy check + emergency prep",
                            color: .red
                        )
                    }

                    NavigationLink(destination: DivePlanBuilderView()) {
                        ReferenceCard(
                            icon: "doc.text.magnifyingglass",
                            title: "Dive Plan Builder",
                            subtitle: "Build and share a complete dive plan",
                            color: .purple
                        )
                    }

                    NavigationLink(destination: TrainingView()) {
                        ReferenceCard(
                            icon: "figure.water.fitness",
                            title: "Skills Tracker",
                            subtitle: "Track dive skills practice and progress",
                            color: .mint
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Plan")
        }
    }
}

#Preview {
    PlanView()
        .environmentObject(UnitSettings())
}
