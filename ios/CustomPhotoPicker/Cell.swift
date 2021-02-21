//
//  Cell.swift
//  MultipleImagePicker
//
//  Created by Bảo on 27/01/2021.
//  Copyright © 2021 Facebook. All rights reserved.
//

import Foundation
import TLPhotoPicker
import PhotosUI

class Cell: TLPhotoCollectionViewCell {
        
    var configure = MultipleImagePickerConfigure
    
    override var duration: TimeInterval? {
        didSet {
            self.durationLabel?.isHidden = self.duration == nil ? true : false
            guard let duration = self.duration else { return }
            self.durationLabel?.text = timeFormatted(timeInterval: duration)
        }
    }
    
    override var isCameraCell: Bool {
        didSet {
            self.orderLabel?.isHidden = self.isCameraCell
            self.durationLabel?.isHidden = self.isCameraCell
        }
    }

    override public var selectedAsset: Bool {
        willSet(newValue) {
            self.orderLabel?.backgroundColor = newValue ? self.configure.selectedColor : UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.playerView?.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.durationView?.backgroundColor = UIColor.clear
        self.orderLabel?.clipsToBounds = true
        self.orderLabel?.layer.cornerRadius = 12
        self.orderLabel?.layer.borderWidth = 2
        self.orderLabel?.layer.borderColor = UIColor.white.cgColor
        self.videoIconImageView?.image = self.configure.videoIcon
        if #available(iOS 11.0, *) {
            self.imageView?.accessibilityIgnoresInvertColors = true
            self.playerView?.accessibilityIgnoresInvertColors = true
            self.livePhotoView?.accessibilityIgnoresInvertColors = true
            self.videoIconImageView?.accessibilityIgnoresInvertColors = true
        }
    }
    
}
