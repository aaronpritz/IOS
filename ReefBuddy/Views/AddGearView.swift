import SwiftUI

struct AddGearView: View {
    @EnvironmentObject var gearStore: GearStore
    @Environment(\.dismiss) var dismiss

    var editingItem: GearItem? = nil
    var isEditing: Bool { editingItem != nil }

    @State private var name = ""
    @State private var category: GearItem.Category = .regulator
    @State private var brand = ""
    @State private var model = ""
    @State private var serialNumber = ""
    @State private var hasPurchaseDate = false
    @State private var purchaseDate = Date()
    @State private var hasLastService = false
    @State private var lastServiceDate = Date()
    @State private var hasServiceInterval = false
    @State private var serviceIntervalMonths = 12
    @State private var totalDives = 0
    @State private var notes = ""
    @State private var isRetired = false

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Basic Info
                Section {
                    TextField("Name (e.g. Primary Regulator)", text: $name)
                    Picker("Category", selection: $category) {
                        ForEach(GearItem.Category.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                    TextField("Brand", text: $brand)
                    TextField("Model", text: $model)
                } header: {
                    Label("Equipment", systemImage: "bag.fill")
                }

                // MARK: - Details
                Section {
                    TextField("Serial Number", text: $serialNumber)
                    Stepper("Total Dives: \(totalDives)", value: $totalDives, in: 0...9999)
                } header: {
                    Label("Details", systemImage: "info.circle")
                }

                // MARK: - Purchase Date
                Section {
                    Toggle("Track Purchase Date", isOn: $hasPurchaseDate)
                    if hasPurchaseDate {
                        DatePicker("Purchased", selection: $purchaseDate, displayedComponents: .date)
                    }
                } header: {
                    Label("Purchase", systemImage: "cart")
                }

                // MARK: - Service
                Section {
                    Toggle("Track Service", isOn: $hasServiceInterval)
                    if hasServiceInterval {
                        Stepper("Interval: \(serviceIntervalMonths) months", value: $serviceIntervalMonths, in: 1...60)

                        Toggle("Has Been Serviced", isOn: $hasLastService)
                        if hasLastService {
                            DatePicker("Last Service", selection: $lastServiceDate, displayedComponents: .date)
                        }
                    }
                } header: {
                    Label("Service Schedule", systemImage: "wrench.and.screwdriver")
                }

                // MARK: - Notes
                Section {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Label("Notes", systemImage: "note.text")
                }

                // MARK: - Status
                if isEditing {
                    Section {
                        Toggle("Retired", isOn: $isRetired)
                    } header: {
                        Label("Status", systemImage: "archivebox")
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Gear" : "Add Gear")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Update" : "Save") {
                        saveItem()
                    }
                    .disabled(name.isEmpty)
                    .bold()
                }
            }
            .onAppear {
                if let item = editingItem {
                    name = item.name
                    category = item.category
                    brand = item.brand
                    model = item.model
                    serialNumber = item.serialNumber
                    totalDives = item.totalDives
                    notes = item.notes
                    isRetired = item.isRetired

                    if let date = item.purchaseDate {
                        hasPurchaseDate = true
                        purchaseDate = date
                    }
                    if let date = item.lastServiceDate {
                        hasLastService = true
                        lastServiceDate = date
                    }
                    if let months = item.serviceIntervalMonths {
                        hasServiceInterval = true
                        serviceIntervalMonths = months
                    }
                }
            }
        }
    }

    private func saveItem() {
        let item = GearItem(
            id: editingItem?.id ?? UUID(),
            name: name,
            category: category,
            brand: brand,
            model: model,
            serialNumber: serialNumber,
            purchaseDate: hasPurchaseDate ? purchaseDate : nil,
            lastServiceDate: hasServiceInterval && hasLastService ? lastServiceDate : nil,
            serviceIntervalMonths: hasServiceInterval ? serviceIntervalMonths : nil,
            totalDives: totalDives,
            notes: notes,
            isRetired: isRetired
        )

        if isEditing {
            gearStore.updateItem(item)
        } else {
            gearStore.addItem(item)
        }
        dismiss()
    }
}

#Preview {
    AddGearView()
        .environmentObject(GearStore())
}
