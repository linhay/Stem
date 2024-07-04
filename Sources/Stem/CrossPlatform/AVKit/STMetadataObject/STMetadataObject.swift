//
//  File.swift
//  
//
//  Created by linhey on 2024/7/4.
//

#if canImport(AVFoundation)
import Foundation
import AVFoundation

public class STMetadataObject {
    public var time: CMTime
    public var duration: CMTime
    public var bounds: CGRect
    public var type: AVMetadataObject.ObjectType
    
    public init(time: CMTime,
                duration: CMTime,
                bounds: CGRect,
                type: AVMetadataObject.ObjectType) {
        self.time = time
        self.duration = duration
        self.bounds = bounds
        self.type = type
    }
    // 辅助方法来将角点坐标转换为视频预览层的坐标
    public func layerRectConverted(using previewLayer: AVCaptureVideoPreviewLayer) -> CGRect {
        previewLayer.layerRectConverted(fromMetadataOutputRect: self.bounds)
    }
}
#endif
