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
        self.customNavItem.leftBarButtonItem?.tintColor = .black
        self.customNavItem.rightBarButtonItem?.tintColor = MultipleImagePickerConfigure.selectedColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
