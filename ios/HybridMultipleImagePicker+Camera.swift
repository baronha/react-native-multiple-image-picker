//
//  HybridMultipleImagePicker+Camera.swift
//  Pods
//
//  Created by BAO HA on 12/12/24.
//

import HXPhotoPicker

extension HybridMultipleImagePicker {
    func openCamera(config: NitroCameraConfig, resolved: @escaping ((Result) -> Void), rejected: @escaping ((Double) -> Void)) throws {
        var cameraConfig = CameraConfiguration()

        cameraConfig.modalPresentationStyle = getPresentation(config.presentation)
        cameraConfig.editor.video.defaultSelectedToolOption = .time

        if let crop = config.crop {
            let editor = setCropConfig(crop)
            cameraConfig.editor = editor
        } else {
            cameraConfig.allowsEditing = false
        }

        cameraConfig.languageType = setLocale(language: config.language)

        DispatchQueue.main.async {
            Photo.capture(cameraConfig, type: .all) { result, asset, _ in
                print("complete: ", result, asset)
            }
        }
    }
}
