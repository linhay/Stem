//
//  File.swift
//  
//
//  Created by linhey on 2022/6/7.
//

import Foundation

struct StemColorPixel: Codable, Hashable {
    
    public var red: UInt8 { simd4.x }
    public var green: UInt8 { simd4.y }
    public var blue: UInt8 { simd4.z }
    public var alpha: UInt8 { simd4.w }
    public let simd4: SIMD4<UInt8>

    init(_ simd4: SIMD4<UInt8>) {
        self.simd4 = simd4
    }
    
    public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.simd4 = .init(red, green, blue, alpha)
    }
    
    static func array(from pointer: UnsafeMutablePointer<UInt8>, width: Int, height: Int) -> [StemColorPixel] {
        return simd4s(from: pointer, width: width, height: width).map(StemColorPixel.init)
    }
    
    static func bytes(from pointer: UnsafeMutablePointer<UInt8>, width: Int, height: Int) -> [UInt8] {
        var list = [UInt8](repeating: 0, count: width * height * 4)
        for i in 0 ..< list.count {
            list[i] = pointer.advanced(by: i).pointee
        }
        return list
    }
    
    static func simd4s(from pointer: UnsafeMutablePointer<UInt8>, width: Int, height: Int) -> [SIMD4<UInt8>] {
        var list = [SIMD4<UInt8>]()
        for i in 0 ..< (width * height) {
            let a = pointer.advanced(by: i * 0).pointee
            let r = pointer.advanced(by: i * 1).pointee
            let g = pointer.advanced(by: i * 2).pointee
            let b = pointer.advanced(by: i * 3).pointee
            list.append(.init(r, g, b, a))
        }
        return list
    }
    
}

#if canImport(CoreGraphics) && canImport(Accelerate)
import CoreGraphics
import Accelerate

extension StemColorPixel {
    
    static func pixels(from image: CGImage) -> [SIMD4<UInt8>] {
        guard let format = vImage_CGImageFormat(
                  bitsPerComponent: 8,
                  bitsPerPixel: 32,
                  colorSpace: CGColorSpaceCreateDeviceRGB(),
                  bitmapInfo: [CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                               CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
                               CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)],
                  renderingIntent: .defaultIntent
              ),
              let sourceImageFormat = vImage_CGImageFormat(cgImage: image) else {
            return []
        }
        
        do {
            var sourceBuffer = try vImage_Buffer(cgImage: image)
            defer { sourceBuffer.free() }
            var destinationImageFormatBuffer = try vImage_Buffer(width: image.width,
                                                                 height: image.height,
                                                                 bitsPerPixel: format.bitsPerPixel)
            defer { destinationImageFormatBuffer.free() }
            let imageFormatConverter = try vImageConverter.make(sourceFormat: sourceImageFormat,
                                                                destinationFormat: format)

            try imageFormatConverter.convert(source: sourceBuffer, destination: &destinationImageFormatBuffer)
            let error = vImageScale_ARGB8888(&destinationImageFormatBuffer,
                                             &sourceBuffer,
                                             nil,
                                             vImage_Flags(kvImageHighQualityResampling))
            guard error == kvImageNoError else {
                return []
            }
            
            let capacity = sourceBuffer.rowBytes * Int(sourceBuffer.height)
            let data = sourceBuffer.data.bindMemory(to: UInt8.self, capacity: capacity)
            return StemColorPixel.simd4s(from: data, width: Int(sourceBuffer.width), height: Int(sourceBuffer.height))
        } catch  {
            return []
        }
    }
    
}

#endif
