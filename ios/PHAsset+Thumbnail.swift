//
//  PHAsset+Thumbnail.swift
//  Pods
//
//  Created by BAO HA on 24/10/24.
//

import Photos

extension PHAsset {
    func getVideoAssetThumbnail(from moviePath: String, in seconds: Double) -> String? {
        if mediaType == .video {
            if let path = getVideoThumbnail(from: moviePath, in: seconds) {
                return "file://\(path)"
            }
        }

        return nil
    }

    var fileName: String {
        if let resources = PHAssetResource.assetResources(for: self).first {
            return resources.originalFilename
        }

        return ""
    }
}

func getVideoThumbnail(from moviePath: String, in seconds: Double) -> String? {
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
        return thumbnail.getPath(fileName: nil, quality: 0.8)
    }

    return nil
}
