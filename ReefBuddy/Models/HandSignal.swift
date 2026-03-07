import Foundation

struct HandSignal: Identifiable {
    let id = UUID()
    let name: String
    let icon: String          // SF Symbol name
    let description: String   // How to make the signal
    let meaning: String       // When to use it
    let category: SignalCategory

    enum SignalCategory: String, CaseIterable {
        case essential = "Essential"
        case direction = "Direction"
        case status = "Status"
        case marine = "Marine Life"
    }

    static let allSignals: [HandSignal] = [
        // Essential
        HandSignal(
            name: "OK",
            icon: "hand.thumbsup.fill",
            description: "Make an 'O' shape with thumb and index finger, extend other three fingers up.",
            meaning: "I'm OK / Are you OK? The most important signal in diving.",
            category: .essential
        ),
        HandSignal(
            name: "Not OK / Problem",
            icon: "hand.raised.fill",
            description: "Extend hand flat, palm down, and rock it side to side (like a wobbling plane).",
            meaning: "Something is wrong. Follow up by pointing to the problem.",
            category: .essential
        ),
        HandSignal(
            name: "Up / Ascend",
            icon: "arrow.up",
            description: "Make a fist with thumb pointing up.",
            meaning: "Let's go up / End the dive. NOT 'OK' — that's a common mistake!",
            category: .essential
        ),
        HandSignal(
            name: "Down / Descend",
            icon: "arrow.down",
            description: "Make a fist with thumb pointing down.",
            meaning: "Let's go deeper / Begin descent.",
            category: .essential
        ),
        HandSignal(
            name: "Stop",
            icon: "hand.raised.slash.fill",
            description: "Hold hand out flat, palm facing your buddy.",
            meaning: "Stop. Hold position. Wait.",
            category: .essential
        ),
        HandSignal(
            name: "Out of Air",
            icon: "exclamationmark.triangle.fill",
            description: "Make a slashing motion across your throat with a flat hand.",
            meaning: "EMERGENCY: I have no air. Need to share air immediately.",
            category: .essential
        ),
        HandSignal(
            name: "Low on Air",
            icon: "gauge.with.dots.needle.33percent",
            description: "Make a fist and place it against your chest.",
            meaning: "I'm running low on air. Time to start heading back/up.",
            category: .essential
        ),
        HandSignal(
            name: "Safety Stop",
            icon: "clock.badge.checkmark.fill",
            description: "Hold up three fingers (for 3 minutes) and show five fingers (for 5 meters/15 feet).",
            meaning: "Time for a safety stop at 15 ft / 5m for 3 minutes.",
            category: .essential
        ),

        // Direction
        HandSignal(
            name: "Go That Way",
            icon: "arrow.right",
            description: "Point in the direction of travel with your whole hand flat.",
            meaning: "Let's swim in this direction.",
            category: .direction
        ),
        HandSignal(
            name: "Turn Around",
            icon: "arrow.uturn.left",
            description: "Extend index finger and make a circular motion.",
            meaning: "Turn around / Head back the way we came.",
            category: .direction
        ),
        HandSignal(
            name: "Stay Together",
            icon: "person.2.fill",
            description: "Point two index fingers together side by side.",
            meaning: "Stay close together. Don't separate.",
            category: .direction
        ),
        HandSignal(
            name: "Level Off",
            icon: "arrow.left.and.right",
            description: "Hold hand flat, palm down, and move it horizontally.",
            meaning: "Stay at this depth. Don't go deeper or shallower.",
            category: .direction
        ),

        // Status
        HandSignal(
            name: "How Much Air?",
            icon: "gauge.with.dots.needle.67percent",
            description: "Tap two fingers on your open palm (like tapping a gauge).",
            meaning: "What's your tank pressure? Respond with number signals.",
            category: .status
        ),
        HandSignal(
            name: "Cold",
            icon: "thermometer.snowflake",
            description: "Cross your arms and rub your upper arms (like shivering).",
            meaning: "I'm cold. May want to end the dive.",
            category: .status
        ),
        HandSignal(
            name: "Ear Problem",
            icon: "ear.fill",
            description: "Point to your ear and then make the 'not OK' signal.",
            meaning: "I can't equalize. Need to ascend a bit and try again.",
            category: .status
        ),
        HandSignal(
            name: "I Don't Understand",
            icon: "questionmark.circle.fill",
            description: "Hold both palms up and shrug shoulders.",
            meaning: "I don't understand your signal. Please repeat or try another way.",
            category: .status
        ),

        // Marine Life
        HandSignal(
            name: "Shark",
            icon: "triangle.fill",
            description: "Place hand flat on top of your head like a dorsal fin.",
            meaning: "I see a shark! (Usually exciting, not dangerous)",
            category: .marine
        ),
        HandSignal(
            name: "Turtle",
            icon: "tortoise.fill",
            description: "Place one hand on top of the other and wiggle your thumbs.",
            meaning: "I see a sea turtle!",
            category: .marine
        ),
        HandSignal(
            name: "Ray",
            icon: "bird.fill",
            description: "Hold arms out to sides and make a gentle flapping motion.",
            meaning: "I see a ray (manta ray or stingray)!",
            category: .marine
        ),
        HandSignal(
            name: "Look",
            icon: "eye.fill",
            description: "Point to your eyes with two fingers, then point toward what to look at.",
            meaning: "Look over there! I see something interesting.",
            category: .marine
        )
    ]
}
