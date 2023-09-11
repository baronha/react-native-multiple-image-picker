//
//  ViewerPhoto.swift
//  react-native-multiple-image-picker
//
//  Created by BẢO HÀ on 10/09/2023.
//

import TLPhotoPicker
import UIKit

class ViewerPhoto: Viewable {
    var placeholder = UIImage()

    enum Size {
        case small
        case large
    }

    var type: ViewableType = .image
    var id: String
    var url: String?
    var assetID: String?

    init(id: String) {
        self.id = id
    }

    func media(_ completion: @escaping (_ image: UIImage?, _ error: NSError?) -> Void) {
        if let media = TLPHAsset.asset(with: assetID ?? "")?.fullResolutionImage {
            completion(media, nil)
        } else {
            completion(placeholder, nil)
        }
    }
}
