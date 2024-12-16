//
//  HybridMultipleImagePicker+Camera.swift
//  Pods
//
//  Created by BAO HA on 13/12/24.
//

import HXPhotoPicker

extension HybridMultipleImagePicker {
    func openCamera(config: NitroCameraConfig, resolved: @escaping ((CameraResult) -> Void), rejected: @escaping ((Double) -> Void)) throws {
        var cameraConfig = CameraConfiguration()

        cameraConfig.videoMaximumDuration = config.videoMaximumDuration ?? 60

        cameraConfig.modalPresentationStyle = self.setPresentation(config.presentation)

        cameraConfig.editor.modalPresentationStyle = .fullScreen

        if let crop = config.crop {
            let editor = PickerCropConfig(circle: crop.circle, ratio: crop.ratio, defaultRatio: crop.defaultRatio, freeStyle: crop.freeStyle)
            cameraConfig.editor = setCropConfig(editor)
        } else {
            cameraConfig.allowsEditing = false
        }

        cameraConfig.languageType = setLocale(language: config.language)
        cameraConfig.isSaveSystemAlbum = config.isSaveSystemAlbum ?? false
        cameraConfig.allowLocation = config.allowLocation ?? true
        cameraConfig.sessionPreset = .hd1920x1080
        cameraConfig.aspectRatio = .fullScreen

        if let color = config.color, let focusColor = getReactColor(Int(color)) {
            cameraConfig.focusColor = focusColor
        }

        switch Int(config.cameraDevice?.rawValue ?? 1) {
        case 0:
            cameraConfig.position = .front
        default:
            cameraConfig.position = .back
        }

        DispatchQueue.main.async {
            Photo.capture(cameraConfig) { result, _, _ in
                print("result: ", result)
            }
        }
    }

    func setCameraConfig(_ options: PickerCameraConfig) -> SystemCameraConfiguration {
        var config = SystemCameraConfiguration()

        config.editExportPreset = .highQuality
        config.videoQuality = .typeHigh

        switch Int(options.cameraDevice?.rawValue ?? 1) {
        case 0:
            config.cameraDevice = .front
        default:
            config.cameraDevice = .rear
        }

        config.videoMaximumDuration = options.videoMaximumDuration ?? 60

        return config
    }
}
