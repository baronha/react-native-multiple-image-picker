//
//  HybridMultipleImagePicker+Config.swift
//  react-native-multiple-image-picker
//
//  Created by BAO HA on 15/10/2024.
//

import HXPhotoPicker
import UIKit

// Swift enum
// @objc enum MediaType: SelectBoxView.Style

extension HybridMultipleImagePicker {
    func setConfig(_ options: NitroConfig) {
        var photoList = config.photoList
        var previewView = config.previewView

        // photo list

        if let spacing = options.spacing { photoList.spacing = spacing }
        if let rowNumber = options.numberOfColumn { photoList.rowNumber = Int(rowNumber) }

        if let isHiddenPreviewButton = options.isHiddenPreviewButton {
            previewView.bottomView.isHiddenPreviewButton = isHiddenPreviewButton
            photoList.bottomView.isHiddenOriginalButton = isHiddenPreviewButton
        }

        if let isHiddenOriginalButton = options.isHiddenOriginalButton {
            previewView.bottomView.isHiddenOriginalButton = isHiddenOriginalButton
            photoList.bottomView.isHiddenOriginalButton = isHiddenOriginalButton
        }

        if let allowHapticTouchPreview = options.allowHapticTouchPreview {
            photoList.allowHapticTouchPreview = allowHapticTouchPreview
        }

        if let allowSwipeToSelect = options.allowSwipeToSelect {
            photoList.allowSwipeToSelect = allowSwipeToSelect
        }
        if let allowedCamera = options.allowedCamera {
            photoList.allowAddCamera = allowedCamera
        }

        if let isShowAssetNumber = options.isShowAssetNumber {
            photoList.isShowAssetNumber = isShowAssetNumber
        }

        if let allowedLimit = options.allowedLimit {
            photoList.allowAddLimit = allowedLimit
        }

        // check media type
        switch options.mediaType {
        case .image:
            config.selectOptions = [.photo, .livePhoto, .gifPhoto]
        case .video:
            config.selectOptions = .video
        default:
            config.selectOptions = [.video, .photo, .gifPhoto, .livePhoto]
        }

        if let boxStyle = SelectBoxView.Style(rawValue: Int(options.selectBoxStyle.rawValue)) {
            previewView.selectBox.style = boxStyle
            photoList.cell.selectBox.style = boxStyle
        }

        photoList.isShowFilterItem = false
        photoList.sort = .desc
        photoList.isShowAssetNumber = false

        previewView.disableFinishButtonWhenNotSelected = false

        config.photoList = photoList
        config.previewView = previewView

        if let selectMode = PickerSelectMode(rawValue: Int(options.selectMode.rawValue)) {
            config.selectMode = selectMode
        }

        if let maxFileSize = options.maxFileSize {
            config.maximumSelectedPhotoFileSize = Int(maxFileSize)
            config.maximumSelectedVideoFileSize = Int(maxFileSize)
        }

        if let maxPhoto = options.maxPhoto {
            config.maximumSelectedPhotoCount = Int(maxPhoto)
        }

        if let maxVideo = options.maxVideo {
            config.maximumSelectedVideoCount = Int(maxVideo)
        }

        if let maxVideoDuration = options.maxVideoDuration {
            config.maximumSelectedVideoDuration = Int(maxVideoDuration)
        }

        config.allowSyncICloudWhenSelectPhoto = true

        config.allowCustomTransitionAnimation = true

        config.isSelectedOriginal = true

//        config.isFetchDeatilsAsset = true

        config.navigationTitleColor = .systemBackground

        let isPreview = options.isPreview ?? true

        config.previewView.bottomView.isShowPreviewList = isPreview
        config.photoList.bottomView.isHiddenPreviewButton = !isPreview
        config.photoList.allowHapticTouchPreview = !isPreview
        config.photoList.bottomView.previewListTickColor = .clear
        config.photoList.bottomView.isShowSelectedView = isPreview

        if isPreview {
            config.videoSelectionTapAction = .preview
            config.photoSelectionTapAction = .preview
        } else {
            config.videoSelectionTapAction = .quickSelect
            config.photoSelectionTapAction = .quickSelect
        }

        if let crop = options.crop {
            config.editorOptions = [.photo, .gifPhoto, .livePhoto]

            var editor = config.editor

            let isCircle = crop.circle ?? false

            editor.cropSize.isRoundCrop = isCircle

            if isCircle {
                editor.cropSize.aspectRatios = []
            } else {
                editor.cropSize.aspectRatios = PickerConfiguration.default.editor.cropSize.aspectRatios
            }

            editor.photo.defaultSelectedToolOption = .cropSize
            editor.toolsView = .init(toolOptions: [.init(imageType: config.editor.imageResource.editor.tools.cropSize, type: .cropSize)])

            editor.isFixedCropSizeState = true

            config.editor = editor

        } else {
            config.previewView.bottomView.isHiddenEditButton = true
        }

        config.photoList.finishSelectionAfterTakingPhoto = true

        setLanguage(options)

        switch Int(options.presentation.rawValue) {
        case 1:
            config.modalPresentationStyle = .formSheet
        default:
            config.modalPresentationStyle = .fullScreen
        }

        if let primaryColor = options.primaryColor, let color = getReactColor(Int(primaryColor)) {
            config.setThemeColor(color)
        }
    }

    func setLanguage(_ options: NitroConfig) {
        if let text = options.text {
            if let finish = text.finish {
                config.textManager.picker.photoList.bottomView.finishTitle = .custom(finish)
                config.textManager.picker.preview.bottomView.finishTitle = .custom(finish)
                config.textManager.editor.crop.maskListFinishTitle = .custom(finish)
            }

            if let original = text.original {
                config.textManager.picker.photoList.bottomView.originalTitle = .custom(original)
                config.textManager.picker.preview.bottomView.originalTitle = .custom(original)
            }

            if let preview = text.preview {
                config.textManager.picker.photoList.bottomView.previewTitle = .custom(preview)
            }
        }

        switch options.language {
        case .simplifiedchinese:
            config.languageType = .simplifiedChinese
        case .traditionalchinese:
            config.languageType = .traditionalChinese
        case .japanese:
            config.languageType = .japanese
        case .korean:
            config.languageType = .korean
        case .english:
            config.languageType = .english
        case .thai:
            config.languageType = .thai
        case .indonesia:
            config.languageType = .indonesia
        case .vietnamese:
            config.languageType = .vietnamese
        case .russian:
            config.languageType = .russian
        case .german:
            config.languageType = .german
        case .french:
            config.languageType = .french
        case .arabic:
            config.languageType = .arabic

        default:
            config.languageType = .system
        }
    }
}
