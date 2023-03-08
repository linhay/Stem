//
//  File.swift
//  
//
//  Created by linhey on 2023/3/8.
//

#if canImport(CoreImage) && canImport(CoreServices) && canImport(ImageIO)
import CoreImage
import CoreServices
import ImageIO

public enum STCGImageDestination {
    
    public enum ImageProperties {
        
        /// 图像方向属性，值为整数 1 到 8 之间的任何一个
        case orientation(Int)
        
        /// 图像分辨率，单位为点每英寸（dpi），值为 Double 类型
        case dpi(width: Double, height: Double)
        
        /// TIFF 文件格式的图像属性
        case tiff(properties: [CFString: Any])
        
        /// PNG 文件格式的图像属性
        case png(properties: [CFString: Any])
        
        /// 图像压缩质量，值为 Double 类型，范围在 0 到 1 之间
        case lossyCompressionQuality(Double)
        
        /// 图像背景颜色，值为 CGColorRef 类型
        case backgroundColor(CGColor)
        
        /// GIF 文件格式的图像属性
        case gif(properties: [CFString: Any])
        
        /// EXIF 文件格式的图像属性
        case exif(properties: [CFString: Any])
        
        /// GPS 位置信息相关的图像属性
        case gps(properties: [CFString: Any])
        
        /// 由 Apple 制造的相机相关的图像属性
        case makerApple(properties: [CFString: Any])
        
        /// 文件内容相关的图像属性
        case fileContents(properties: [CFString: Any])
        
        /// IPTC 文件格式的图像属性
        case iptc(properties: [CFString: Any])
        
        var key: CFString {
            switch self {
            case .orientation:             return kCGImagePropertyOrientation
            case .dpi:                     return kCGImagePropertyDPIWidth
            case .tiff:                    return kCGImagePropertyTIFFDictionary
            case .png:                     return kCGImagePropertyPNGDictionary
            case .lossyCompressionQuality: return kCGImageDestinationLossyCompressionQuality
            case .backgroundColor:         return kCGImageDestinationBackgroundColor
            case .gif:                     return kCGImagePropertyGIFDictionary
            case .exif:                    return kCGImagePropertyExifDictionary
            case .gps:                     return kCGImagePropertyGPSDictionary
            case .makerApple:              return kCGImagePropertyMakerAppleDictionary
            case .fileContents:            return kCGImagePropertyFileContentsDictionary
            case .iptc:                    return kCGImagePropertyIPTCDictionary
            }
        }
        
        var value: CFTypeRef {
            switch self {
            case .orientation(let value):             return value as CFTypeRef
            case .dpi(let width, let height):         return [kCGImagePropertyDPIWidth: width, kCGImagePropertyDPIHeight: height] as CFDictionary
            case .tiff(let properties):               return properties as CFDictionary
            case .png(let properties):                return properties as CFDictionary
            case .lossyCompressionQuality(let value): return value as CFTypeRef
            case .backgroundColor(let color):         return color as CGColor
            case .gif(let properties):                return properties as CFDictionary
            case .exif(let properties):               return properties as CFDictionary
            case .gps(let properties):                return properties as CFDictionary
            case .makerApple(let properties):         return properties as CFDictionary
            case .fileContents(let properties):       return properties as CFDictionary
            case .iptc(let properties):               return properties as CFDictionary
            }
        }
    }

    public enum ImageType {
        
        case jpeg
        case gif
        case tiff
        case png
        case bmp
        case ico
        case rawImage
        
        var utType: CFString {
            switch self {
            case .jpeg:      return kUTTypeJPEG
            case .gif:       return kUTTypeGIF
            case .tiff:      return kUTTypeTIFF
            case .png:       return kUTTypePNG
            case .bmp:       return kUTTypeBMP
            case .ico:       return kUTTypeICO
            case .rawImage:  return kUTTypeRawImage
            }
        }
    }
    
}

public extension Stem where Base: CGImage {
    
    // 压缩图片并返回压缩后的图像数据
    func data(options: [STCGImageDestination.ImageProperties], type: STCGImageDestination.ImageType) -> Data? {
        let data = NSMutableData()
        // 创建 CGImageDestination 对象
        guard let destination = CGImageDestinationCreateWithData(data as CFMutableData,
                                                                 type.utType, 1,
                                                                 nil) else {
            return nil
        }
        // 将 CGImage 添加到 CGImageDestination 中
        let options = Dictionary(uniqueKeysWithValues: options.map { ($0.key, $0.value) })
        CGImageDestinationAddImage(destination, base, options as CFDictionary)
        // 完成图像的压缩
        CGImageDestinationFinalize(destination)
        // 返回压缩后的图像数据
        return data as Data
    }
    
}
#endif
