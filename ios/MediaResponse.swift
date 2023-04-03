//
//  MediaResponse.swift
//  react-native-multiple-image-picker
//
//  Created by Donquijote on 02/04/2023.
//

import TLPhotoPicker
import Photos
import Foundation

public struct MediaResponse {
    
    public enum MediaType: String {
        case image, video
    }

    public var data: NSMutableDictionary? = nil
    
    
    init(filePath: String?, mime: String?, withTLAsset TLAsset: TLPHAsset, isExportThumbnail: Bool = false) {
        
        let asset = TLAsset.phAsset
        
        if(asset != nil){
            var media = [
                "path": filePath! as String,
                "localIdentifier": asset?.localIdentifier ?? "" as String,
                "fileName":TLAsset.originalFileName!,
                "width": Int(asset?.pixelWidth ?? 0 ) as NSNumber,
                "height": Int(asset?.pixelHeight ?? 0 ) as NSNumber,
                "mime": mime!,
                "creationDate": asset?.creationDate ?? "",
                "type": asset?.mediaType == .video ? "video" : "image",
            ] as [String : Any]
            
            // check video type
            if(asset?.mediaType == .video){
                //get video's thumbnail
                if(isExportThumbnail){
                    media["thumbnail"] = getThumbnail(from: filePath!, in: 0.1)
                }
                //get video size
                TLAsset.videoSize { size in
                    media["size"] = size
                }
                media["duration"] = asset?.duration
            }else{
                TLAsset.photoSize { photoSize in
                    media["size"] = photoSize
                }
            }
            
            self.data = NSMutableDictionary(dictionary: media)
        }
    }
    
}


func getImagePathFromUIImage(uiImage: UIImage, prefix: String? = "thumb") -> String {
    // save to temp directory
    let tempDirectory = FileManager.default.urls(
        for: .cachesDirectory,
        in: .userDomainMask).map(\.path).last
    
    let data = uiImage.jpegData(compressionQuality: 1.0)
    let fileManager = FileManager.default
    let fullPath = URL(fileURLWithPath: tempDirectory ?? "").appendingPathComponent("\(prefix ?? "thumb")-\(ProcessInfo.processInfo.globallyUniqueString).jpg").path
    
    fileManager.createFile(atPath: fullPath, contents: data, attributes: nil)
    
    return fullPath;
    
}


func getThumbnail(from moviePath: String, in seconds: Double) -> String? {
    let filepath = moviePath.replacingOccurrences(
        of: "file://",
        with: "")
    let vidURL = URL(fileURLWithPath: filepath)
    
    let asset = AVURLAsset(url: vidURL, options: nil)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    
    var _: Error? = nil
    let time = CMTimeMake(value: 1, timescale: 60)
    
    var imgRef: CGImage? = nil
    do {
        imgRef = try generator.copyCGImage(at: time, actualTime: nil)
    } catch _ {
    }
    var thumbnail: UIImage? = nil
    
    if let imgRef = imgRef {
        thumbnail = UIImage(cgImage: imgRef)
    }
    
    let fullPath = getImagePathFromUIImage(uiImage: thumbnail!, prefix: "thumb")

    return fullPath;
    
}
