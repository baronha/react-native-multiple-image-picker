//
//  UIColor.swift
//  CocoaAsyncSocket
//
//  Created by BẢO HÀ on 12/09/2023.
//

import UIKit

extension UIImage {
    func setTintColor(_ color: UIColor) -> UIImage? {
        if #available(iOS 13.0, *) {
            return self.withTintColor(color, renderingMode: .alwaysOriginal)
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            // 1
            let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            // 2
            color.setFill()
            UIRectFill(drawRect)
            // 3
            draw(in: drawRect, blendMode: .destinationIn, alpha: 1)

            let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return tintedImage!
        }
    }

    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
