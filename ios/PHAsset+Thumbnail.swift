//
//  PHAsset+Thumbnail.swift
//  Pods
//
//  Created by BAO HA on 24/10/24.
//

import Photos

extension PHAsset {
    func getVideoThumbnail(from moviePath: String, in seconds: Double) -> String? {
        if mediaType == .video {
            let filepath = moviePath.replacingOccurrences(of: "file://", with: "")
            let vidURL = URL(fileURLWithPath: filepath)

            let asset = AVURLAsset(url: vidURL, options: nil)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: seconds, preferredTimescale: 600)

            var thumbnail: UIImage?

            do {
                let imgRef = try generator.copyCGImage(at: time, actualTime: nil)
                thumbnail = UIImage(cgImage: imgRef)
            } catch {
                print("Error create thumbnail: \(error)")
                return nil
            }

            if let thumbnail {
                return getImagePathFromUIImage(uiImage: thumbnail, prefix: "thumb")
            }
        }

        return nil
    }

    private func getImagePathFromUIImage(uiImage: UIImage, prefix: String? = "thumb") -> String? {
        let fileManager = FileManager.default

        guard
            let tempDirectory = FileManager.default.urls(
                for: .cachesDirectory,
                in: .userDomainMask).map(\.path).last
        else {
            return nil
        }

        let data = uiImage.jpegData(compressionQuality: 0.9)

        let fullPath = URL(fileURLWithPath: tempDirectory).appendingPathComponent("\(prefix ?? "thumb")-\(ProcessInfo.processInfo.globallyUniqueString).jpg").path

        fileManager.createFile(atPath: fullPath, contents: data, attributes: nil)

        return "file://" + fullPath
    }
}
