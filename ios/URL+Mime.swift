//
//  URL+Mime.swift
//  Pods
//
//  Created by BAO HA on 23/10/24.
//

import Foundation
import MobileCoreServices
import UniformTypeIdentifiers

extension URL {
    func getMimeType() -> String {
        let pathExtension = self.pathExtension.lowercased()

        if #available(iOS 14.0, *) {
            // Sử dụng UniformTypeIdentifiers (UTType) cho iOS 14+
            if let utType = UTType(filenameExtension: pathExtension) {
                return utType.preferredMIMEType ?? "application/octet-stream"
            }

        } else {
            // Sử dụng MobileCoreServices (kUTType) cho iOS 13 trở xuống
            if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
               let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
            {
                return mimeType as String
            }
        }

        // Trả về MIME type mặc định nếu không tìm thấy
        return "application/octet-stream"
    }
}
