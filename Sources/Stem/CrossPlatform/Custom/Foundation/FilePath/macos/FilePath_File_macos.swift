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
        public var bundle: Bundle { .init(path: url.path)! }
        public var name: String {
            if let name = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
                return name
            } else if let name = bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String {
                return name
            } else {
                return url.pathComponents.last ?? url.path
            }
        }
        
        public func icon() -> NSImage {
            NSWorkspace.shared.icon(forFile: url.path)
        }
        
        public func icon() -> Image {
            .init(nsImage: icon())
        }
        
        public func open(_ files: [FilePath.File]) {
            NSWorkspace.shared.open(files.map(\.url), withApplicationAt: url, configuration: NSWorkspace.OpenConfiguration())
        }
    }
    
    func open(with app: AssociatedApplication) {
        app.open([self])
    }
    
    /// 系统关联 App 列表
    var associatedApplications: [AssociatedApplication] {
        let list = (LSCopyApplicationURLsForURL(url as CFURL, .all)?.takeRetainedValue() as? [URL]) ?? []
        return list.map(AssociatedApplication.init(url:))
    }
    
}
#endif
