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
        config = PickerConfiguration.default

        var photoList = config.photoList
        var previewView = config.previewView

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

        if let selectMode = PickerSelectMode(rawValue: Int(options.selectMode.rawValue)) {
            config.selectMode = selectMode
        }

        if let maxFileSize = options.maxFileSize {
            config.maximumSelectedPhotoFileSize = Int(maxFileSize)
            config.maximumSelectedVideoFileSize = Int(maxFileSize)
        }

        if let maxVideo = options.maxVideo {
            config.maximumSelectedVideoCount = Int(maxVideo)
        }

        if let maxVideoDuration = options.maxVideoDuration {
            config.maximumSelectedVideoDuration = Int(maxVideoDuration)
        }

        config.allowSyncICloudWhenSelectPhoto = true

        config.allowCustomTransitionAnimation = true

        config.isSelectedOriginal = false

//        config.isFetchDeatilsAsset = true

        let isPreview = options.isPreview ?? true

        previewView.bottomView.isShowPreviewList = isPreview
        photoList.bottomView.isHiddenPreviewButton = !isPreview
        photoList.allowHapticTouchPreview = !isPreview
        photoList.bottomView.previewListTickColor = .clear
        photoList.bottomView.isShowSelectedView = isPreview

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
            previewView.bottomView.isHiddenEditButton = true
        }

        photoList.finishSelectionAfterTakingPhoto = true

        config.photoList = photoList
        config.previewView = previewView

        setLanguage(options)
        setTheme(options)

        switch Int(options.presentation.rawValue) {
        case 1:
            config.modalPresentationStyle = .formSheet
        default:
            config.modalPresentationStyle = .fullScreen
        }
    }

    private func setTheme(_ options: NitroConfig) {
        let isDark = options.theme == Theme.dark

        // custom background dark
        if let background = options.backgroundDark, let backgroundDark = getReactColor(Int(background)), isDark {
            config.photoList.backgroundDarkColor = backgroundDark
            config.photoList.backgroundColor = backgroundDark
        }

        // LIGHT THEME
        if isDark {
//            config.appearanceStyle = .dark
//            config.photoList.titleView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        } else {
            let background = UIColor.white
            let barStyle = UIBarStyle.default

            config.statusBarStyle = .darkContent
            config.appearanceStyle = .normal
            config.photoList.bottomView.barStyle = barStyle
            config.navigationBarStyle = barStyle
            config.previewView.bottomView.barStyle = barStyle
            config.previewView.backgroundColor = background
            config.previewView.bottomView.backgroundColor = background

            config.photoList.leftNavigationItems = [PhotoCancelItem.self]

            config.photoList.backgroundColor = .white
            config.photoList.emptyView.titleColor = .black
            config.photoList.emptyView.subTitleColor = .darkGray
            config.photoList.titleView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

            config.albumList.backgroundColor = .white
            config.albumList.cellBackgroundColor = .white
            config.albumList.albumNameColor = .black
            config.albumList.photoCountColor = .black
            config.albumList.cellSelectedColor = "#e1e1e1".hx.color
            config.albumList.separatorLineColor = "#e1e1e1".hx.color
        }

        if let primaryColor = options.primaryColor, let color = getReactColor(Int(primaryColor)) {
            config.setThemeColor(color)
        }

        config.navigationTitleColor = .white
        config.photoList.titleView.arrow.arrowColor = .white
        config.photoList.cell.customSelectableCellClass = nil
    }

    private func setLanguage(_ options: NitroConfig) {
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

            if let edit = text.edit {
                config.textManager.picker.preview.bottomView.editTitle = .custom(edit)
            }
        }

        switch options.language {
        case .vi:
            config.languageType = .vietnamese // -> 🇻🇳 My country. Yeahhh
        case .zhHans:
            config.languageType = .simplifiedChinese
        case .zhHant:
            config.languageType = .traditionalChinese
        case .ja:
            config.languageType = .japanese
        case .ko:
            config.languageType = .korean
        case .en:
            config.languageType = .english
        case .th:
            config.languageType = .thai
        case .id:
            config.languageType = .indonesia

        case .ru:
            config.languageType = .russian
        case .de:
            config.languageType = .german
        case .fr:
            config.languageType = .french
        case .ar:
            config.languageType = .arabic

        default:
            config.languageType = .system
        }
    }
}
