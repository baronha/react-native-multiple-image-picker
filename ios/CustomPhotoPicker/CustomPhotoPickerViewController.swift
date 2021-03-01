//
//  CustomPhotoPickerViewController.swift
//  MultipleImagePicker
//
//  Created by Bảo on 17/01/2021.
//  Copyright © 2021 Facebook. All rights reserved.
//

import Foundation
import TLPhotoPicker

class CustomPhotoPickerViewController: TLPhotosPickerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func maxCheck() -> Bool {
        let imageCount = self.selectedAssets.filter{ $0.phAsset?.mediaType == .image }.count
        let videoCount = self.selectedAssets.filter{ $0.phAsset?.mediaType == .video }.count
        return false
    }
}
