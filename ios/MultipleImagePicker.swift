//
//  Picker.swift
//  react-native-multiple-image-picker
//
//  Created by BAO HA on 14/03/2024.
//

import HXPhotoPicker
import UIKit

@objc
open class MultipleImagePickerModule: NSObject {
    var resolve: RCTPromiseResolveBlock!
    var reject: RCTPromiseRejectBlock!

    @objc(requiresMainQueueSetup)
    static func requiresMainQueueSetup() -> Bool {
        return false
    }

    @objc(options:)
    public static func openPicker(options: NSDictionary) {
        var config = PickerConfiguration.default

        var photoList = config.photoList

        var bottomView = config.photoList.bottomView
        var cell = photoList.cell

        // cell
        cell.selectBox.style = .number
        cell.isHiddenSingleVideoSelect = true
        photoList.cell = cell

        // photo list
        photoList.spacing = 4
        photoList.rowNumber = 3
        photoList.backgroundColor = .black
        photoList.bottomView.isHiddenOriginalButton = true
        photoList.isShowFilterItem = false
        photoList.allowHapticTouchPreview = false
        photoList.finishSelectionAfterTakingPhoto = true
        photoList.sort = .desc
        photoList.allowSwipeToSelect = true

        // preview
        var previewView = config.previewView
        previewView.disableFinishButtonWhenNotSelected = false
//        previewView.bottomView.finishButtonBackgroundColor = UIColor(Color.accentColor(400))
        previewView.bottomView.isHiddenOriginalButton = true
        config.previewView = previewView

        // config
        config.navigationBackgroundColor = .black
        config.modalPresentationStyle = .popover

        config.photoList = photoList

        config.selectMode = .multiple
        config.photoSelectionTapAction = .quickSelect

        config.selectOptions = [.photo, .video]
        config.allowSyncICloudWhenSelectPhoto = true
        config.allowCustomTransitionAnimation = true

        config.isSelectedOriginal = true

        DispatchQueue.main.async {
            config.modalPresentationStyle = .fullScreen
            var photoAssets: [PhotoAsset] = [PhotoAsset(localIdentifier: "72E53047-CF5A-4C7A-BACF-9499DCBC2A7F")]

            print("photoAssets: ", photoAssets)

            Photo.picker(
                config
            ) { pickerResult, _ in

//                    let urlResults: [AssetURLResult] = try await pickerResult.objects()
//                    let assetResults: [AssetResult] = try await pickerResult.objects()
//                    let result: [AssetResult] = try await pickerResult.objects()
                pickerResult.getImage { image, photoAsset, _ in
                    if let image = image {
                        print("success", image, photoAsset.localAssetIdentifier)
                    } else {
                        print("failed")
                    }
                } completionHandler: { images in
                    print("images", images)
                }
                //

                // Select completion callback
                // result Select result
                //  .photoAssets Currently selected data
                //  .isOriginal Whether the original image is selected
                // photoPickerController Corresponding photo selection controller
            } cancel: { _ in

                // Cancelled callback
                // photoPickerController Corresponding photo selection controller
            }
        }
    }
}
