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

                    NavigationLink(destination: GearChecklistView()) {
                        ReferenceCard(
                            icon: "checklist",
                            title: "Gear Checklist",
                            subtitle: "Pack your gear — don't forget anything",
                            color: .orange
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
