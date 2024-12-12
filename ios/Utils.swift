//
//  Utils.swift
//  Pods
//
//  Created by BAO HA on 11/12/24.
//

import MobileCoreServices

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
