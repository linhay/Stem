//
//  FBPreviewViewController.swift
//  iOS
//
//  Created by linhey on 2022/9/7.
//

#if canImport(QuickLook) && canImport(UIKit)
import UIKit
import QuickLook

class STPreviewController: QLPreviewController {
    
    deinit {
        STFilePreview.shared = nil
    }
    
}

open class STFilePreview: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    
    public static var shared: STFilePreview?
    
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

    public static func show(urls: [URL], selected url: URL?, on controller: UIViewController?) {
        let preview = STFilePreview(urls: urls)
        let index = url.flatMap(urls.firstIndex(of:)) ?? 0
        let previewController = QLPreviewController()
        previewController.delegate = preview
        previewController.dataSource = preview
        previewController.currentPreviewItemIndex = index
        STFilePreview.shared = preview
        controller?.present(previewController, animated: true)
    }
    
}
#endif
