import SwiftUI

struct CertificationView: View {
    @State private var certifications: [Certification] = []
    @State private var showingAdd = false

    private let saveKey = "ReefBuddyCerts"

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if certifications.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 40))
                            .foregroundStyle(.cyan.opacity(0.5))
                        Text("No certifications logged")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Tap + to add your first cert")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)
                } else {
                    ForEach(certifications) { cert in
                        HStack(spacing: 14) {
                            VStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.title2)
                                    .foregroundStyle(.cyan)
                            }
                            .frame(width: 44)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(cert.name)
                                    .font(.subheadline.bold())

                                HStack(spacing: 8) {
                                    Text(cert.agency.rawValue)
                                        .font(.caption)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.cyan.opacity(0.15))
                                        .foregroundStyle(.cyan)
                                        .clipShape(Capsule())

                                    Text(cert.formattedDate)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                if !cert.certNumber.isEmpty {
                                    Text("# \(cert.certNumber)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .contextMenu {
                            Button(role: .destructive) {
                                certifications.removeAll { $0.id == cert.id }
                                saveCerts()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Certifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showingAdd = true } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddCertificationView { cert in
                certifications.insert(cert, at: 0)
                saveCerts()
            }
        }
        .onAppear { loadCerts() }
    }

    private func saveCerts() {
        if let data = try? JSONEncoder().encode(certifications) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func loadCerts() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Certification].self, from: data) {
            certifications = decoded
        }
    }
}

struct AddCertificationView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Certification) -> Void

    @State private var name = ""
    @State private var customName = ""
    @State private var agency: Certification.CertAgency = .padi
    @State private var dateObtained = Date()
    @State private var certNumber = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Certification") {
                    Picker("Select", selection: $name) {
                        Text("Select...").tag("")
                        ForEach(Certification.commonCerts, id: \.self) { cert in
                            Text(cert).tag(cert)
                        }
                        Text("Custom...").tag("__custom__")
                    }

                    if name == "__custom__" {
                        TextField("Certification name", text: $customName)
                    }
                }

                Section("Agency") {
                    Picker("Agency", selection: $agency) {
                        ForEach(Certification.CertAgency.allCases, id: \.self) { a in
                            Text(a.rawValue).tag(a)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Details") {
                    DatePicker("Date Obtained", selection: $dateObtained, displayedComponents: .date)
                    TextField("Cert Number (optional)", text: $certNumber)
                }
            }
            .navigationTitle("Add Certification")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let finalName = name == "__custom__" ? customName : name
                        let cert = Certification(
                            name: finalName,
                            agency: agency,
                            dateObtained: dateObtained,
                            certNumber: certNumber
                        )
                        onSave(cert)
                        dismiss()
                    }
                    .disabled(effectiveName.isEmpty)
                    .bold()
                }
            }
        }
    }

    private var effectiveName: String {
        name == "__custom__" ? customName : name
    }
}

#Preview {
    NavigationStack {
        CertificationView()
    }
}
