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
    var videoAssets = [PHAsset]()
    var videoCount = 0
    // controller
    
    
    
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
        let cell = picker.collectionView(picker.collectionView, cellForItemAt: IndexPath.init(row: at, section: 0)) as! Cell
        if(cell.asset?.mediaType == PHAssetMediaType.video){
            videoCount -= 1
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
    
    
    @objc(openPicker:withResolver:withRejecter:)
    func openPicker(options: NSDictionary, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
        self.setConfiguration(options: options, resolve: resolve, reject: reject)
        let viewController = CustomPhotoPickerViewController()
        viewController.delegate = self
        
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker, isVideo: false);
        }
        viewController.configure = MultipleImagePickerConfigure
        viewController.selectedAssets = self.selectedAssets
        viewController.logDelegate = self
        
        //        viewController.navigationBar
        
        DispatchQueue.main.async {
            viewController.modalTransitionStyle = .coverVertical
            viewController.modalPresentationStyle = .fullScreen
            
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
        let assetsExist =  selecteds.filter{ ($0 as! NSObject).value(forKey: "localIdentifier") != nil }
        videoCount = selecteds.filter{ ($0 as! NSObject).value(forKey: "type") as? String == "video" }.count
        
        print("assets", assetsExist.count)
        print("self.selectedAssets.count", self.selectedAssets)
        if(assetsExist.count != self.selectedAssets.count){
            var assets = [TLPHAsset]();
            for index in 0..<assetsExist.count {
                let value = assetsExist[index]
                let localIdentifier = (value as! NSObject).value(forKey: "localIdentifier") as! String
                if(!localIdentifier.isEmpty){
                    var TLAsset = TLPHAsset.asset(with: localIdentifier);
                    TLAsset?.selectedOrder = index + 1
                    assets.insert(TLAsset!, at: index)
                }
                print("index", index)
            }
            self.selectedAssets = assets
            self.videoCount = assets.filter{ $0.phAsset?.mediaType == .video }.count
        }
    }
    
    func createAttachmentResponse(filePath: String?, withFilename filename: String?, withType type: String?, withAsset asset: PHAsset, withTLAsset TLAsset: TLPHAsset ) -> [AnyHashable :Any]? {
        var media = [
            "path": "file://" + filePath! as String,
            "localIdentifier": asset.localIdentifier,
            "filename":TLAsset.originalFileName!,
            "width": Int(asset.pixelWidth ) as NSNumber,
            "height": Int(asset.pixelHeight ) as NSNumber,
            "mime": type!,
            "creationDate": asset.creationDate!,
            "type": asset.mediaType == .video ? "video" : "image",
        ] as [String : Any]
        
        //option in video
        if(asset.mediaType == .video){
            //get video's thumbnail
            if(options["isExportThumbnail"] as! Bool){
                let thumbnail = getThumbnail(from: filePath!, in: 0.1)
                media["thumbnail"] = thumbnail
            }
            //get video size
            TLAsset.videoSize { Int in
                media["size"] = Int
            }
            media["duration"] = asset.duration
        }else{
            TLAsset.photoSize { Int in
                media["size"] = Int
            }
        }
        return media
    }
    
    func getThumbnail(from moviePath: String, in seconds: Double) -> String? {
        let filepath = moviePath.replacingOccurrences(
            of: "file://",
            with: "")
        let vidURL = URL(fileURLWithPath: filepath)
        
        let asset = AVURLAsset(url: vidURL, options: nil)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        var _: Error? = nil
        let time = CMTimeMake(value: 1, timescale: 60)
        
        var imgRef: CGImage? = nil
        do {
            imgRef = try generator.copyCGImage(at: time, actualTime: nil)
        } catch _ {
        }
        var thumbnail: UIImage? = nil
        if let imgRef = imgRef {
            thumbnail = UIImage(cgImage: imgRef)
        }
        // save to temp directory
        let tempDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask).map(\.path).last
        
        let data = thumbnail?.jpegData(compressionQuality: 1.0)
        let fileManager = FileManager.default
        let fullPath = URL(fileURLWithPath: tempDirectory ?? "").appendingPathComponent("thumb-\(ProcessInfo.processInfo.globallyUniqueString).jpg").path
        fileManager.createFile(atPath: fullPath, contents: data, attributes: nil)
        return fullPath;
        
    }
    
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        return false
    }
    
    internal func dismissLoading() {
        if let vc = self.getTopMostViewController()?.presentedViewController, vc is UIAlertController {
            self.getTopMostViewController()?.dismiss(animated: false, completion: nil)
        }
    }
    
    func dismissComplete(){
        DispatchQueue.main.async {
            self.getTopMostViewController()?.dismiss(animated: true, completion: nil)
        }
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        if(withTLPHAssets.count == 0){
            self.resolve([]);
            dismissComplete()
            return;
        }
        let  withTLPHAssetsCount = withTLPHAssets.count;
        let selectedAssetsCount = self.selectedAssets.count;
        
        //check difference
        if(withTLPHAssetsCount == selectedAssetsCount && withTLPHAssets[withTLPHAssetsCount - 1].phAsset?.localIdentifier == self.selectedAssets[selectedAssetsCount-1].phAsset?.localIdentifier){
            dismissComplete()
            return;
        }
        
        let selections = NSMutableArray.init(array: withTLPHAssets);
        self.selectedAssets = withTLPHAssets
        //imageRequestOptions
        let imageRequestOptions = PHImageRequestOptions();
        imageRequestOptions.deliveryMode = .fastFormat;
        imageRequestOptions.resizeMode = .fast;
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.isSynchronous = false
        
        let videoRequestOptions = PHVideoRequestOptions.init()
        videoRequestOptions.version = PHVideoRequestOptionsVersion.current
        videoRequestOptions.deliveryMode = PHVideoRequestOptionsDeliveryMode.automatic
        videoRequestOptions.isNetworkAccessAllowed = true
        
        //add loading view
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        if #available(iOS 13.0, *) {
            loadingIndicator.color = .secondaryLabel
        } else {
            loadingIndicator.color = .black
        }
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.getTopMostViewController()?.present(alert, animated: true, completion: {
            let group = DispatchGroup()
            for TLAsset in withTLPHAssets {
                group.enter()
                let asset = TLAsset.phAsset
                let index = TLAsset.selectedOrder - 1;
                
                TLAsset.tempCopyMediaFile(videoRequestOptions: videoRequestOptions, imageRequestOptions: imageRequestOptions, livePhotoRequestOptions: nil, exportPreset: AVAssetExportPresetHighestQuality, convertLivePhotosToJPG: true, progressBlock: { (progress) in
                    print("progress: ", progress)
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
            group.notify(queue: .main){ [self] in
                resolve(selections);
                DispatchQueue.main.async {
                    alert.dismiss(animated: true, completion: {
                        dismissComplete()
                    })
                }
            }
        })
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    func showExceededMaximumAlert(vc: UIViewController, isVideo: Bool) {
        let alert = UIAlertController(title: self.options["maximumMessageTitle"] as? String, message: self.options[isVideo ? "maximumVideoMessage" : "maximumMessage"] as? String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: self.options["messageTitleButton"] as? String, style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        let maxVideo = self.options["maxVideo"]
        if(phAsset.mediaType == .video){
            
            if(videoCount == maxVideo as! Int && !(options["singleSelectedMode"] as! Bool)){
                showExceededMaximumAlert(vc: self.getTopMostViewController()!, isVideo: true)
                return false
            }
            videoCount += 1
        }
        return true
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
