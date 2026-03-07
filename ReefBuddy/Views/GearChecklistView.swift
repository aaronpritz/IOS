import SwiftUI

struct GearItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: String
    var isPacked: Bool = false
}

class GearStore: ObservableObject {
    @Published var items: [GearItem] = []

    private let saveKey = "ReefBuddyGearList"

    init() {
        loadItems()
        if items.isEmpty {
            items = GearStore.defaultItems
        }
    }

    func toggle(_ item: GearItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isPacked.toggle()
            saveItems()
        }
    }

    func addItem(name: String, category: String) {
        items.append(GearItem(name: name, category: category))
        saveItems()
    }

    func deleteItem(_ item: GearItem) {
        items.removeAll { $0.id == item.id }
        saveItems()
    }

    func resetAll() {
        for i in items.indices {
            items[i].isPacked = false
        }
        saveItems()
    }

    var categories: [String] {
        let cats = Set(items.map(\.category))
        let order = ["Essentials", "Exposure", "Accessories", "Safety", "Personal"]
        return order.filter { cats.contains($0) } + cats.subtracting(order).sorted()
    }

    func items(for category: String) -> [GearItem] {
        items.filter { $0.category == category }
    }

    var packedCount: Int {
        items.filter(\.isPacked).count
    }

    var progress: Double {
        guard !items.isEmpty else { return 0 }
        return Double(packedCount) / Double(items.count)
    }

    private func saveItems() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([GearItem].self, from: data) {
            items = decoded
        }
    }

    static let defaultItems: [GearItem] = [
        // Essentials
        GearItem(name: "Mask", category: "Essentials"),
        GearItem(name: "Fins", category: "Essentials"),
        GearItem(name: "BCD", category: "Essentials"),
        GearItem(name: "Regulator + Octopus", category: "Essentials"),
        GearItem(name: "Dive Computer", category: "Essentials"),
        GearItem(name: "Weight Belt / Integrated Weights", category: "Essentials"),
        GearItem(name: "Tank (or rental confirmation)", category: "Essentials"),

        // Exposure
        GearItem(name: "Wetsuit", category: "Exposure"),
        GearItem(name: "Booties", category: "Exposure"),
        GearItem(name: "Gloves", category: "Exposure"),
        GearItem(name: "Hood", category: "Exposure"),
        GearItem(name: "Rashguard", category: "Exposure"),

        // Accessories
        GearItem(name: "Dive Light", category: "Accessories"),
        GearItem(name: "Dive Knife / Shears", category: "Accessories"),
        GearItem(name: "Underwater Camera", category: "Accessories"),
        GearItem(name: "Defogger / Anti-Fog", category: "Accessories"),
        GearItem(name: "Dry Bag", category: "Accessories"),
        GearItem(name: "Mesh Gear Bag", category: "Accessories"),

        // Safety
        GearItem(name: "SMB (Surface Marker Buoy)", category: "Safety"),
        GearItem(name: "Reel / Spool", category: "Safety"),
        GearItem(name: "Whistle", category: "Safety"),
        GearItem(name: "Backup Light", category: "Safety"),

        // Personal
        GearItem(name: "Certification Card", category: "Personal"),
        GearItem(name: "Sunscreen (reef-safe)", category: "Personal"),
        GearItem(name: "Towel", category: "Personal"),
        GearItem(name: "Water Bottle", category: "Personal"),
        GearItem(name: "Snacks", category: "Personal"),
    ]
}

struct GearChecklistView: View {
    @StateObject private var gearStore = GearStore()
    @State private var showingAddItem = false
    @State private var newItemName = ""
    @State private var newItemCategory = "Accessories"

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Progress
                VStack(spacing: 8) {
                    HStack {
                        Text("\(gearStore.packedCount) of \(gearStore.items.count) packed")
                            .font(.subheadline.bold())
                        Spacer()
                        if gearStore.packedCount == gearStore.items.count {
                            Label("Ready to Dive!", systemImage: "checkmark.seal.fill")
                                .font(.subheadline.bold())
                                .foregroundStyle(.green)
                        }
                    }

                    ProgressView(value: gearStore.progress)
                        .tint(gearStore.packedCount == gearStore.items.count ? .green : .cyan)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Gear by Category
                ForEach(gearStore.categories, id: \.self) { category in
                    VStack(alignment: .leading, spacing: 8) {
                        let categoryItems = gearStore.items(for: category)
                        let packedInCategory = categoryItems.filter(\.isPacked).count

                        HStack {
                            Text(category)
                                .font(.headline)
                            Spacer()
                            Text("\(packedInCategory)/\(categoryItems.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 4)

                        ForEach(categoryItems) { item in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    gearStore.toggle(item)
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: item.isPacked ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundStyle(item.isPacked ? .green : .secondary)

                                    Text(item.name)
                                        .font(.subheadline)
                                        .strikethrough(item.isPacked)
                                        .foregroundStyle(item.isPacked ? .secondary : .primary)

                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // MARK: - Actions
                HStack(spacing: 12) {
                    Button {
                        showingAddItem = true
                    } label: {
                        Label("Add Item", systemImage: "plus.circle")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.cyan)

                    Button {
                        withAnimation {
                            gearStore.resetAll()
                        }
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.secondary)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("Gear Checklist")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Add Gear Item", isPresented: $showingAddItem) {
            TextField("Item name", text: $newItemName)
            Button("Add") {
                if !newItemName.isEmpty {
                    gearStore.addItem(name: newItemName, category: newItemCategory)
                    newItemName = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newItemName = ""
            }
        } message: {
            Text("Enter the name of the gear item to add.")
        }
    }
}

#Preview {
    NavigationStack {
        GearChecklistView()
    }
}
