import CropViewController
import Photos
import TLPhotoPicker
import UIKit

var _isCrop = true
var _isPreview = true

extension TLPhotosPickerConfigure {
    var isPreview: Bool {
        get { return _isPreview }
        set {
            _isPreview = newValue
        }
    }

    var isCrop: Bool {
        get { return _isCrop }
        set {
            _isCrop = newValue
        }
    }
}

var config = TLPhotosPickerConfigure()

@objc(MultipleImagePicker)
class MultipleImagePicker: NSObject, UINavigationControllerDelegate {
 
    @objc static func requiresMainQueueSetup() -> Bool {
        return false
    }

    var selectedAssets = [TLPHAsset]()
    var options = NSMutableDictionary()
    var videoAssets = [PHAsset]()
    var videoCount = 0
        
    // resolve/reject assets
    var resolve: RCTPromiseResolveBlock!
    var reject: RCTPromiseRejectBlock!
    
    lazy var cameraManager: CameraManager? = {
        guard let topViewController = UIApplication.topViewController() else { return nil  }
        let cameraManager = CameraManager(viewController: topViewController)
        cameraManager.delegate = self
        return cameraManager
    }()
    
    @objc(openPicker:withResolver:withRejecter:)
    func openPicker(options: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.setConfiguration(options: options, resolve: resolve, reject: reject)

        // handle for Authorization === '.limit' on iOS 14 && limit selected === 0
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                if status == .limited {
                    self.handleLimitedCondition()
                    return
                }
                self.navigatePicker()
            }
            
        } else {
            self.navigatePicker()
        }
    }
    
    @objc(launchCamera:withResolver:withRejecter:)
    func launchCamera(options: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        debugPrint("++++++++++ launchCamera")
        self.resolve = resolve
        self.reject = reject
        DispatchQueue.main.async {
            guard let cameraManager = self.cameraManager else { return }
            cameraManager.showCameraIfAuthorized()
        }
    }
    
    private func fetchAssetCount() -> Int {
        let options = PHFetchOptions()
        
        if config.mediaType != nil {
            let mediaType =
                config.mediaType == .image ? PHAssetMediaType.image.rawValue : PHAssetMediaType.video.rawValue
            options.predicate = NSPredicate(format: "mediaType = %d", mediaType)
        }
        
        let fetchResult = PHAsset.fetchAssets(with: options)
        return fetchResult.count
    }
    
    private func handleLimitedCondition() {
        let count = self.fetchAssetCount()
        print("count: ", count)
        if count == 0 {
            self.presentLimitedController()
        } else {
            self.navigatePicker()
        }
    }
    
    private func presentLimitedController() {
        DispatchQueue.main.async {
            if #available(iOS 14, *) {
                if #available(iOS 15, *) {
                    let topViewController = self.getTopMostViewController()!
                    var show = 0
                    
                    PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: topViewController) { _ in
                        let count = self.fetchAssetCount() // check count after presentLimitedLibraryPicker
                        if count == 0 {
                            topViewController.dismiss(animated: true) {
                                self.reject("LIMITED_ACCESS_CANCELLED", "User has canceled", nil)
                            }
                            return
                        }
                        
                        show += 1 // presentLimitedLibraryPicker run twice and I DONT KNOWWWWW...
                        if show == 1 {
                            topViewController.dismiss(animated: true) {
                                self.handleLimitedCondition()
                            }
                        }
                    }
                    
                } else {
                    PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self.getTopMostViewController()!)
                }
            }
        }
    }
    
    func navigatePicker() {
        let viewController = CustomPhotoPickerViewController()
        
        viewController.delegate = self
        
        // dismissPhotoPicker for CustomPhotoPickerViewController()
        viewController.dismissPhotoPicker = { [weak self] withPHAssets in
            self?.dismissPhotoPicker(withTLPHAssets: withPHAssets)
        }
        
        viewController.didExceedMaximumNumberOfSelection = { [weak self] picker in
            self?.showExceededMaximumAlert(vc: picker, isVideo: false)
        }
       
        viewController.selectedAssets = self.selectedAssets
        viewController.logDelegate = self
        
        viewController.configure = config
        
        DispatchQueue.main.async {
            viewController.modalTransitionStyle = .coverVertical
            viewController.modalPresentationStyle = .fullScreen
            self.getTopMostViewController()?.present(viewController, animated: true, completion: nil)
        }
    }

    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    private func setConfiguration(options: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolve = resolve
        self.reject = reject
        
        for key in options.keyEnumerator() {
            if key as! String != "selectedAssets" {
                self.options.setValue(options[key], forKey: key as! String)
            }
        }
        
        // config options
        config.tapHereToChange = self.options["tapHereToChange"] as! String
        config.numberOfColumn = self.options["numberOfColumn"] as! Int
        config.cancelTitle = self.options["cancelTitle"] as! String
        config.doneTitle = self.options["doneTitle"] as! String
        config.emptyMessage = self.options["emptyMessage"] as! String
        config.selectMessage = self.options["selectMessage"] as! String
        config.deselectMessage = self.options["deselectMessage"] as! String
        config.usedCameraButton = self.options["usedCameraButton"] as! Bool
        config.usedPrefetch = self.options["usedPrefetch"] as! Bool
        config.allowedLivePhotos = self.options["allowedLivePhotos"] as! Bool
        config.allowedVideo = self.options["allowedVideo"] as! Bool
        config.allowedAlbumCloudShared = self.options["allowedAlbumCloudShared"] as! Bool
        config.allowedVideoRecording = self.options["allowedVideoRecording"] as! Bool
        config.maxVideoDuration = self.options["maxVideoDuration"] as? TimeInterval
        config.autoPlay = self.options["autoPlay"] as! Bool
        config.muteAudio = self.options["muteAudio"] as! Bool
        config.singleSelectedMode = (self.options["singleSelectedMode"])! as! Bool
        config.maxSelectedAssets = self.options["maxSelectedAssets"] as? Int
        config.selectedColor = UIColor(hex: self.options["selectedColor"] as! String)
        
        config.isPreview = self.options["isPreview"] as? Bool ?? false
        
        config.isCrop = (config.singleSelectedMode && self.options["isCrop"] as! Bool)
        
        let mediaType = self.options["mediaType"] as! String
        
        config.mediaType = mediaType == "video" ? PHAssetMediaType.video : mediaType == "image" ? PHAssetMediaType.image : nil
        
        config.nibSet = (nibName: "Cell", bundle: MultipleImagePickerBundle.bundle())
        
        config.allowedPhotograph = self.options["allowedPhotograph"] as! Bool
        
        if options["selectedAssets"] != nil {
            self.handleSelectedAssets(selectedList: options["selectedAssets"] as! NSArray)
        }
    }

    func handleSelectedAssets(selectedList: NSArray) {
        let assetsExist = selectedList.filter { ($0 as! NSObject).value(forKey: "localIdentifier") != nil }
        self.videoCount = selectedList.filter { ($0 as! NSObject).value(forKey: "type") as? String == "video" }.count
        var assets = [TLPHAsset]()
        for index in 0 ..< assetsExist.count {
            let value = assetsExist[index]
            let localIdentifier = (value as! NSObject).value(forKey: "localIdentifier") as! String
            if !localIdentifier.isEmpty {
                var TLAsset = TLPHAsset.asset(with: localIdentifier)
                TLAsset?.selectedOrder = index + 1
                assets.insert(TLAsset!, at: index)
            }
        }
        self.selectedAssets = assets
        self.videoCount = assets.filter { $0.phAsset?.mediaType == .video }.count
    }
}

extension MultipleImagePicker: CameraManagerDelegate  {
    func didSelectPhoto(_ assets: [TLPHAsset]) {
        guard let asset = assets.last else { return  }
        
        DispatchQueue.main.async {
            self.options["isExportThumbnail"] = false
            self.fetchAsset(TLAsset: asset) { object in
                self.resolve([object.data])
            }
        }
    }
}

extension UIViewController {
    func getTopVC() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
}

// TLPhotosPickerLogDelegate
extension MultipleImagePicker: TLPhotosPickerLogDelegate {
    func selectedCameraCell(picker: TLPhotosPickerViewController) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let cell = picker.collectionView(picker.collectionView, cellForItemAt: IndexPath(row: at, section: 0)) as! Cell
        if cell.asset?.mediaType == PHAssetMediaType.video {
            self.videoCount -= 1
        }
    }
    
    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        debugPrint("++++++++++ handleNoCameraPermissions")
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

// CropViewControllerDelegate
extension MultipleImagePicker: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        guard
            let TLAsset = self.selectedAssets.first,
            let filePath = getImagePathFromUIImage(uiImage: image, prefix: "crop")
        else {
            self.dismissComplete()
            return
        }
        
        // Dismiss twice for crop controller & picker controller
        DispatchQueue.main.async {
            cropViewController.dismiss(animated: true) {
                let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                        
                alert.showLoading()

                self.getTopMostViewController()?.present(alert, animated: true) {
                    self.fetchAsset(TLAsset: TLAsset) { object in
                            
                        object.data!["crop"] = [
                            "height": image.size.height,
                            "width": image.size.width,
                            "path": filePath,
                        ]
                            
                        DispatchQueue.main.async {
                            self.resolve([object.data])
                            alert.dismiss(animated: true) {
                                self.getTopMostViewController()?.dismiss(animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension UIAlertController {
    func showLoading() {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        
        if #available(iOS 13.0, *) {
            loadingIndicator.color = .secondaryLabel
        } else {
            loadingIndicator.color = .black
        }
        
        loadingIndicator.startAnimating()
        
        self.view.addSubview(loadingIndicator)
    }
}

extension MultipleImagePicker: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        return false
    }
    
    func photoPickerDidCancel() {
        self.reject("PICKER_CANCELLED", "User has canceled", nil)
    }

    func dismissComplete() {
        DispatchQueue.main.async {
            self.getTopMostViewController()?.dismiss(animated: true, completion: nil)
        }
    }
    
    func presentCropViewController(image: UIImage) {
        let cropViewController = CropViewController(croppingStyle: (self.options["isCropCircle"] as! Bool) ? .circular : .default, image: image)
        cropViewController.delegate = self
        cropViewController.doneButtonTitle = config.doneTitle
        cropViewController.doneButtonColor = config.selectedColor
        
        cropViewController.cancelButtonTitle = config.cancelTitle
        
        self.getTopMostViewController()?.present(cropViewController, animated: true, completion: nil)
    }
    
    func fetchAsset(TLAsset: TLPHAsset, completion: @escaping (MediaResponse) -> Void) {
        // set image / video request option.
        let imageRequestOptions = PHImageRequestOptions()
        let videoRequestOptions = PHVideoRequestOptions()
        
        imageRequestOptions.deliveryMode = .fastFormat
        imageRequestOptions.resizeMode = .fast
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.isSynchronous = false
        
        videoRequestOptions.version = PHVideoRequestOptionsVersion.current
        videoRequestOptions.deliveryMode = PHVideoRequestOptionsDeliveryMode.automatic
        videoRequestOptions.isNetworkAccessAllowed = true

        TLAsset.tempCopyMediaFile(videoRequestOptions: videoRequestOptions, imageRequestOptions: imageRequestOptions, livePhotoRequestOptions: nil, exportPreset: AVAssetExportPresetHighestQuality, convertLivePhotosToJPG: true, progressBlock: { _ in
        }, completionBlock: { filePath, fileType in
            
            let object = MediaResponse(filePath: filePath.absoluteString, mime: fileType, withTLAsset: TLAsset, isExportThumbnail: self.options["isExportThumbnail"] as! Bool)
                        
            DispatchQueue.main.async {
                completion(object)
            }
        })
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // check with asset picker
        if withTLPHAssets.count == 0 {
            self.resolve([])
            self.dismissComplete()
            return
        }
        
        // define count
        let withTLPHAssetsCount = withTLPHAssets.count
        let selectedAssetsCount = self.selectedAssets.count
        
        // check logic code for isCrop
        
        let isCrop = config.isCrop && withTLPHAssets.first?.type == .photo
        
        // check difference
        if withTLPHAssetsCount == selectedAssetsCount && withTLPHAssets[withTLPHAssetsCount - 1].phAsset?.localIdentifier == self.selectedAssets[selectedAssetsCount - 1].phAsset?.localIdentifier && !isCrop {
            self.dismissComplete()
            return
        }
        
        self.selectedAssets = withTLPHAssets
        
        if isCrop {
            let uiImage = withTLPHAssets.first?.fullResolutionImage
            if uiImage != nil {
                self.presentCropViewController(image: (withTLPHAssets.first?.fullResolutionImage)!)
                return
            }
        }
        
        let selections = NSMutableArray(array: withTLPHAssets)
        
        // add loading view
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        alert.showLoading()
        
        // handle controller
        self.getTopMostViewController()?.present(alert, animated: true, completion: {
            let group = DispatchGroup()
            
            for TLAsset in withTLPHAssets {
                group.enter()
                self.fetchAsset(TLAsset: TLAsset) { object in
                    let index = TLAsset.selectedOrder - 1
                    selections[index] = object.data as Any
                    group.leave()
                }
            }
            
            group.notify(queue: .main) { [self] in
                self.resolve(selections)
                DispatchQueue.main.async {
                    alert.dismiss(animated: true, completion: {
                        self.dismissComplete()
                    })
                }
            }
        })
    }

    func showExceededMaximumAlert(vc: UIViewController, isVideo: Bool) {
        let alert = UIAlertController(title: self.options["maximumMessageTitle"] as? String, message: self.options[isVideo ? "maximumVideoMessage" : "maximumMessage"] as? String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: self.options["messageTitleButton"] as? String, style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        let maxVideo = self.options["maxVideo"]
        if phAsset.mediaType == .video {
            if self.videoCount == maxVideo as! Int && !(self.options["singleSelectedMode"] as! Bool) {
                self.showExceededMaximumAlert(vc: self.getTopMostViewController()!, isVideo: true)
                return false
            }
            self.videoCount += 1
        }
        return true
    }
}
