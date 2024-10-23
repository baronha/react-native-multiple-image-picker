//
//  HybridMultipleImagePicker.swift
//
//  Created by Marc Rousavy on 18.07.24.
//

import Foundation
import HXPhotoPicker
import NitroModules

class HybridMultipleImagePicker: HybridMultipleImagePickerSpec {
    var hybridContext = margelo.nitro.HybridContext()

    var memorySize: Int {
        return getSizeOf(self)
    }

    var config = PickerConfiguration.default

    func openPicker(config: NitroConfig, resolved: @escaping (([Result]) -> Void), rejected: @escaping ((Double) -> Void)) throws {
        setConfig(config)

        DispatchQueue.main.async {
            //            var photoAssets: [PhotoAsset] = [PhotoAsset(localIdentifier: "72E53047-CF5A-4C7A-BACF-9499DCBC2A7F")]

            //            print("photoAssets: ", photoAssets)

            Photo.picker(
                self.config
            ) { pickerResult, controller in
                let imageQuality = config.imageQuality ?? 1.0
                let videoQuality: Int = {
                    if let quality = config.videoQuality {
                        return Int(quality * 10)
                    }

                    return 10
                }()

                // add loading view
                let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)

                alert.showLoading()

                controller.present(alert, animated: true)

                controller.autoDismiss = false

                let compression: PhotoAsset.Compression = .init(imageCompressionQuality: imageQuality, videoExportParameter: .init(preset: .highQuality, quality: videoQuality))

                var data: [Result] = []

                let group = DispatchGroup()

                pickerResult.photoAssets.forEach { photo in
                    Task {
                        group.enter()
                        let assetResult = try await photo.urlResult(compression)
//                        let result = self.getResult(photo, assetURLResult: assetResult)
//
//                        data.append(result)

                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true) {
                            controller.dismiss(true)
                        }
                    }
                }

            } cancel: { cancel in

                cancel.autoDismiss = true

                // Cancelled callback
                // photoPickerController Corresponding photo selection controller
            }
        }
    }
}

extension HybridMultipleImagePicker {
//    func getResult(_ asset: PhotoAsset, assetURLResult: AssetURLResult) -> Result {
//        return Result(path: "", fileName: "file", localIdentifier: asset.localAssetIdentifier, width: asset.imageSize.width, height: asset.imageSize.height, mime: assetURLResult.urlType, size: assetURLResult.url.fileSize, bucketId: nil, realPath: nil, parentFolderName: nil, creationDate: asset.phAsset?.creationDate)
//    }
}

extension UIAlertController {
    func showLoading() {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))

        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium

        if #available(iOS 13.0, *) {
            loadingIndicator.color = .secondaryLabel
        } else {
            loadingIndicator.color = .black
        }

        loadingIndicator.startAnimating()

        self.view.addSubview(loadingIndicator)
    }
}
