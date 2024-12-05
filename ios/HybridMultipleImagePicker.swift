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

    var selectedAssets: [PhotoAsset] = .init()

    var config: PickerConfiguration = .init()

    func openPicker(config: NitroConfig, resolved: @escaping (([Result]) -> Void), rejected: @escaping ((Double) -> Void)) throws {
        setConfig(config)

        // get selected photo
        selectedAssets = selectedAssets.filter { asset in
            config.selectedAssets.contains {
                $0.localIdentifier == asset.phAsset?.localIdentifier
            }
        }

        DispatchQueue.main.async {
            Photo.picker(
                self.config,
                selectedAssets: self.selectedAssets
            ) { pickerResult, controller in

                controller.autoDismiss = false

                //
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
                                let resultData = try await self.getResult(photoAsset, compression)

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

                self.selectedAssets = pickerResult.photoAssets

                Task {
                    for response in pickerResult.photoAssets {
                        group.enter()

                        let resultData = try await self.getResult(response, compression)

                        data.append(resultData)
                        group.leave()
                    }

                    DispatchQueue.main.async {
                        alert.dismiss(animated: true) {
                            controller.dismiss(true)
                            resolved(data)
                        }
                    }
                }

            } cancel: { cancel in
                cancel.autoDismiss = true
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

        view.addSubview(loadingIndicator)
    }
}
