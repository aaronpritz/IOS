import SwiftUI
import UIKit

/// Manages saving and loading dive photos to the app's documents directory
class PhotoStorage {
    static let shared = PhotoStorage()

    private var photosDirectory: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = docs.appendingPathComponent("DivePhotos", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    /// Save a UIImage as JPEG and return the filename
    func savePhoto(_ image: UIImage, for diveID: UUID) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        let filename = "\(diveID.uuidString)_\(UUID().uuidString.prefix(8)).jpg"
        let url = photosDirectory.appendingPathComponent(filename)
        do {
            try data.write(to: url)
            return filename
        } catch {
            print("Failed to save photo: \(error)")
            return nil
        }
    }

    /// Load a UIImage from a filename
    func loadPhoto(_ filename: String) -> UIImage? {
        let url = photosDirectory.appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    /// Delete a photo file
    func deletePhoto(_ filename: String) {
        let url = photosDirectory.appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
    }

    /// Delete all photos for a dive
    func deletePhotos(for diveID: UUID) {
        let prefix = diveID.uuidString
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: photosDirectory.path) else { return }
        for file in files where file.hasPrefix(prefix) {
            try? FileManager.default.removeItem(at: photosDirectory.appendingPathComponent(file))
        }
    }
}
