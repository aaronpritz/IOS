import SwiftUI

/// Manages saving and loading gear items
class GearStore: ObservableObject {
    @Published var items: [GearItem] = []

    private let saveKey = "ReefBuddyGear"

    init() {
        loadItems()
    }

    var activeItems: [GearItem] {
        items.filter { !$0.isRetired }
    }

    var retiredItems: [GearItem] {
        items.filter { $0.isRetired }
    }

    var itemsNeedingService: [GearItem] {
        activeItems.filter { $0.isServiceOverdue || $0.isServiceDueSoon }
    }

    func addItem(_ item: GearItem) {
        items.insert(item, at: 0)
        saveItems()
    }

    func updateItem(_ item: GearItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveItems()
        }
    }

    func deleteItem(_ item: GearItem) {
        items.removeAll { $0.id == item.id }
        saveItems()
    }

    func deleteItem(at offsets: IndexSet, from list: [GearItem]) {
        for index in offsets {
            let item = list[index]
            items.removeAll { $0.id == item.id }
        }
        saveItems()
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
}
