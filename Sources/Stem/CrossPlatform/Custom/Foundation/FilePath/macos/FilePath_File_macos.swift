//
//  File.swift
//  
//
//  Created by linhey on 2022/5/13.
//

#if canImport(AppKit)
import Foundation
import AppKit
import SwiftUI

public extension FilePath.File {
    
    struct AssociatedApplication: Identifiable, Equatable, Hashable {
        public var id: URL { url }
        
        public let url: URL
        
        public func icon() -> NSImage {
            NSWorkspace.shared.icon(forFile: url.path)
        }
        
        public func icon() -> Image {
            .init(nsImage: icon())
        }
    }
    
    /// 系统关联 App 列表
    var associatedApplications: [AssociatedApplication] {
        let list = (LSCopyApplicationURLsForURL(url as CFURL, .all)?.takeRetainedValue() as? [URL]) ?? []
        return list.map(AssociatedApplication.init(url:))
    }
    
}
#endif
