//
//  ViewerPhoto.swift
//  react-native-multiple-image-picker
//
//  Created by BẢO HÀ on 10/09/2023.
//

import Photos
import TLPhotoPicker
import UIKit

class PreviewItem: Viewable {
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
        if let assetID = assetID {
            if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil).firstObject {
                PreviewItem.image(for: asset) { image in
                    completion(image, nil)
                }
            }
        }
    }

    static func image(for asset: PHAsset, completion: @escaping (_ image: UIImage?) -> Void) {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .opportunistic
        requestOptions.resizeMode = .fast

        let bounds = UIScreen.main.bounds.size
        let targetSize = CGSize(width: bounds.width * 2, height: bounds.height * 2)
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: requestOptions) { image, _ in
            // WARNING: This could fail if your phone doesn't have enough storage. Since the photo is probably
            // stored in iCloud downloading it to your phone will take most of the space left making this feature fail.
            // guard let image = image else { fatalError("Couldn't get photo data for asset \(asset)") }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
