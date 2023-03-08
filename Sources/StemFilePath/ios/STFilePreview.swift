//
//  FBPreviewViewController.swift
//  iOS
//
//  Created by linhey on 2022/9/7.
//

#if canImport(QuickLook) && canImport(UIKit)
import UIKit
import QuickLook

open class STFilePreview: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    
    public var urls: [URL]
    
    public init(urls: [URL] = []) {
        self.urls = urls
    }
    
    open func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        urls.count
    }
    
    open func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        urls[index] as QLPreviewItem
    }

    open func controller(url: URL?) -> QLPreviewController {
        let index = url.flatMap(urls.firstIndex(of:)) ?? 0
        return controller(index: index)
    }
    
    open func controller(index: Int = 0) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.delegate = self
        controller.dataSource = self
        controller.currentPreviewItemIndex = index
        return controller
    }
    
}
#endif
