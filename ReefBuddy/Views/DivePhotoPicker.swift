import SwiftUI
import PhotosUI

/// A view for selecting photos from the library and optionally taking new ones
struct DivePhotoPicker: View {
    @Binding var photoFilenames: [String]
    let diveID: UUID

    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isProcessing = false
    @State private var showCamera = false

    private let maxPhotos = 10

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Photos (\(photoFilenames.count)/\(maxPhotos))", systemImage: "photo.on.rectangle.angled")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }

            // Thumbnail grid
            if !photoFilenames.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(photoFilenames, id: \.self) { filename in
                            ZStack(alignment: .topTrailing) {
                                if let image = PhotoStorage.shared.loadPhoto(filename) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray4))
                                        .frame(width: 80, height: 80)
                                        .overlay {
                                            Image(systemName: "photo")
                                                .foregroundStyle(.secondary)
                                        }
                                }

                                Button {
                                    removePhoto(filename)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                        .background(Circle().fill(.black.opacity(0.6)).frame(width: 18, height: 18))
                                }
                                .offset(x: 4, y: -4)
                            }
                        }
                    }
                }
            }

            // Action buttons
            if photoFilenames.count < maxPhotos {
                HStack(spacing: 12) {
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: maxPhotos - photoFilenames.count,
                        matching: .images
                    ) {
                        Label("Library", systemImage: "photo.on.rectangle")
                            .font(.subheadline)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                    }
                    .onChange(of: selectedItems) { _, items in
                        processSelectedItems(items)
                    }

                    Button {
                        showCamera = true
                    } label: {
                        Label("Camera", systemImage: "camera")
                            .font(.subheadline)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                    }

                    if isProcessing {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView { image in
                if let filename = PhotoStorage.shared.savePhoto(image, for: diveID) {
                    photoFilenames.append(filename)
                }
            }
        }
    }

    private func processSelectedItems(_ items: [PhotosPickerItem]) {
        guard !items.isEmpty else { return }
        isProcessing = true

        Task {
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data),
                   let filename = PhotoStorage.shared.savePhoto(uiImage, for: diveID) {
                    await MainActor.run {
                        photoFilenames.append(filename)
                    }
                }
            }
            await MainActor.run {
                isProcessing = false
                selectedItems = []
            }
        }
    }

    private func removePhoto(_ filename: String) {
        PhotoStorage.shared.deletePhoto(filename)
        photoFilenames.removeAll { $0 == filename }
    }
}

// MARK: - Camera View (UIImagePickerController wrapper)

struct CameraView: UIViewControllerRepresentable {
    let onCapture: (UIImage) -> Void
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onCapture(image)
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
