//
//  UIImage.swift
//  Pods
//
//  Created by BAO HA on 16/12/24.
//

extension UIImage {
    func getPath(fileName name: String? = nil, quality: CGFloat = 1.0) -> String? {
        let tempDirectoryURL = FileManager.default.temporaryDirectory

        let data = self.jpegData(compressionQuality: 0.9)

        let fileName = name ?? "IMG_\(Int(Date().timeIntervalSince1970)).jpg"

        let fileURL = tempDirectoryURL.appendingPathComponent(fileName)

        if let imageData = self.jpegData(compressionQuality: quality) {
            do {
                try imageData.write(to: fileURL)
                return fileURL.absoluteString

            } catch {
                return nil
            }
        }

        return nil
    }
}
