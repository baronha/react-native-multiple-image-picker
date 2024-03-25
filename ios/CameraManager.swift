//
//  CameraManager.swift
//  react-native-multiple-image-picker
//
//  Created by John on 2024/1/16.
//

import AVFoundation
import UIKit
import Photos
import TLPhotoPicker


protocol CameraManagerDelegate: AnyObject {
    func didSelectPhoto(_ assets: [TLPHAsset])
}


class CameraManager: NSObject {
    
    weak var viewController: UIViewController?
    
    weak var delegate: CameraManagerDelegate?
    
    lazy var customPhotoPickerViewController = {
       let customPhotoPickerViewController = CustomPhotoPickerViewController()
        customPhotoPickerViewController.logDelegate = self
       return customPhotoPickerViewController
    }()
    
    
    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
    }
}

extension CameraManager: TLPhotosPickerLogDelegate {
    func selectedCameraCell(picker: TLPhotoPicker.TLPhotosPickerViewController) {
        debugPrint("++++++++++  selectedCameraCell")
    }
    
    func deselectedPhoto(picker: TLPhotoPicker.TLPhotosPickerViewController, at: Int) {
        debugPrint("++++++++++  deselectedPhoto")
    }
    
    func selectedPhoto(picker: TLPhotoPicker.TLPhotosPickerViewController, at: Int) {
        debugPrint("++++++++++  selectedPhoto \(picker.selectedAssets)")
        self.delegate?.didSelectPhoto(picker.selectedAssets)
    }
    
    func selectedAlbum(picker: TLPhotoPicker.TLPhotosPickerViewController, title: String, at: Int) {
        debugPrint("++++++++++  selectedAlbum")
    }
}


// MARK: - Camera Picker
extension CameraManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     func showCameraIfAuthorized() {
         showCamera()
    }

    private func showCamera() {

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = customPhotoPickerViewController
        viewController?.present(picker, animated: true, completion: nil)
    }
}

/// 获取顶层的控制器
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
