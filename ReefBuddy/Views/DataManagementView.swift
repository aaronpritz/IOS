import SwiftUI
import UniformTypeIdentifiers

struct DataManagementView: View {
    @EnvironmentObject var store: DiveStore
    @State private var showingImportAlert = false
    @State private var showingImportFile = false
    @State private var importMessage = ""
    @State private var showingExportOptions = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Export
                VStack(alignment: .leading, spacing: 12) {
                    Label("Export", systemImage: "square.and.arrow.up")
                        .font(.headline)

                    Text("Export your \(store.dives.count) dives in multiple formats.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if store.dives.isEmpty {
                        Text("No dives to export.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding()
                    } else {
                        // JSON Export
                        ShareLink(
                            item: ExportService.generateJSON(from: store.dives),
                            subject: Text("ReefBuddy Dive Log"),
                            message: Text("My dive log exported from ReefBuddy")
                        ) {
                            ExportRow(icon: "doc.text", title: "Export as JSON", subtitle: "Full backup — can be re-imported", color: .cyan)
                        }

                        // CSV Export
                        ShareLink(
                            item: ExportService.generateCSV(from: store.dives),
                            subject: Text("ReefBuddy Dive Log"),
                            message: Text("My dive log exported from ReefBuddy")
                        ) {
                            ExportRow(icon: "tablecells", title: "Export as CSV", subtitle: "Opens in Excel, Numbers, Google Sheets", color: .green)
                        }

                        // Text Report
                        ShareLink(
                            item: ExportService.generateReport(from: store.dives),
                            subject: Text("ReefBuddy Dive Log Report"),
                            message: Text("My dive log report from ReefBuddy")
                        ) {
                            ExportRow(icon: "doc.plaintext", title: "Export Dive Report", subtitle: "Readable text summary of all dives", color: .purple)
                        }

                        // Copy JSON
                        Button {
                            UIPasteboard.general.string = ExportService.generateJSON(from: store.dives)
                            importMessage = "JSON copied to clipboard!"
                            showingImportAlert = true
                        } label: {
                            ExportRow(icon: "doc.on.doc", title: "Copy JSON to Clipboard", subtitle: "For quick paste into another app", color: .secondary)
                        }

                        // Copy CSV
                        Button {
                            UIPasteboard.general.string = ExportService.generateCSV(from: store.dives)
                            importMessage = "CSV copied to clipboard!"
                            showingImportAlert = true
                        } label: {
                            ExportRow(icon: "doc.on.doc", title: "Copy CSV to Clipboard", subtitle: "Paste into spreadsheet apps", color: .secondary)
                        }
                    }
                }

                Divider()

                // MARK: - Import
                VStack(alignment: .leading, spacing: 12) {
                    Label("Import", systemImage: "square.and.arrow.down")
                        .font(.headline)

                    Text("Restore dives from a previously exported JSON file or clipboard.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Button {
                        showingImportFile = true
                    } label: {
                        ExportRow(icon: "folder", title: "Import from File", subtitle: "Select a .json file from Files", color: .blue)
                    }

                    Button {
                        importFromClipboard()
                    } label: {
                        ExportRow(icon: "doc.on.clipboard", title: "Import from Clipboard", subtitle: "Paste a previously copied JSON export", color: .secondary)
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

                        let totalTime = store.dives.reduce(0) { $0 + $1.bottomTime }
                        DataRow(label: "Total Bottom Time", value: "\(totalTime / 60)h \(totalTime % 60)m")

                        if let deepest = store.dives.max(by: { $0.maxDepth < $1.maxDepth }) {
                            DataRow(label: "Deepest Dive", value: "\(Int(deepest.maxDepth)) ft")
                        }
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
        .alert("Data Management", isPresented: $showingImportAlert) {
            Button("OK") {}
        } message: {
            Text(importMessage)
        }
        .fileImporter(
            isPresented: $showingImportFile,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result)
        }
    }

    // MARK: - Import Helpers

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

        importData(data)
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else {
                importMessage = "No file selected."
                showingImportAlert = true
                return
            }

            guard url.startAccessingSecurityScopedResource() else {
                importMessage = "Could not access the file. Try copying it to Files first."
                showingImportAlert = true
                return
            }

            defer { url.stopAccessingSecurityScopedResource() }

            do {
                let data = try Data(contentsOf: url)
                importData(data)
            } catch {
                importMessage = "Could not read the file."
                showingImportAlert = true
            }

        case .failure:
            importMessage = "File selection was cancelled."
            showingImportAlert = true
        }
    }

    private func importData(_ data: Data) {
        do {
            let dives = try ExportService.importJSON(from: data)
            if dives.isEmpty {
                importMessage = "No dives found in the data."
            } else {
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
            importMessage = "Invalid format. Make sure you're importing a ReefBuddy JSON export."
        }
        showingImportAlert = true
    }
}

// MARK: - Export Row

struct ExportRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

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
