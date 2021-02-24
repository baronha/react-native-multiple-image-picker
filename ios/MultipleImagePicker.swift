import UIKit
import TLPhotoPicker
import Photos

var MultipleImagePickerConfigure = TLPhotosPickerConfigure();

@objc(MultipleImagePicker)
class MultipleImagePicker: NSObject, TLPhotosPickerViewControllerDelegate,UINavigationControllerDelegate, TLPhotosPickerLogDelegate {
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return false
    }
    
    var window: UIWindow?
    var bridge: RCTBridge!
    var selectedAssets = [TLPHAsset]()
    var options = NSMutableDictionary();
    
    
    
    //resolve/reject assets
    var resolve: RCTPromiseResolveBlock!
    var reject: RCTPromiseRejectBlock!
    
    func selectedCameraCell(picker: TLPhotosPickerViewController) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    @objc(openPicker:withResolver:withRejecter:)
    func openPicker(options: NSDictionary, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
        self.setConfiguration(options: options, resolve: resolve, reject: reject)
        let viewController = CustomPhotoPickerViewController()
        viewController.delegate = self
        
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker);
        }
        viewController.configure = MultipleImagePickerConfigure
        viewController.selectedAssets = self.selectedAssets
        viewController.logDelegate = self
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .overCurrentContext
        
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(viewController, animated: true, completion: nil)
        }
    }
    
    func setConfiguration(options: NSDictionary, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void{
        self.resolve = resolve;
        self.reject = reject;
        
        for key in options.keyEnumerator(){
            if(key as! String != "selectedAssets"){
                self.options.setValue(options[key], forKey: key as! String)
            }
        }
        
        //config options
        MultipleImagePickerConfigure.tapHereToChange = self.options["tapHereToChange"] as! String
        MultipleImagePickerConfigure.numberOfColumn = self.options["numberOfColumn"] as! Int;
        MultipleImagePickerConfigure.cancelTitle = self.options["cancelTitle"] as! String;
        MultipleImagePickerConfigure.doneTitle = self.options["doneTitle"] as! String;
        MultipleImagePickerConfigure.emptyMessage = self.options["emptyMessage"] as! String;
        MultipleImagePickerConfigure.usedCameraButton = self.options["usedCameraButton"] as! Bool;
        MultipleImagePickerConfigure.usedPrefetch = self.options["usedPrefetch"] as! Bool;
        MultipleImagePickerConfigure.allowedLivePhotos = self.options["allowedLivePhotos"]  as! Bool;
        MultipleImagePickerConfigure.allowedVideo = self.options["allowedVideo"]  as! Bool;
        MultipleImagePickerConfigure.allowedAlbumCloudShared = self.options["allowedAlbumCloudShared"] as! Bool;
        MultipleImagePickerConfigure.allowedVideoRecording = self.options["allowedVideoRecording"] as! Bool;
        MultipleImagePickerConfigure.maxVideoDuration = self.options["maxVideoDuration"] as? TimeInterval
        MultipleImagePickerConfigure.autoPlay = self.options["autoPlay"] as! Bool;
        MultipleImagePickerConfigure.muteAudio = self.options["muteAudio"] as! Bool;
        MultipleImagePickerConfigure.singleSelectedMode = (self.options["singleSelectedMode"])! as! Bool;
        MultipleImagePickerConfigure.maxSelectedAssets = self.options["maxSelectedAssets"] as? Int;
        MultipleImagePickerConfigure.selectedColor = hexStringToUIColor(hex: self.options["selectedColor"] as! String)
        MultipleImagePickerConfigure.previewAtForceTouch = self.options["isPreview"] as! Bool;
        
        let mediaType = self.options["mediaType"] as! String;
        
        MultipleImagePickerConfigure.mediaType = mediaType == "video" ? PHAssetMediaType.video : mediaType == "image" ? PHAssetMediaType.image : nil ;

        MultipleImagePickerConfigure.nibSet = (nibName: "Cell", bundle: MultipleImagePickerBundle.bundle())
        
        //        configure.allowedPhotograph = self.options["allowedPhotograph"]
        //        configure.preventAutomaticLimitedAccessAlert = self.options["preventAutomaticLimitedAccessAlert"]
        
        if((options["selectedAssets"]) != nil){
            handleSelectedAssets(selecteds: options["selectedAssets"] as! NSArray);
        }
    }
    
    func handleSelectedAssets(selecteds: NSArray){
        if(selecteds.count != self.selectedAssets.count){
            var assets = [TLPHAsset]();
            for index in 0..<selecteds.count {
                let value = selecteds[index]
                let localIdentifier = (value as! NSObject).value(forKey: "localIdentifier") as! String
                if(!localIdentifier.isEmpty){
                    var TLAsset = TLPHAsset.asset(with: localIdentifier);
                    TLAsset?.selectedOrder = index + 1
                    assets.insert(TLAsset!, at: index)
                }
            }
            self.selectedAssets = assets
        }
    }
    
    func createAttachmentResponse(filePath: String?, withFilename filename: String?, withType type: String?, withAsset asset: PHAsset, withTLAsset TLAsset: TLPHAsset ) -> [AnyHashable :Any]? {
        
        let media = [
            "path": filePath! as String,
            "localIdentifier": asset.localIdentifier,
            "filename":TLAsset.originalFileName!,
            "width": Int(asset.pixelWidth ) as NSNumber,
            "height": Int(asset.pixelHeight ) as NSNumber,
            "mime": type!,
            "creationDate": asset.creationDate!,
            "type": asset.mediaType == .video ? "video" : "image"
        ] as [String : Any]
        
//        if((options["haveThumbnail"] != nil) == true &&  asset.mediaType == .image){
//            print("pathResize", pathResize)
//            let imageResize = resizedImage(at: URL(string: filePath!)!, for: CGSize.init(width: options["thumbnailWidth"] as! Double, height: options["thumbnailWidth"] as! Double))
//            let pathResize = NSURL.init(fileURLWithPath: filePath!)
//
//            let thumbnail = [
//                "width": imageResize?.size.width ?? 0,
//                "height": imageResize?.size.height ?? 0,
//                "path": pathResize,
//            ] as [String : Any]
//            media["thumbnail"] = thumbnail
//        }
        
        return media
    }
    
//    func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
//        let options: [CFString: Any] = [
//            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
//            kCGImageSourceCreateThumbnailWithTransform: true,
//            kCGImageSourceShouldCacheImmediately: true,
//            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
//        ]
//
//        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
//              let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
//        else {
//            return nil
//        }
//
//        return UIImage(cgImage: image)
//    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        if(withTLPHAssets.count == 0){
            self.resolve([]);
            return;
        }
        let  withTLPHAssetsCount = withTLPHAssets.count;
        let selectedAssetsCount = self.selectedAssets.count;
        
        //check difference
        if(withTLPHAssetsCount == selectedAssetsCount && withTLPHAssets[withTLPHAssetsCount - 1].phAsset?.localIdentifier == self.selectedAssets[selectedAssetsCount-1].phAsset?.localIdentifier){
            return;
        }
        let selections = NSMutableArray.init(array: withTLPHAssets);
        self.selectedAssets = withTLPHAssets
        
        //imageRequestOptions
        let imageRequestOptions = PHImageRequestOptions();
        imageRequestOptions.deliveryMode = .fastFormat;
        imageRequestOptions.resizeMode = .fast;
        
        
        let group = DispatchGroup()
        
        for TLAsset in withTLPHAssets {
            group.enter()
            let asset = TLAsset.phAsset
            let index = TLAsset.selectedOrder - 1;
            TLAsset.tempCopyMediaFile(videoRequestOptions: nil, imageRequestOptions: imageRequestOptions, livePhotoRequestOptions: nil, exportPreset: AVAssetExportPresetMediumQuality, convertLivePhotosToJPG: true, progressBlock: { (Double) in
                
            }, completionBlock: { (filePath, fileType) in
                let object = NSDictionary(dictionary: self.createAttachmentResponse(
                    filePath: filePath.absoluteString,
                    withFilename:TLAsset.originalFileName,
                    withType: fileType,
                    withAsset: asset!,
                    withTLAsset: TLAsset
                )!);
                
                selections[index] = object as Any;
                group.leave();
            })
        }
        group.notify(queue: .main){
            self.resolve(selections);
        }
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    func showExceededMaximumAlert(vc: UIViewController) {
        let alert = UIAlertController(title: self.options["maximumMessageTitle"] as? String, message: self.options["maximumMessage"] as? String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: self.options["messageTitleButton"] as? String, style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
