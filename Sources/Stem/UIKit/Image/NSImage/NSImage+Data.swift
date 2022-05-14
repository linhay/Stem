//
//  File.swift
//
//
//  Created by linhey on 2022/5/13.
//

#if canImport(AppKit)
import Foundation
import AppKit

public extension Stem where Base: NSImage {
    
    var bitmapImageRep: NSBitmapImageRep? {
        if let bmp = base.representations.lazy.compactMap({ $0 as? NSBitmapImageRep }).first {
            return bmp
        } else if let data = base.tiffRepresentation, let new = NSBitmapImageRep(data: data) {
            base.addRepresentation(new)
            return new
        } else {
            return nil
        }
    }
    
    func data(using: NSBitmapImageRep.FileType, properties: [NSBitmapImageRep.PropertyKey: Any]) -> Data? {
        return bitmapImageRep?.representation(using: using, properties: properties)
    }
    
}
#endif
