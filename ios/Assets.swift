//
//  Assets.swift
//  Pods
//
//  Created by BAO HA on 4/12/24.
//

import UIKit

class Assets {
    class func bundle() -> Bundle {
        let podBundle = Bundle(for: Assets.self)
        if let url = podBundle.url(forResource: "MultipleImagePicker", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return bundle ?? podBundle
        }
        return podBundle
    }
}

extension UIImage {
    static var close = UIImage(name: "close")

    convenience init(name: String) {
        self.init(named: name, in: Assets.bundle(), compatibleWith: nil)!
    }
}
