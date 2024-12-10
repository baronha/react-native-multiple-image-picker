//
//  HybridMultipleImagePicker+Crop.swift
//  Pods
//
//  Created by BAO HA on 9/12/24.
//

import HXPhotoPicker

// class CropConfig: PickerCropConfig {
//    //
// }

extension HybridMultipleImagePicker {
    func openCrop(image: String, config: NitroCropConfig, resolved: @escaping ((CropResult) -> Void), rejected: @escaping ((Double) -> Void)) throws {
        let asset: EditorAsset

        if image.hasPrefix("http://") || image.hasPrefix("https://") || image.hasPrefix("file://") {
            guard let url = URL(string: image),
                  let data = try? Data(contentsOf: url)

            else {
                rejected(0)
                return
            }

            asset = .init(type: .imageData(data))
        } else {
            asset = .init(type: .photoAsset(.init(localIdentifier: image)))
        }

        let editConfig = setCropConfig(circle: config.circle, ratio: config.ratio)
//
//        switch Int(config.presentation.rawValue) {
//        case 1:
//            editConfig.modalPresentationStyle = .formSheet
//        default:
//            editConfig.modalPresentationStyle = .fullScreen
//        }
//
//        editConfig.languageType = setLocale(language: options.language)

        DispatchQueue.main.async {
            Photo.edit(asset: asset, config: editConfig) { result, _ in

                if let path = result.result?.url.absoluteString, let size = result.result?.image?.size {
                    let result = CropResult(path: path, width: size.width, height: size.height)

                    resolved(result)
                }
            }
        }
    }

    func setCropConfig(circle: Bool? = false, ratio: [CropRatio]) -> EditorConfiguration {
        var config = EditorConfiguration()

        config.photo.defaultSelectedToolOption = .cropSize

        config.isFixedCropSizeState = true

        config.isWhetherFinishButtonDisabledInUneditedState = true

        config.cropSize.isRoundCrop = circle ?? false

        config.cropSize.isResetToOriginal = true

        config.toolsView = .init(toolOptions: [.init(imageType: PickerConfiguration.default.editor.imageResource.editor.tools.cropSize, type: .cropSize)])

        config.photo.defaultSelectedToolOption = .cropSize

        if config.cropSize.isRoundCrop {
            config.cropSize.aspectRatios = []
        } else {
            var aspectRatios: [EditorRatioToolConfig] = config.cropSize.aspectRatios

            // custom ratio
            if ratio.count > 0 {
                ratio.forEach { ratio in
                    let width = Int(ratio.width)
                    let height = Int(ratio.height)

                    aspectRatios.append(.init(title: .custom(ratio.title ?? "\(width)/\(height)"), ratio: .init(width: width, height: height)))
                }
            }

            config.cropSize.aspectRatios = aspectRatios
        }

        return config
    }
}
