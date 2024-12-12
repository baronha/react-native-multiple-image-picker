//
//  Utils.swift
//  Pods
//
//  Created by BAO HA on 11/12/24.
//

import MobileCoreServices
import UniformTypeIdentifiers

func isImage(_ urlString: String) -> Bool {
    guard let url = URL(string: urlString),
          let pathExtension = url.pathExtension as CFString?,
          let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, nil)?
          .takeRetainedValue()
    else {
        return false
    }

    return UTTypeConformsTo(uti, kUTTypeImage)
}

func isGifFile(_ url: URL) -> Bool {
    // Kiểm tra phần mở rộng
    if url.pathExtension.lowercased() == "gif" {
        return true
    }

    // Kiểm tra UTI
    let fileExtension = url.pathExtension as CFString
    guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil)?.takeRetainedValue() else {
        return false
    }

    return UTTypeConformsTo(uti, kUTTypeGIF)
}
