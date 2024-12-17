//
//  HybridMultipleImagePicker+Camera.swift
//  Pods
//
//  Created by BAO HA on 13/12/24.
//

import AVFoundation
import HXPhotoPicker
import Photos

extension HybridMultipleImagePicker {
    func openCamera(config: NitroCameraConfig, resolved: @escaping ((CameraResult) -> Void), rejected: @escaping ((Double) -> Void)) throws {
        var captureType: CameraController.CaptureType = .all

        // check media type
        switch config.mediaType {
        case .image:
            captureType = .photo
        case .video:
            captureType = .video
        default:
            break
        }

        // config
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
        cameraConfig.sessionPreset = .hd4K3840x2160
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

        func getCameraResult(_ result: CameraController.Result, _ asset: PHAsset?) {
            if let asset {
                Task {
                    let photoAsset = PhotoAsset(asset)
                    let urlResult = try await photoAsset.urlResult()
                    let path = urlResult.url.absoluteString

                    let phAsset = photoAsset.phAsset
                    let thumbnail = phAsset?.getVideoAssetThumbnail(from: path, in: 1)

                    resolved(CameraResult(path: path, type: photoAsset.mediaType == .photo ? ResultType.image : ResultType.video, width: photoAsset.imageSize.width, height: photoAsset.imageSize.height, duration: photoAsset.videoDuration, thumbnail: thumbnail, fileName: phAsset?.fileName))
                }

            } else {
                switch result {
                case .image(let uiImage):

                    let fileName = "IMG_\(Int(Date().timeIntervalSince1970)).jpg"
                    let filePath = uiImage.getPath(fileName: fileName, quality: 1.0)

                    if let filePath {
                        resolved(CameraResult(path: filePath, type: ResultType.image, width: uiImage.size.width, height: uiImage.size.height, duration: nil, thumbnail: nil, fileName: fileName))
                    } else {
                        rejected(1)
                    }

                case .video(let url):

                    let asset = AVAsset(url: url)

                    let thumbnail = getVideoThumbnail(from: url.absoluteString, in: 1)

                    var result = CameraResult(path: "file://\(url.absoluteString)",
                                              type: ResultType.video,
                                              width: nil,
                                              height: nil,
                                              duration: asset.duration.seconds,
                                              thumbnail: thumbnail,
                                              fileName: url.lastPathComponent)

                    if let track = asset.tracks(withMediaType: AVMediaType.video).first {
                        let trackSize = track.naturalSize.applying(track.preferredTransform)
                        let size = CGSize(width: abs(trackSize.width), height: abs(trackSize.height))

                        result.width = Double(size.width)
                        result.height = Double(size.height)
                    }

                    resolved(result)
                }
            }
        }

        DispatchQueue.main.async {
            Photo.capture(cameraConfig, type: captureType) { result, asset, _ in
                getCameraResult(result, asset)
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
