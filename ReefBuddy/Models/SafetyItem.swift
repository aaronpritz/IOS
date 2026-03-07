import Foundation

struct SafetyChecklist: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let items: [SafetyItem]
}

struct SafetyItem: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
}

extension SafetyChecklist {
    /// BWRAF pre-dive buddy check
    static let buddyCheck = SafetyChecklist(
        title: "Pre-Dive Buddy Check (BWRAF)",
        icon: "person.2.circle.fill",
        items: [
            SafetyItem(
                title: "B — BCD / Buoyancy",
                detail: "Check inflator hose is connected. Test inflate and deflate buttons. Check all dump valves work. Make sure oral inflate works too."
            ),
            SafetyItem(
                title: "W — Weights",
                detail: "Check weight belt or integrated weight pockets are secure. Know how to release your buddy's weights in an emergency. Confirm right-hand release."
            ),
            SafetyItem(
                title: "R — Releases",
                detail: "Check all clips, buckles, and releases on the BCD. Make sure tank band is tight. Check chest strap and waist buckle."
            ),
            SafetyItem(
                title: "A — Air",
                detail: "Turn on air fully, then back a quarter turn. Breathe from primary and alternate air source. Check SPG reads full. Confirm no leaks."
            ),
            SafetyItem(
                title: "F — Final Check",
                detail: "Mask clean and on. Fins on. Computer or gauges working. No dangling equipment. Agree on entry method and dive plan."
            )
        ]
    )

    /// Pre-dive gear checklist
    static let gearChecklist = SafetyChecklist(
        title: "Gear Packing Checklist",
        icon: "bag.fill",
        items: [
            SafetyItem(title: "Mask", detail: "Check for cracks, strap condition. Apply anti-fog."),
            SafetyItem(title: "Fins & Booties", detail: "Check straps and buckles. Ensure proper fit."),
            SafetyItem(title: "Wetsuit / Rashguard", detail: "Appropriate thickness for water temperature."),
            SafetyItem(title: "BCD", detail: "Inspect inflator, dump valves, and bladder for leaks."),
            SafetyItem(title: "Regulator Set", detail: "Primary, alternate, SPG, and low-pressure inflator hose."),
            SafetyItem(title: "Dive Computer / Watch", detail: "Battery charged. Settings correct. Freshwater/saltwater mode set."),
            SafetyItem(title: "Weight System", detail: "Correct amount of weight for your setup."),
            SafetyItem(title: "SMB & Reel", detail: "Surface marker buoy for safe ascent and surface visibility."),
            SafetyItem(title: "Dive Light", detail: "Battery charged. Backup light for wreck or night dives."),
            SafetyItem(title: "Logbook / App", detail: "Record your dives! (That's what ReefBuddy is for)")
        ]
    )

    /// Emergency procedures
    static let emergencyProcedures = SafetyChecklist(
        title: "Emergency Procedures",
        icon: "cross.circle.fill",
        items: [
            SafetyItem(
                title: "Out of Air",
                detail: "Signal buddy. Use buddy's alternate air source. Ascend together slowly. If alone, perform controlled emergency swimming ascent (CESA) — exhale continuously while ascending."
            ),
            SafetyItem(
                title: "Lost Buddy",
                detail: "Search for 1 minute at current depth. Look for bubbles. If not found, ascend slowly to the surface and reunite topside."
            ),
            SafetyItem(
                title: "Uncontrolled Ascent",
                detail: "Flare body to slow ascent. Dump air from BCD. Exhale continuously. If you reach the surface, stay there — do not re-descend. Monitor for DCS symptoms."
            ),
            SafetyItem(
                title: "Cramp",
                detail: "Stop. Signal buddy. Grab the tip of the cramping fin and pull toward you while straightening your leg. Massage the muscle. Rest before continuing."
            ),
            SafetyItem(
                title: "Free-Flowing Regulator",
                detail: "Don't remove from mouth. Turn head to side to breathe from the airflow. Signal buddy. Begin a controlled ascent. You'll still get air, just a lot of it."
            ),
            SafetyItem(
                title: "DCS Symptoms",
                detail: "Signs: joint pain, tingling, dizziness, rash, extreme fatigue. Give 100% oxygen. Keep diver lying down. Call emergency services and DAN (Divers Alert Network). Do not re-enter water."
            )
        ]
    )

    static let allChecklists: [SafetyChecklist] = [
        .buddyCheck,
        .gearChecklist,
        .emergencyProcedures
    ]
}
