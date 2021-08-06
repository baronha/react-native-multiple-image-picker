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
        self.collectionView.backgroundColor = .white
        self.customNavItem.leftBarButtonItem?.tintColor = .black
        self.customNavItem.rightBarButtonItem?.tintColor = MultipleImagePickerConfigure.selectedColor
        
        for subview in self.view.subviews {
            guard let navbar = subview as? UINavigationBar else {
                break
            }
            if #available(iOS 13.0, *) {
                navbar.barTintColor = .systemBackground
            } else {
                navbar.barTintColor = UIColor.white
            }
        }
        
        if #available(iOS 13.0, *) {
            self.customNavItem.leftBarButtonItem?.tintColor = .label
            self.collectionView.backgroundColor = .systemBackground
            self.view.backgroundColor = .systemBackground
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
