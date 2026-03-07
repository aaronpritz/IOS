import SwiftUI

/// A text field with a buddy picker dropdown for quick selection
struct BuddyPickerField: View {
    @Binding var buddyName: String
    @EnvironmentObject var buddyStore: BuddyStore
    @State private var showPicker = false

    var body: some View {
        HStack {
            TextField("Buddy Name", text: $buddyName)

            if !buddyStore.buddies.isEmpty {
                Button {
                    showPicker = true
                } label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .foregroundStyle(.cyan)
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $showPicker) {
            NavigationStack {
                List {
                    if !buddyStore.favoriteBuddies.isEmpty {
                        Section("Favorites") {
                            ForEach(buddyStore.favoriteBuddies) { buddy in
                                Button {
                                    buddyName = buddy.name
                                    showPicker = false
                                } label: {
                                    HStack(spacing: 10) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.cyan.opacity(0.15))
                                                .frame(width: 34, height: 34)
                                            Text(buddy.initials)
                                                .font(.caption.bold())
                                                .foregroundStyle(.cyan)
                                        }
                                        VStack(alignment: .leading) {
                                            Text(buddy.name)
                                                .font(.subheadline.bold())
                                                .foregroundStyle(.primary)
                                            if !buddy.certLevel.isEmpty {
                                                Text(buddy.certLevel)
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "star.fill")
                                            .font(.caption)
                                            .foregroundStyle(.yellow)
                                    }
                                }
                            }
                        }
                    }

                    let nonFavs = buddyStore.buddies.filter { !$0.isFavorite }
                    if !nonFavs.isEmpty {
                        Section("All Buddies") {
                            ForEach(nonFavs) { buddy in
                                Button {
                                    buddyName = buddy.name
                                    showPicker = false
                                } label: {
                                    HStack(spacing: 10) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.cyan.opacity(0.15))
                                                .frame(width: 34, height: 34)
                                            Text(buddy.initials)
                                                .font(.caption.bold())
                                                .foregroundStyle(.cyan)
                                        }
                                        VStack(alignment: .leading) {
                                            Text(buddy.name)
                                                .font(.subheadline.bold())
                                                .foregroundStyle(.primary)
                                            if !buddy.certLevel.isEmpty {
                                                Text(buddy.certLevel)
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Select Buddy")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showPicker = false }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
}
