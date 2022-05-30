//
//  File.swift
//  
//
//  Created by linhey on 2022/5/29.
//


public extension StemColor {

    enum ImageFilterPixel: Int, CaseIterable {
        /// 白色
        case white
        /// 黑色
        case blank
        /// 透明像素
        case transparent
        
       public func equal(_ color: StemColor) -> Bool {
            switch self {
            case .white:
                return !color.rgbSpace.list(as: Int.self).map({ $0 > 250 }).contains(false)
            case .blank:
                return color.rgbSpace.list(as: Int.self) == [0, 0, 0]
            case .transparent:
                return color.alpha == .zero
            }
        }
    }
    
    static func array(fromRGBAs pixels: [UInt8]) -> [StemColor] {
        let count = pixels.count / 4
        var list = [StemColor]()
        for i in stride(from: 0, to: count, by: 1) {
            let rgb = RGBSpace(red: Double(pixels[i * 4 + 3]) / 255,
                               green: Double(pixels[i * 4 + 2]) / 255,
                               blue: Double(pixels[i * 4 + 1]) / 255)
            list.append(.init(rgb: rgb, alpha: Double(pixels[i * 4]) / 255))
        }
        return list
    }
    
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension StemColor {
    
    static func array(from image: NSImage, filter: ((StemColor) -> Bool)?) -> [StemColor] {
     let colors = array(fromRGBAs: pixels(from: image))
        if let filter = filter {
            return colors.filter(filter)
        } else {
            return colors
        }
    }
    
    static func array(from image: NSImage, filter options: [ImageFilterPixel] = []) -> [StemColor] {
        if options.isEmpty {
            return array(from: image, filter: nil)
        } else {
            return array(from: image) { color in
                for option in options where option.equal(color) {
                    return false
                }
                return true
            }
        }
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
    
    private static func pixels(from image: NSImage) -> [UInt8] {
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
    
    static func array(from image: UIImage, filter: ((StemColor) -> Bool)?) -> [StemColor] {
        guard let image = image.cgImage else {
            return []
        }
        let colors = array(fromRGBAs: pixels(from: image))
        if let filter = filter {
            return colors.filter(filter)
        } else {
            return colors
        }
    }
    
    static func array(from image: UIImage, filter options: [ImageFilterPixel] = []) -> [StemColor] {
        if options.isEmpty {
            return array(from: image, filter: nil)
        } else {
            return array(from: image) { color in
                for option in options where option.equal(color) {
                    return false
                }
                return true
            }
        }
    }
    
}

#endif


#if canImport(CoreGraphics)
import CoreGraphics

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
        let width = image.width
        let height = image.height
        var rawData = [UInt8](repeating: 0, count: width * height * 4)
        guard let context = CGContext(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * width,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
                return []
        }
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
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
