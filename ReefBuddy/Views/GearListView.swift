import SwiftUI

struct GearListView: View {
    @EnvironmentObject var gearStore: GearStore
    @State private var showingAddGear = false
    @State private var showRetired = false

    var body: some View {
        List {
            // Service alerts
            if !gearStore.itemsNeedingService.isEmpty {
                Section {
                    ForEach(gearStore.itemsNeedingService) { item in
                        NavigationLink(destination: GearDetailView(item: item)) {
                            HStack(spacing: 12) {
                                Image(systemName: item.isServiceOverdue ? "exclamationmark.triangle.fill" : "clock.badge.exclamationmark")
                                    .foregroundStyle(item.isServiceOverdue ? .red : .orange)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.subheadline.bold())
                                    Text(item.serviceStatusText)
                                        .font(.caption)
                                        .foregroundStyle(item.isServiceOverdue ? .red : .orange)
                                }
                            }
                        }
                    }
                } header: {
                    Label("Service Alerts", systemImage: "wrench.and.screwdriver")
                }
            }

            // Active gear by category
            let grouped = Dictionary(grouping: gearStore.activeItems, by: \.category)
            let sortedCategories = GearItem.Category.allCases.filter { grouped[$0] != nil }

            ForEach(sortedCategories, id: \.self) { category in
                Section {
                    ForEach(grouped[category] ?? []) { item in
                        NavigationLink(destination: GearDetailView(item: item)) {
                            GearRowView(item: item)
                        }
                    }
                    .onDelete { offsets in
                        gearStore.deleteItem(at: offsets, from: grouped[category] ?? [])
                    }
                } header: {
                    Label(category.rawValue, systemImage: category.icon)
                }
            }

            // Retired gear
            if !gearStore.retiredItems.isEmpty {
                Section {
                    DisclosureGroup("Retired Equipment (\(gearStore.retiredItems.count))", isExpanded: $showRetired) {
                        ForEach(gearStore.retiredItems) { item in
                            NavigationLink(destination: GearDetailView(item: item)) {
                                GearRowView(item: item)
                                    .opacity(0.6)
                            }
                        }
                        .onDelete { offsets in
                            gearStore.deleteItem(at: offsets, from: gearStore.retiredItems)
                        }
                    }
                }
            }

            if gearStore.items.isEmpty {
                Section {
                    ContentUnavailableView {
                        Label("No Gear", systemImage: "bag")
                    } description: {
                        Text("Add your dive equipment to track service dates and dive counts.")
                    }
                }
            }
        }
        .navigationTitle("My Gear")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddGear = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddGear) {
            AddGearView()
        }
    }
}

// MARK: - Gear Row

struct GearRowView: View {
    let item: GearItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.category.icon)
                .font(.title3)
                .foregroundStyle(.cyan)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.subheadline.bold())
                HStack(spacing: 8) {
                    if !item.brand.isEmpty {
                        Text(item.brand)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if item.totalDives > 0 {
                        Text("\(item.totalDives) dives")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            // Service indicator
            if item.isServiceOverdue {
                Circle().fill(.red).frame(width: 8, height: 8)
            } else if item.isServiceDueSoon {
                Circle().fill(.orange).frame(width: 8, height: 8)
            }
        }
    }
}

// MARK: - Gear Detail View

struct GearDetailView: View {
    let item: GearItem
    @EnvironmentObject var gearStore: GearStore
    @State private var showingEdit = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: item.category.icon)
                        .font(.system(size: 40))
                        .foregroundStyle(.white)

                    Text(item.name)
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    if !item.brand.isEmpty || !item.model.isEmpty {
                        Text([item.brand, item.model].filter { !$0.isEmpty }.joined(separator: " — "))
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }

                    if item.isRetired {
                        Text("RETIRED")
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(.white.opacity(0.3)))
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.04, green: 0.24, blue: 0.57),
                                 Color(red: 0.04, green: 0.09, blue: 0.15)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Service Status
                if item.serviceIntervalMonths != nil {
                    HStack {
                        Image(systemName: serviceIcon)
                            .font(.title2)
                            .foregroundStyle(serviceColor)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Service Status")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(item.serviceStatusText)
                                .font(.subheadline.bold())
                                .foregroundStyle(serviceColor)
                        }
                        Spacer()
                        if let interval = item.serviceIntervalMonths {
                            Text("Every \(interval) mo")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray5))
                                .clipShape(Capsule())
                        }
                    }
                    .padding()
                    .background(serviceColor.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Quick stats
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    if item.totalDives > 0 {
                        StatCard(icon: "number", label: "Total Dives", value: "\(item.totalDives)")
                    }
                    if let date = item.formattedPurchaseDate {
                        StatCard(icon: "cart.fill", label: "Purchased", value: date)
                    }
                    if let last = item.lastServiceDate {
                        let formatter = DateFormatter()
                        StatCard(icon: "wrench.fill", label: "Last Service", value: {
                            let f = DateFormatter()
                            f.dateStyle = .medium
                            return f.string(from: last)
                        }())
                    }
                    if !item.serialNumber.isEmpty {
                        StatCard(icon: "barcode", label: "Serial #", value: item.serialNumber)
                    }
                }

                // Notes
                if !item.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Notes", systemImage: "note.text")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(item.notes)
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .navigationTitle("Gear Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingEdit = true
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $showingEdit) {
            AddGearView(editingItem: item)
        }
    }

    private var serviceColor: Color {
        if item.isServiceOverdue { return .red }
        if item.isServiceDueSoon { return .orange }
        return .green
    }

    private var serviceIcon: String {
        if item.isServiceOverdue { return "exclamationmark.triangle.fill" }
        if item.isServiceDueSoon { return "clock.badge.exclamationmark" }
        return "checkmark.seal.fill"
    }
}

#Preview {
    NavigationStack {
        GearListView()
            .environmentObject(GearStore())
    }
}
