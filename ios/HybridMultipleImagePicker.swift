//
//  HybridMultipleImagePicker.swift
//
//  Created by Marc Rousavy on 18.07.24.
//

import Foundation
import HXPhotoPicker
import NitroModules
import Photos

class HybridMultipleImagePicker: HybridMultipleImagePickerSpec {
    var hybridContext = margelo.nitro.HybridContext()

    var memorySize: Int {
        return getSizeOf(self)
    }

    var config = PickerConfiguration.default

    func openPicker(config: NitroConfig, resolved: @escaping (([Result]) -> Void), rejected: @escaping ((Double) -> Void)) throws {
        setConfig(config)
        let seleted: [PhotoAsset] = config.selectedAssets.map { result in
            let asset = PhotoAsset(localIdentifier: result.localIdentifier)

            return asset
        }

        DispatchQueue.main.async {
            Photo.picker(
                self.config,
                selectedAssets: seleted
            ) { pickerResult, controller in

                controller.autoDismiss = false

                let imageQuality = config.imageQuality ?? 1.0
                let videoQuality: Int = {
                    if let quality = config.videoQuality {
                        return Int(quality * 10)
                    }

                    return 10
                }()

                let compression: PhotoAsset.Compression = .init(imageCompressionQuality: imageQuality, videoExportParameter: .init(preset: videoQuality == 10 ? .highQuality : videoQuality < 5 ? .mediumQuality : .lowQuality, quality: videoQuality))

                // check crop for single
                if let asset = pickerResult.photoAssets.first, config.selectMode == .single, config.crop != nil, asset.mediaType == .photo, asset.editedResult?.url == nil {
                    // open crop
                    Photo.edit(asset: .init(type: .photoAsset(asset)), config: self.config.editor, sender: controller) { editedResult, _ in

                        if let photoAsset = pickerResult.photoAssets.first, let result = editedResult.result {
                            photoAsset.editedResult = .some(result)

                            Task {
                                let urlResult = try await photoAsset.urlResult(compression)
                                let resultData = self.getResult(photoAsset, urlResult.url)

                                DispatchQueue.main.async {
                                    resolved([resultData])
                                    controller.dismiss(true)
                                }
                            }
                        }
                    }

                    return
                }

                // show alert view
                let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
                alert.showLoading()
                controller.present(alert, animated: true)

                let group = DispatchGroup()

                var data: [Result] = []

                pickerResult.photoAssets.forEach { response in
                    Task {
                        group.enter()

                        let urlResult = try await response.urlResult(compression)
                        let resultData = self.getResult(response, urlResult.url)

                        data.append(resultData)

                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true) {
                            controller.dismiss(true)
                            resolved(data)
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
