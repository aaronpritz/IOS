import SwiftUI

struct DataManagementView: View {
    @EnvironmentObject var store: DiveStore
    @State private var showingExportShare = false
    @State private var showingImportAlert = false
    @State private var showingImportFile = false
    @State private var importMessage = ""
    @State private var exportJSON = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Export
                VStack(alignment: .leading, spacing: 12) {
                    Label("Export", systemImage: "square.and.arrow.up")
                        .font(.headline)

                    Text("Export all \(store.dives.count) dives as a JSON file that can be imported later.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if store.dives.isEmpty {
                        Text("No dives to export.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding()
                    } else {
                        ShareLink(item: exportString()) {
                            HStack {
                                Image(systemName: "doc.text")
                                Text("Export Dive Log (\(store.dives.count) dives)")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color.cyan.opacity(0.15))
                            .foregroundStyle(.cyan)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        // Copy JSON
                        Button {
                            UIPasteboard.general.string = exportString()
                            importMessage = "JSON copied to clipboard!"
                            showingImportAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Copy JSON to Clipboard")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }

                Divider()

                // MARK: - Import
                VStack(alignment: .leading, spacing: 12) {
                    Label("Import", systemImage: "square.and.arrow.down")
                        .font(.headline)

                    Text("Paste a previously exported JSON to restore your dive log.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Button {
                        importFromClipboard()
                    } label: {
                        HStack {
                            Image(systemName: "doc.on.clipboard")
                            Text("Import from Clipboard")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                Divider()

                // MARK: - Data Summary
                VStack(alignment: .leading, spacing: 8) {
                    Label("Data Summary", systemImage: "info.circle")
                        .font(.headline)

                    Group {
                        DataRow(label: "Total Dives", value: "\(store.dives.count)")
                        if let oldest = store.dives.sorted(by: { $0.date < $1.date }).first {
                            DataRow(label: "Earliest Dive", value: oldest.formattedDate)
                        }
                        if let newest = store.dives.sorted(by: { $0.date > $1.date }).first {
                            DataRow(label: "Latest Dive", value: newest.formattedDate)
                        }
                        let locations = Set(store.dives.map(\.location))
                        DataRow(label: "Unique Locations", value: "\(locations.count)")
                        let sites = Set(store.dives.map(\.diveSite))
                        DataRow(label: "Unique Sites", value: "\(sites.count)")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Data Management")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Import", isPresented: $showingImportAlert) {
            Button("OK") {}
        } message: {
            Text(importMessage)
        }
    }

    private func exportString() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(store.dives),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return "[]"
    }

    private func importFromClipboard() {
        guard let text = UIPasteboard.general.string, !text.isEmpty else {
            importMessage = "Clipboard is empty."
            showingImportAlert = true
            return
        }

        guard let data = text.data(using: .utf8) else {
            importMessage = "Could not read clipboard data."
            showingImportAlert = true
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let dives = try decoder.decode([Dive].self, from: data)
            if dives.isEmpty {
                importMessage = "No dives found in the data."
            } else {
                // Merge: add dives that don't already exist (by ID)
                let existingIDs = Set(store.dives.map(\.id))
                var added = 0
                for dive in dives {
                    if !existingIDs.contains(dive.id) {
                        store.addDive(dive)
                        added += 1
                    }
                }
                importMessage = "Imported \(added) new dive(s). (\(dives.count - added) already existed)"
            }
        } catch {
            importMessage = "Invalid format. Make sure you're pasting a ReefBuddy export."
        }
        showingImportAlert = true
    }
}

struct DataRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
        }
    }
}

#Preview {
    NavigationStack {
        DataManagementView()
            .environmentObject(DiveStore())
    }
}
