//
//  PhotoCancelItem.swift
//  Pods
//
//  Created by BAO HA on 4/12/24.
//

import HXPhotoPicker
import UIKit

extension UIView: HXPickerCompatible {
    var size: CGSize {
        get { frame.size }
        set {
            var rect = frame
            rect.size = newValue
            frame = rect
        }
    }
}

public class PhotoCancelItem: UIView, PhotoNavigationItem {
    public weak var itemDelegate: PhotoNavigationItemDelegate?
    public var itemType: PhotoNavigationItemType { .cancel }
    
    let config: PickerConfiguration
    public required init(config: PickerConfiguration) {
        self.config = config
        super.init(frame: .zero)
        initView()
    }
    
    var button: UIButton!
    func initView() {
        button = UIButton(type: .custom)
    
        button.setImage(UIImage.close, for: .normal)
        
        button.addTarget(self, action: #selector(didCancelClick), for: .touchUpInside)
        
        addSubview(button)
        
        if let btnSize = button.currentImage?.size {
            button.size = btnSize
            size = btnSize
        }
    }
    
    @objc
    func didCancelClick() {
        print("close ne")
        itemDelegate?.photoControllerDidCancel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
