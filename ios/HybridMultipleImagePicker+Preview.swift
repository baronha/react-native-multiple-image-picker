//
//  HybridMultipleImagePicker+Preview.swift
//  Pods
//
//  Created by BAO HA on 11/12/24.
//

import HXPhotoPicker

extension HybridMultipleImagePicker {
    func openPreview(media: [MediaPreview], index: Double, config: NitroPreviewConfig) throws {
        var previewConfig = HXPhotoPicker.PhotoBrowser.Configuration()
        previewConfig.showDelete = false

        var assets: [PhotoAsset] = []

        previewConfig.tintColor = .white
        previewConfig.videoPlayType = config.videoAutoPlay == true ? .auto : .normal
        previewConfig.livePhotoPlayType = .auto

        previewConfig.languageType = setLocale(language: config.language)

        media.forEach { mediaItem in

            var asset: PhotoAsset?

            if let localIdentifier = mediaItem.localIdentifier {
                asset = .init(localIdentifier: localIdentifier)

                // auto play gif
                if let filePath = mediaItem.path,
                   let url = URL(string: filePath), isGifFile(url) == true
                {
                    asset = .init(.init(imageURL: url))
                }

            } else if let path = mediaItem.path, let url = URL(string: path) {
                let thumbnail = URL(string: mediaItem.thumbnail ?? "") ?? url

                if mediaItem.type == .image {
                    // network asset
                    if path.hasPrefix("https://") || path.hasPrefix("http://") {
                        asset = PhotoAsset(NetworkImageAsset(
                            thumbnailURL: thumbnail,
                            originalURL: url,
                            thumbnailLoadMode: .alwaysThumbnail,
                            originalLoadMode: .alwaysThumbnail
                        ))

                    } else {
                        asset = .init(.init(imageURL: url))
                    }
                } else {
                    asset = .init(networkVideoAsset: .init(videoURL: url, coverImageURL: thumbnail))
                }
            }

            if let asset {
                assets.append(asset)
            }
        }

        if Int(index) > assets.count - 1 { return }

        DispatchQueue.main.async {
            HXPhotoPicker.PhotoBrowser.show(
                assets,
                pageIndex: Int(index),
                config: previewConfig
            )
        }
    }
}
