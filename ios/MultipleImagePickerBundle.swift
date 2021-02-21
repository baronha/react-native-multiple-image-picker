//
//  ImagePickerBundle.swift
//  MultipleImagePicker
//
//  Created by Bảo on 27/01/2021.
//  Copyright © 2021 Facebook. All rights reserved.
//

import UIKit

open class MultipleImagePickerBundle {
    open class func podBundleImage(named: String) -> UIImage? {
        let podBundle = Bundle(for: MultipleImagePickerBundle.self)
        if let url = podBundle.url(forResource: "MultipleImagePicker", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: named, in: bundle, compatibleWith: nil)
        }
        return nil
    }
    
    class func bundle() -> Bundle {
        let podBundle = Bundle(for: MultipleImagePickerBundle.self)
        if let url = podBundle.url(forResource: "MultipleImagePicker", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return bundle ?? podBundle
        }
        return podBundle
    }
}
