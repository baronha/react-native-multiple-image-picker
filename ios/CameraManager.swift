//
//  CameraManager.swift
//  react-native-multiple-image-picker
//
//  Created by John on 2024/1/16.
//

import AVFoundation
import UIKit

protocol CameraManagerDelegate: AnyObject {
    func didSelectImage(_ path: String)
    
    func handleUnauthorizedCameraAccess()
}


class CameraManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var viewController: UIViewController?
    
    weak var delegate: CameraManagerDelegate?
    
    
    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
    }
    
    func openCamera() {
        // 检查设备是否支持相机
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // 检查相机权限
            AVCaptureDevice.requestAccess(for: .video) { [weak self] (granted) in
                if granted {
                    // 在主线程中打开相机
                    DispatchQueue.main.async {
                        debugPrint("++++++++++ \(self)")
                        self?.showImagePicker(sourceType: .camera)
                    }
                } else {
                    // 用户未授权相机访问，您可以采取适当的措施，例如显示警告
                    self?.delegate?.handleUnauthorizedCameraAccess()
                    debugPrint("++++++++++ 用户未授权相机访问")
                }
            }
        } else {
            // 设备不支持相机，您可以采取适当的措施，例如显示警告
            delegate?.handleUnauthorizedCameraAccess()
            debugPrint("++++++++++ 设备不支持相机")
        }
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        self.viewController?.present(imagePicker, animated: true, completion: nil)
    }
    
    // 实现UIImagePickerControllerDelegate协议的方法，处理从相机选择的照片或视频
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 处理选择的媒体
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return  }
        let uniqueFilename = UUID().uuidString + ".jpg"
        let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(uniqueFilename)
        guard let imageData = image.jpegData(compressionQuality: 0.4 ) else { return}
        do {
            try imageData.write(to: tmpURL)
            debugPrint("++++++++++ 图像已写入到tmp目录：\(tmpURL)")
        } catch {
            debugPrint("++++++++++ 写入图像到tmp目录失败：\(error.localizedDescription)")
        }
        delegate?.didSelectImage(tmpURL.path)
        // 关闭相机界面
        picker.dismiss(animated: true, completion: nil)
    }
}



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
