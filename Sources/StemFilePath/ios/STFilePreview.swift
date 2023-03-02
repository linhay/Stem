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
    
    public var paths: [STFilePathReferenceType]
    
    public init(paths: [STFilePathReferenceType] = []) {
        self.paths = paths
    }
    
    open func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        paths.count
    }
    
    open func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        paths[index].id as QLPreviewItem
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
