//
//  CustomPhotoPickerViewController.swift
//  MultipleImagePicker
//
//  Created by Bảo on 17/01/2021.
//  Copyright © 2021 Facebook. All rights reserved.
//

import Foundation
import TLPhotoPicker
import ImageViewer
import PhotosUI

extension UIImageView: DisplaceableView {}

struct DataItem {
    
    let imageView: UIImageView
    let galleryItem: GalleryItem
}

class CustomPhotoPickerViewController: TLPhotosPickerViewController,  GalleryDisplacedViewsDataSource, GalleryItemsDelegate, GalleryItemsDataSource {
    
    func removeGalleryItem(at index: Int) {
    }
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! Cell
        return index < self.collectionView.numberOfItems(inSection: 0) ? cell.imageView : nil
    }
    
    func itemCount() -> Int {
        //        return self.collectionView.numberOfItems(inSection: 0)
        return 1
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        var galleryItem: GalleryItem!
        let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! Cell
        let UIImageView = getUIImage(asset: cell.asset!);
        
        let group = DispatchGroup()
            group.enter()

        galleryItem = GalleryItem.image { $0(UIImageView) }
        if(cell.asset?.mediaType == .some(.video)){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                let options: PHVideoRequestOptions = PHVideoRequestOptions()
                PHImageManager.default().requestAVAsset(forVideo: cell.asset!, options: options, resultHandler: {(videoAssest: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                    if let urlAsset = videoAssest as? AVURLAsset {
                        print(urlAsset)
                        let localVideoUrl: URL = urlAsset.url as URL
                        galleryItem = GalleryItem.video(fetchPreviewImageBlock: { $0(UIImageView) }, videoURL: localVideoUrl)
                        group.leave()
                    }
                })
            }
        }else{
            group.leave()
        }
        group.wait()

        return galleryItem;
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //longPress
        let longPress = UILongPressGestureRecognizer()
        longPress.addTarget(self, action: #selector(self.handlePress))
        longPress.minimumPressDuration = 0.3
        longPress.allowableMovement = 0.5
        
        self.collectionView.addGestureRecognizer(longPress)
    }
    override func makeUI() {
        super.makeUI()
        self.customNavItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: nil, action: #selector(customAction))
        self.customNavItem.rightBarButtonItem?.tintColor = MultipleImagePickerConfigure.selectedColor
    }
    
    
    @objc func customAction() {
        self.delegate?.photoPickerDidCancel()
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.dismissComplete()
            self?.dismissCompletion?()
        }
    }
    
    
    
    func galleryConfiguration() -> GalleryConfiguration {
        return [
            .closeButtonMode(.builtIn),
            .seeAllCloseButtonMode(.none),
            .deleteButtonMode(.none),
            .headerViewLayout(.pinRight(.zero, .zero)),
            .activityViewByLongPress(false),
            .statusBarHidden(false),
            .thumbnailsButtonMode(.none),
        ]
    }
    
    @objc func handlePress(gesture : UIGestureRecognizer!) {
//        if gesture.state != .ended {
//            return
//        }
        if(gesture.state == .began){
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            let p = gesture.location(in: self.collectionView)
            if let indexPath = self.collectionView.indexPathForItem(at: p) {
                let cell = collectionView.cellForItem(at: indexPath) as? Cell;
                if(!cell!.isCameraCell){
                    let galleryViewController = GalleryViewController(startIndex: indexPath.row, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: self, configuration: galleryConfiguration())
                    galleryViewController.dataSource = nil
                    self.presentImageGallery(galleryViewController)
                }
                
            } else {
                print("couldn't find index path")
            }
        }
    }
    
    var is3DTouchAvailable: Bool {
            return view.traitCollection.forceTouchCapability == .available
      }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            guard is3DTouchAvailable, self.collectionView.frame.contains(touch.location(in: view)) else { return }
            
            let maximumForce = touch.maximumPossibleForce
            let force = touch.force
            let normalizedForce = (force / maximumForce) + 1.0;
            
            let animation = CGAffineTransform(scaleX: normalizedForce, y: normalizedForce)
            self.collectionView.transform = animation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesEnded(touches, with: event)
        self.collectionView.transform = CGAffineTransform.identity
   }
           
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
