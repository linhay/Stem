//
//  File.swift
//
//
//  Created by linhey on 2022/5/29.
//

public extension StemColor {
    
    static func array(fromRGBAs pixels: [UInt8]) -> [StemColor] {
        var list = [StemColor]()
        for i in (0..<pixels.count/4) {
            let rgb = RGBSpace(red: Double(pixels[i * 4 + 3]) / 255,
                               green: Double(pixels[i * 4 + 2]) / 255,
                               blue: Double(pixels[i * 4 + 1]) / 255)
            list.append(.init(rgb: rgb, alpha: Double(pixels[i * 4]) / 255))
        }
        return list
    }
    
    static func array(from image: StemColorImage, filter: ((StemColor) -> Bool)? = nil) -> [StemColor] {
        let colors = array(fromRGBAs: pixels(from: image))
        if let filter = filter {
            return colors.filter(filter)
        } else {
            return colors
        }
    }
    
}

public extension StemColor.RGBSpace.Unpack where T == UInt8 {
    
    static func array(fromRGBAs pixels: [UInt8], filter: ((_ rgb: StemColor.RGBSpace.Unpack<UInt8>, _ alpha: UInt8) -> Bool)? = nil) -> [StemColor.RGBSpace.Unpack<UInt8>] {
        var list = [StemColor.RGBSpace.Unpack<UInt8>]()
        for i in (0..<(pixels.count / 4)) {
            let rgb = StemColor.RGBSpace.Unpack<UInt8>(red: pixels[i * 4 + 3], green: pixels[i * 4 + 2], blue: pixels[i * 4 + 1])
            if let filter = filter, !filter(rgb, pixels[i * 4]) {
                continue
            }
            list.append(rgb)
        }
        return list
    }
    
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension StemColor {
    
    static func array(from image: NSImage) -> [StemColor] {
        return array(from: image, filter: nil)
    }
    
    private static func bitmapImageRep(_ image: NSImage) -> NSBitmapImageRep? {
        if let bmp = image.representations.lazy.compactMap({ $0 as? NSBitmapImageRep }).first {
            return bmp
        } else if let data = image.tiffRepresentation, let new = NSBitmapImageRep(data: data) {
            return new
        } else {
            return nil
        }
    }
    
    static func pixels(from image: NSImage) -> [UInt8] {
        guard let bmp = bitmapImageRep(image), let buffer = bmp.bitmapData else {
            return []
        }
        
        return Array(UnsafeBufferPointer(start: buffer, count: bmp.pixelsWide * bmp.pixelsHigh * 4))
    }
    
}
#endif

#if canImport(UIKit)
import UIKit

public extension StemColor {
    
    static func pixels(from image: UIImage) -> [UInt8] {
        return image.cgImage.map(pixels(from:)) ?? []
    }
    
}

#endif


#if canImport(CoreGraphics)
import CoreGraphics
import SwiftUI

fileprivate extension StemColor {
    
    static func pixels(from image: CGImage) -> [UInt8] {
        if isCompatibleImage(image) {
            return makeBytesFromCompatibleImage(image)
        } else {
            return makeBytesFromIncompatibleImage(image)
        }
    }
    
    static func makeBytesFromCompatibleImage(_ image: CGImage) -> [UInt8] {
        guard let dataProvider = image.dataProvider else {
            return []
        }
        guard let data = dataProvider.data else {
            return []
        }
        let length = CFDataGetLength(data)
        var rawData = [UInt8](repeating: 0, count: length)
        CFDataGetBytes(data, CFRange(location: 0, length: length), &rawData)
        return rawData
    }

    static func makeBytesFromIncompatibleImage(_ image: CGImage) -> [UInt8] {
        var rawData = [UInt8](repeating: 0, count: image.width * image.height * 4)
        guard let context = CGContext(
            data: &rawData,
            width: image.width,
            height: image.height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * image.width,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
            return []
        }
        context.draw(image, in: .init(origin: .zero, size: .init(width: image.width, height: image.height)))
        return rawData
    }
    
    static func isCompatibleImage(_ cgImage: CGImage) -> Bool {
        guard let colorSpace = cgImage.colorSpace else {
            return false
        }
        if colorSpace.model != .rgb {
            return false
        }
        let bitmapInfo = cgImage.bitmapInfo
        let alpha = bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        let alphaRequirement = (alpha == CGImageAlphaInfo.noneSkipLast.rawValue || alpha == CGImageAlphaInfo.last.rawValue)
        let byteOrder = bitmapInfo.rawValue & CGBitmapInfo.byteOrderMask.rawValue
        let byteOrderRequirement = (byteOrder == CGBitmapInfo.byteOrder32Little.rawValue)
        if !(alphaRequirement && byteOrderRequirement) {
            return false
        }
        if cgImage.bitsPerComponent != 8 {
            return false
        }
        if cgImage.bitsPerPixel != 32 {
            return false
        }
        if cgImage.bytesPerRow != cgImage.width * 4 {
            return false
        }
        return true
    }
    
}

#endif
