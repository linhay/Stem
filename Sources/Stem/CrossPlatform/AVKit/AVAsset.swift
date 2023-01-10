//
//  File.swift
//  
//
//  Created by linhey on 2022/10/9.
//

#if canImport(UIKit) && canImport(AVKit)
import UIKit
import AVKit

public extension Stem where Base: AVAsset {
    
    /// 获取视频指定时间帧画面
    /// - Parameter seconds: 指定时间
    /// - Returns: 画面
    func frame(seconds: TimeInterval) async throws -> UIImage {
        try await frame(seconds: [seconds]).first!
    }
    
    
    /// 获取视频指定时间帧画面
    /// - Parameter seconds: 指定时间
    /// - Returns: 画面集合, 按传入时间返回
    func frame(seconds: [TimeInterval]) async throws -> [UIImage] {
        let generator = AVAssetImageGenerator(asset: base)
        generator.requestedTimeToleranceBefore = CMTime.zero
        generator.requestedTimeToleranceAfter  = CMTime.zero
        generator.appliesPreferredTrackTransform = true
        
        let duration = base.duration
        let times  = seconds.map({ CMTime(seconds: Double($0), preferredTimescale: duration.timescale) })
        let values = times.map { NSValue(time: $0) }
        
        return try await withCheckedThrowingContinuation({ continuation in
            /**
             requestedTime : 视频时间轴中要为其生成图像的时间。
             image:          为请求的时间生成的图像。
             actualTime:     视频时间线中生成图像的实际时间。请求的时间和实际时间可能会有所不同，具体取决于映像生成器配置，包括其时间容差值。
             result:         指示图像生成请求结果的值。
             error:          可选错误。如果发生错误，系统将提供一个错误对象，该对象提供故障的详细信息。
             */
            
            var packages = [TimeInterval: CGImage]()
            var continuation: CheckedContinuation<[UIImage], Error>? = continuation
            
            generator.generateCGImagesAsynchronously(forTimes: values) { (requestedTime, image, actualTime, result, error) in
                if let error = error {
                    continuation?.resume(throwing: error)
                    continuation = nil
                } else if let image = image {
                    packages[requestedTime.seconds] = image
                    if packages.keys.count == seconds.count {
                        let images = seconds
                            .compactMap({ packages[$0] })
                            .map({ UIImage(cgImage: $0) })
                        continuation?.resume(returning: images)
                        continuation = nil
                    }
                } else {
                    assertionFailure()
                }
            }
        })
    }
    
}
#endif
