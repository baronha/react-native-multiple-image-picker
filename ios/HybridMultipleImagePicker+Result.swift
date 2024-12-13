//
//  HybridMultipleImagePicker+Result.swift
//  Pods
//
//  Created by BAO HA on 24/10/24.
//

import HXPhotoPicker
import Photos

extension HybridMultipleImagePicker {
    func getResult(_ asset: PhotoAsset, _ compression: PhotoAsset.Compression) async throws -> Result {
        let urlResult = try await asset.urlResult()
        let url = urlResult.url
            
        let creationDate = Int(asset.phAsset?.creationDate?.timeIntervalSince1970 ?? 0)
            
        let mime = url.getMimeType()
            
        let fileName = {
            if let phAsset = asset.phAsset, let resources = PHAssetResource.assetResources(for: phAsset).first {
                return resources.originalFilename
            }
                
            return ""
        }()
            
        let type: ResultType = .init(fromString: asset.mediaType == .video ? "video" : "image")!
        let thumbnail = asset.phAsset?.getVideoThumbnail(from: url.absoluteString, in: 1)
            
        return Result(path: url.absoluteString,
                      fileName: fileName,
                      localIdentifier: asset.phAsset!.localIdentifier,
                      width: asset.imageSize.width,
                      height: asset.imageSize.height,
                      mime: mime,
                      size: Double(asset.fileSize),
                      bucketId: nil,
                      realPath: nil,
                      parentFolderName: nil,
                      creationDate: creationDate > 0 ? Double(creationDate) : nil,
                      type: type,
                      duration: asset.videoDuration,
                      thumbnail: thumbnail,
                      crop: false)
    }
}
