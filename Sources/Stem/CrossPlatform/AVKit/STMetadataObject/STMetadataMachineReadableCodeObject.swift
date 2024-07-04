//
//  File.swift
//  
//
//  Created by linhey on 2024/7/4.
//

#if canImport(AVFoundation)
import Foundation
import AVFoundation
import CoreImage

public class STMetadataMachineReadableCodeObject: STMetadataObject {
    
    public var stringValue: String?

    // 从 AVMetadataMachineReadableCodeObject 创建
    public init(from metadataObject: AVMetadataMachineReadableCodeObject) {
        if let value = metadataObject.stringValue {
            self.stringValue = String(value)
        } else {
            self.stringValue = nil
        }
        super.init(time: metadataObject.time,
                   duration: metadataObject.duration,
                   bounds: metadataObject.bounds,
                   type: metadataObject.type)
    }
    
    public init(from feature: CIQRCodeFeature) {
        if let value = feature.messageString {
            self.stringValue = String(value)
        } else {
            self.stringValue = nil
        }
        super.init(time: .zero,
                  duration: .zero,
                  bounds: feature.bounds,
                  type: .qr)
    }
}

#endif
