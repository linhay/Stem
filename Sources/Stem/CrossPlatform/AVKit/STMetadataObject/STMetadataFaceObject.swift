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

public class STMetadataFaceObject : STMetadataObject {
    public var faceID: Int
    public var hasRollAngle: Bool
    public var rollAngle: CGFloat
    public var hasYawAngle: Bool
    public var yawAngle: CGFloat
    
    init(from object: AVMetadataFaceObject) {
        self.faceID = object.faceID
        self.hasRollAngle = object.hasRollAngle
        self.rollAngle = object.rollAngle
        self.hasYawAngle = object.hasYawAngle
        self.yawAngle = object.yawAngle
        super.init(time: object.time,
                   duration: object.duration,
                   bounds: object.bounds,
                   type: object.type)
    }
}

#endif
