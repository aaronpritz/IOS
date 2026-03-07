import Foundation

/// A marine species that can be spotted while diving
struct MarineSpecies: Identifiable, Codable, Hashable {
    let id: String          // unique key e.g. "green-sea-turtle"
    let commonName: String
    let scientificName: String
    let category: Category
    let icon: String        // SF Symbol name
    let description: String

    enum Category: String, Codable, CaseIterable, Hashable {
        case fish = "Fish"
        case shark = "Sharks & Rays"
        case mammal = "Marine Mammals"
        case turtle = "Sea Turtles"
        case invertebrate = "Invertebrates"
        case coral = "Coral & Anemones"
        case cephalopod = "Cephalopods"
        case crustacean = "Crustaceans"

        var icon: String {
            switch self {
            case .fish: return "fish.fill"
            case .shark: return "fish.fill"
            case .mammal: return "seal.fill"
            case .turtle: return "tortoise.fill"
            case .invertebrate: return "sparkle"
            case .coral: return "leaf.fill"
            case .cephalopod: return "hurricane"
            case .crustacean: return "ladybug.fill"
            }
        }
    }

    static let allSpecies: [MarineSpecies] = [
        // Fish
        MarineSpecies(id: "clownfish", commonName: "Clownfish", scientificName: "Amphiprioninae", category: .fish, icon: "fish.fill", description: "Colorful reef fish living in symbiosis with sea anemones."),
        MarineSpecies(id: "blue-tang", commonName: "Blue Tang", scientificName: "Paracanthurus hepatus", category: .fish, icon: "fish.fill", description: "Bright blue surgeonfish common on Indo-Pacific reefs."),
        MarineSpecies(id: "moorish-idol", commonName: "Moorish Idol", scientificName: "Zanclus cornutus", category: .fish, icon: "fish.fill", description: "Striking black, white, and yellow reef fish."),
        MarineSpecies(id: "lionfish", commonName: "Lionfish", scientificName: "Pterois", category: .fish, icon: "fish.fill", description: "Venomous fish with dramatic fan-like fins. Invasive in some regions."),
        MarineSpecies(id: "parrotfish", commonName: "Parrotfish", scientificName: "Scaridae", category: .fish, icon: "fish.fill", description: "Colorful herbivores that create sand by eating coral."),
        MarineSpecies(id: "grouper", commonName: "Grouper", scientificName: "Epinephelinae", category: .fish, icon: "fish.fill", description: "Large, heavy-bodied reef predators found worldwide."),
        MarineSpecies(id: "barracuda", commonName: "Barracuda", scientificName: "Sphyraena", category: .fish, icon: "fish.fill", description: "Sleek, powerful predator often seen in open water near reefs."),
        MarineSpecies(id: "moray-eel", commonName: "Moray Eel", scientificName: "Muraenidae", category: .fish, icon: "fish.fill", description: "Snake-like fish found hiding in reef crevices."),
        MarineSpecies(id: "angelfish", commonName: "Angelfish", scientificName: "Pomacanthidae", category: .fish, icon: "fish.fill", description: "Beautifully patterned reef fish in many color varieties."),
        MarineSpecies(id: "butterflyfish", commonName: "Butterflyfish", scientificName: "Chaetodontidae", category: .fish, icon: "fish.fill", description: "Small, colorful fish often seen in mated pairs on reefs."),
        MarineSpecies(id: "trumpetfish", commonName: "Trumpetfish", scientificName: "Aulostomus", category: .fish, icon: "fish.fill", description: "Long, slender ambush predator that hovers vertically."),
        MarineSpecies(id: "frogfish", commonName: "Frogfish", scientificName: "Antennariidae", category: .fish, icon: "fish.fill", description: "Master of camouflage with a lure to attract prey."),
        MarineSpecies(id: "seahorse", commonName: "Seahorse", scientificName: "Hippocampus", category: .fish, icon: "fish.fill", description: "Tiny, upright-swimming fish that clings to corals and seagrass."),
        MarineSpecies(id: "pufferfish", commonName: "Pufferfish", scientificName: "Tetraodontidae", category: .fish, icon: "fish.fill", description: "Can inflate to several times its size when threatened."),
        MarineSpecies(id: "wrasse", commonName: "Napoleon Wrasse", scientificName: "Cheilinus undulatus", category: .fish, icon: "fish.fill", description: "Massive, friendly reef fish. Endangered species."),

        // Sharks & Rays
        MarineSpecies(id: "whale-shark", commonName: "Whale Shark", scientificName: "Rhincodon typus", category: .shark, icon: "fish.fill", description: "The largest fish in the sea. Gentle filter feeder."),
        MarineSpecies(id: "reef-shark", commonName: "Reef Shark", scientificName: "Carcharhinus perezii", category: .shark, icon: "fish.fill", description: "Common shark patrolling coral reef drop-offs."),
        MarineSpecies(id: "hammerhead", commonName: "Hammerhead Shark", scientificName: "Sphyrnidae", category: .shark, icon: "fish.fill", description: "Distinctive hammer-shaped head. Often seen in schools."),
        MarineSpecies(id: "nurse-shark", commonName: "Nurse Shark", scientificName: "Ginglymostoma cirratum", category: .shark, icon: "fish.fill", description: "Docile bottom-dwelling shark often found resting under ledges."),
        MarineSpecies(id: "manta-ray", commonName: "Manta Ray", scientificName: "Mobula birostris", category: .shark, icon: "fish.fill", description: "Graceful giant with wingspans up to 7 meters."),
        MarineSpecies(id: "eagle-ray", commonName: "Spotted Eagle Ray", scientificName: "Aetobatus narinari", category: .shark, icon: "fish.fill", description: "Elegant ray with distinctive spotted pattern."),
        MarineSpecies(id: "stingray", commonName: "Stingray", scientificName: "Dasyatis", category: .shark, icon: "fish.fill", description: "Flat-bodied ray often found resting on sandy bottoms."),
        MarineSpecies(id: "white-tip-shark", commonName: "White Tip Reef Shark", scientificName: "Triaenodon obesus", category: .shark, icon: "fish.fill", description: "Slender reef shark with white-tipped fins. Nocturnal hunter."),

        // Marine Mammals
        MarineSpecies(id: "dolphin", commonName: "Bottlenose Dolphin", scientificName: "Tursiops truncatus", category: .mammal, icon: "seal.fill", description: "Intelligent, playful marine mammal often seen near dive boats."),
        MarineSpecies(id: "humpback-whale", commonName: "Humpback Whale", scientificName: "Megaptera novaeangliae", category: .mammal, icon: "seal.fill", description: "Massive whale known for breaching and singing."),
        MarineSpecies(id: "sea-lion", commonName: "Sea Lion", scientificName: "Otariidae", category: .mammal, icon: "seal.fill", description: "Playful pinniped that loves interacting with divers."),
        MarineSpecies(id: "manatee", commonName: "Manatee", scientificName: "Trichechus", category: .mammal, icon: "seal.fill", description: "Gentle herbivore found in warm, shallow waters."),

        // Sea Turtles
        MarineSpecies(id: "green-turtle", commonName: "Green Sea Turtle", scientificName: "Chelonia mydas", category: .turtle, icon: "tortoise.fill", description: "Large herbivorous turtle common on tropical reefs."),
        MarineSpecies(id: "hawksbill-turtle", commonName: "Hawksbill Turtle", scientificName: "Eretmochelys imbricata", category: .turtle, icon: "tortoise.fill", description: "Critically endangered turtle with beautiful shell pattern."),
        MarineSpecies(id: "loggerhead-turtle", commonName: "Loggerhead Turtle", scientificName: "Caretta caretta", category: .turtle, icon: "tortoise.fill", description: "Large-headed turtle found in temperate and tropical waters."),
        MarineSpecies(id: "leatherback-turtle", commonName: "Leatherback Turtle", scientificName: "Dermochelys coriacea", category: .turtle, icon: "tortoise.fill", description: "The largest sea turtle, can dive to extreme depths."),

        // Invertebrates
        MarineSpecies(id: "jellyfish", commonName: "Moon Jellyfish", scientificName: "Aurelia aurita", category: .invertebrate, icon: "sparkle", description: "Translucent jellyfish with mild sting."),
        MarineSpecies(id: "sea-star", commonName: "Sea Star", scientificName: "Asteroidea", category: .invertebrate, icon: "sparkle", description: "Five-armed echinoderms found on reefs and sandy bottoms."),
        MarineSpecies(id: "sea-urchin", commonName: "Sea Urchin", scientificName: "Echinoidea", category: .invertebrate, icon: "sparkle", description: "Spiny echinoderms — watch where you put your hands!"),
        MarineSpecies(id: "nudibranch", commonName: "Nudibranch", scientificName: "Nudibranchia", category: .invertebrate, icon: "sparkle", description: "Colorful sea slugs beloved by macro photographers."),
        MarineSpecies(id: "sea-cucumber", commonName: "Sea Cucumber", scientificName: "Holothuroidea", category: .invertebrate, icon: "sparkle", description: "Slow-moving bottom dweller that recycles nutrients."),
        MarineSpecies(id: "giant-clam", commonName: "Giant Clam", scientificName: "Tridacna gigas", category: .invertebrate, icon: "sparkle", description: "The largest living bivalve, with vivid mantle colors."),

        // Coral & Anemones
        MarineSpecies(id: "brain-coral", commonName: "Brain Coral", scientificName: "Diploria", category: .coral, icon: "leaf.fill", description: "Massive coral with brain-like grooved surface."),
        MarineSpecies(id: "staghorn-coral", commonName: "Staghorn Coral", scientificName: "Acropora cervicornis", category: .coral, icon: "leaf.fill", description: "Fast-growing branching coral critical for reef structure."),
        MarineSpecies(id: "sea-anemone", commonName: "Sea Anemone", scientificName: "Actiniaria", category: .coral, icon: "leaf.fill", description: "Flower-like animal that hosts clownfish."),
        MarineSpecies(id: "sea-fan", commonName: "Sea Fan", scientificName: "Gorgoniidae", category: .coral, icon: "leaf.fill", description: "Flat, fan-shaped soft coral that sways in the current."),
        MarineSpecies(id: "fire-coral", commonName: "Fire Coral", scientificName: "Millepora", category: .coral, icon: "leaf.fill", description: "Not true coral — delivers a painful sting on contact."),

        // Cephalopods
        MarineSpecies(id: "octopus", commonName: "Octopus", scientificName: "Octopoda", category: .cephalopod, icon: "hurricane", description: "Highly intelligent, masters of camouflage and escape."),
        MarineSpecies(id: "cuttlefish", commonName: "Cuttlefish", scientificName: "Sepiida", category: .cephalopod, icon: "hurricane", description: "Can change color and texture in milliseconds."),
        MarineSpecies(id: "squid", commonName: "Reef Squid", scientificName: "Sepioteuthis", category: .cephalopod, icon: "hurricane", description: "Fast-moving cephalopod often seen in small groups."),
        MarineSpecies(id: "nautilus", commonName: "Nautilus", scientificName: "Nautilidae", category: .cephalopod, icon: "hurricane", description: "Ancient living fossil with a beautiful spiral shell."),

        // Crustaceans
        MarineSpecies(id: "lobster", commonName: "Spiny Lobster", scientificName: "Palinuridae", category: .crustacean, icon: "ladybug.fill", description: "Nocturnal crustacean often found hiding in reef crevices."),
        MarineSpecies(id: "hermit-crab", commonName: "Hermit Crab", scientificName: "Paguroidea", category: .crustacean, icon: "ladybug.fill", description: "Carries a borrowed shell for protection."),
        MarineSpecies(id: "cleaner-shrimp", commonName: "Cleaner Shrimp", scientificName: "Lysmata amboinensis", category: .crustacean, icon: "ladybug.fill", description: "Sets up cleaning stations where fish line up for parasite removal."),
        MarineSpecies(id: "mantis-shrimp", commonName: "Mantis Shrimp", scientificName: "Stomatopoda", category: .crustacean, icon: "ladybug.fill", description: "Powerful punch and incredible color vision."),
    ]

    /// Group species by category
    static var byCategory: [(category: Category, species: [MarineSpecies])] {
        Category.allCases.compactMap { cat in
            let species = allSpecies.filter { $0.category == cat }
            return species.isEmpty ? nil : (cat, species)
        }
    }
}

/// A sighting of a species during a dive
struct SpeciesSighting: Identifiable, Codable, Hashable {
    var id = UUID()
    let speciesID: String
    var count: SightingCount
    var note: String?

    enum SightingCount: String, Codable, CaseIterable, Hashable {
        case one = "1"
        case few = "2-5"
        case several = "6-20"
        case many = "20+"
        case school = "School"
    }

    /// Look up the species from the database
    var species: MarineSpecies? {
        MarineSpecies.allSpecies.first { $0.id == speciesID }
    }
}
