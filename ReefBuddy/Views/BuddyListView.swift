import SwiftUI

struct BuddyListView: View {
    @EnvironmentObject var buddyStore: BuddyStore
    @EnvironmentObject var diveStore: DiveStore
    @State private var showingAddBuddy = false
    @State private var searchText = ""

    private var filteredBuddies: [DiveBuddy] {
        if searchText.isEmpty {
            return buddyStore.buddies
        }
        return buddyStore.buddies.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            // Favorites
            let favorites = filteredBuddies.filter(\.isFavorite)
            if !favorites.isEmpty {
                Section {
                    ForEach(favorites) { buddy in
                        NavigationLink(destination: BuddyDetailView(buddy: buddy)) {
                            BuddyRow(buddy: buddy, diveCount: buddyStore.sharedDiveCount(buddyName: buddy.name, dives: diveStore.dives))
                        }
                    }
                } header: {
                    Label("Favorites", systemImage: "star.fill")
                }
            }

            // All buddies
            let nonFavorites = filteredBuddies.filter { !$0.isFavorite }
            if !nonFavorites.isEmpty {
                Section {
                    ForEach(nonFavorites) { buddy in
                        NavigationLink(destination: BuddyDetailView(buddy: buddy)) {
                            BuddyRow(buddy: buddy, diveCount: buddyStore.sharedDiveCount(buddyName: buddy.name, dives: diveStore.dives))
                        }
                    }
                    .onDelete { offsets in
                        let toDelete = offsets.map { nonFavorites[$0] }
                        for buddy in toDelete {
                            buddyStore.deleteBuddy(buddy)
                        }
                    }
                } header: {
                    Label("All Buddies", systemImage: "person.2")
                }
            }

            if buddyStore.buddies.isEmpty {
                Section {
                    ContentUnavailableView {
                        Label("No Buddies", systemImage: "person.2.slash")
                    } description: {
                        Text("Add your dive buddies to track who you dive with.")
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search buddies")
        .navigationTitle("Dive Buddies")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddBuddy = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddBuddy) {
            AddBuddyView()
        }
    }
}

// MARK: - Buddy Row

struct BuddyRow: View {
    let buddy: DiveBuddy
    let diveCount: Int

    var body: some View {
        HStack(spacing: 12) {
            // Avatar circle
            ZStack {
                Circle()
                    .fill(Color.cyan.opacity(0.15))
                    .frame(width: 42, height: 42)
                Text(buddy.initials)
                    .font(.subheadline.bold())
                    .foregroundStyle(.cyan)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(buddy.name)
                        .font(.subheadline.bold())
                    if buddy.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                    }
                }
                HStack(spacing: 8) {
                    if !buddy.certLevel.isEmpty {
                        Text(buddy.certLevel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if diveCount > 0 {
                        Text("\(diveCount) dives together")
                            .font(.caption)
                            .foregroundStyle(.cyan)
                    }
                }
            }
        }
    }
}

// MARK: - Buddy Detail View

struct BuddyDetailView: View {
    let buddy: DiveBuddy
    @EnvironmentObject var buddyStore: BuddyStore
    @EnvironmentObject var diveStore: DiveStore
    @EnvironmentObject var units: UnitSettings
    @State private var showingEdit = false

    private var sharedDives: [Dive] {
        buddyStore.sharedDives(buddyName: buddy.name, dives: diveStore.dives)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.cyan.opacity(0.2))
                            .frame(width: 72, height: 72)
                        Text(buddy.initials)
                            .font(.title.bold())
                            .foregroundStyle(.white)
                    }

                    Text(buddy.name)
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    if !buddy.certLevel.isEmpty {
                        Text(buddy.certLevel)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
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

                // Contact info
                if !buddy.phone.isEmpty || !buddy.email.isEmpty {
                    VStack(spacing: 0) {
                        if !buddy.phone.isEmpty {
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundStyle(.cyan)
                                    .frame(width: 24)
                                Text(buddy.phone)
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding()
                            if !buddy.email.isEmpty {
                                Divider().padding(.leading, 44)
                            }
                        }
                        if !buddy.email.isEmpty {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundStyle(.cyan)
                                    .frame(width: 24)
                                Text(buddy.email)
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Stats
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    StatCard(icon: "number", label: "Dives Together", value: "\(sharedDives.count)")
                    if let deepest = sharedDives.map(\.maxDepth).max() {
                        StatCard(icon: "arrow.down.to.line", label: "Deepest Together", value: units.depthDisplay(deepest))
                    }
                }

                // Notes
                if !buddy.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Notes", systemImage: "note.text")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(buddy.notes)
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Shared dive history
                if !sharedDives.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Dive History Together", systemImage: "clock")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        ForEach(sharedDives.prefix(10)) { dive in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(dive.diveSite)
                                        .font(.subheadline.bold())
                                    Text(dive.formattedDate)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(units.depthDisplay(dive.maxDepth))
                                    .font(.caption)
                                    .foregroundStyle(.cyan)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .navigationTitle("Buddy")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 12) {
                    Button {
                        buddyStore.toggleFavorite(buddy)
                    } label: {
                        Image(systemName: buddy.isFavorite ? "star.fill" : "star")
                            .foregroundStyle(buddy.isFavorite ? .yellow : .secondary)
                    }
                    Button {
                        showingEdit = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
            }
        }
        .sheet(isPresented: $showingEdit) {
            AddBuddyView(editingBuddy: buddy)
        }
    }
}

// MARK: - Add/Edit Buddy View

struct AddBuddyView: View {
    @EnvironmentObject var buddyStore: BuddyStore
    @Environment(\.dismiss) var dismiss

    var editingBuddy: DiveBuddy? = nil
    var isEditing: Bool { editingBuddy != nil }

    @State private var name = ""
    @State private var certLevel = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var notes = ""
    @State private var isFavorite = false

    private let certOptions = ["OW", "AOW", "Rescue", "Divemaster", "Instructor", "Nitrox", "Tech", ""]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    Picker("Certification", selection: $certLevel) {
                        Text("None").tag("")
                        ForEach(certOptions.filter { !$0.isEmpty }, id: \.self) { cert in
                            Text(cert).tag(cert)
                        }
                    }
                } header: {
                    Label("Buddy Info", systemImage: "person.fill")
                }

                Section {
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                } header: {
                    Label("Contact", systemImage: "phone.fill")
                }

                Section {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Label("Notes", systemImage: "note.text")
                }

                Section {
                    Toggle("Favorite", isOn: $isFavorite)
                }
            }
            .navigationTitle(isEditing ? "Edit Buddy" : "Add Buddy")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Update" : "Save") {
                        saveBuddy()
                    }
                    .disabled(name.isEmpty)
                    .bold()
                }
            }
            .onAppear {
                if let buddy = editingBuddy {
                    name = buddy.name
                    certLevel = buddy.certLevel
                    phone = buddy.phone
                    email = buddy.email
                    notes = buddy.notes
                    isFavorite = buddy.isFavorite
                }
            }
        }
    }

    private func saveBuddy() {
        let buddy = DiveBuddy(
            id: editingBuddy?.id ?? UUID(),
            name: name,
            certLevel: certLevel,
            phone: phone,
            email: email,
            notes: notes,
            isFavorite: isFavorite
        )

        if isEditing {
            buddyStore.updateBuddy(buddy)
        } else {
            buddyStore.addBuddy(buddy)
        }
        dismiss()
    }
}

#Preview {
    NavigationStack {
        BuddyListView()
            .environmentObject(BuddyStore())
            .environmentObject(DiveStore())
            .environmentObject(UnitSettings())
    }
}
