//
//  Stem
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import UIKit

#if canImport(UIKit)
import CoreMedia

public extension UIImage{
    /// from CMSampleBuffer
    ///
    /// must import CoreMedia
    /// from: https://stackoverflow.com/questions/15726761/make-an-uiimage-from-a-cmsamplebuffer
    ///
    /// - Parameter sampleBuffer: CMSampleBuffer
    convenience init?(sampleBuffer: CMSampleBuffer) {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        // Create a Quartz image from the pixel data in the bitmap graphics context
        guard let context = CGContext(data: baseAddress,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo),
            let quartzImage = context.makeImage() else { return nil }
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        // Create an image object from the Quartz image
        self.init(cgImage: quartzImage)
    }
    
}

#endif

public extension UIImage{
    
    /// 生成二维码
    convenience init?(qrCode: String) {
        let data = qrCode.data(using: .utf8)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: UIScreen.main.scale, y: UIScreen.main.scale)
        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }
        self.init(ciImage: output)
    }
    
    convenience init?(named: String, in bundle: Bundle) {
        let manager = FileManager.default
        guard let res = manager.enumerator(atPath: bundle.bundlePath)?
            .allObjects
            .compactMap({ (item) -> String? in
                return item as? String
            }).first(where: { (item) -> Bool in
                return item.components(separatedBy: "/").last?.components(separatedBy: ".").first == .some(named)
            }),
            let bundle = Bundle(path: bundle.bundlePath + res)
            else { return nil }
        self.init(named: named, in: bundle, compatibleWith: nil)
    }
    
}

public extension Stem where Base: UIImage {

    /// 叠加图片
    ///
    /// - Parameters:
    ///   - image: 覆盖至上方图片
    ///   - offset: 覆盖图片偏移 正值向下向右
    /// - Returns: 新图
    func overlay(image: UIImage, offset: UIOffset = UIOffset.zero) -> UIImage {
        UIGraphicsBeginImageContext(base.size)
        defer { UIGraphicsEndImageContext() }
        base.draw(in: CGRect(origin: .zero, size: base.size))
        image.draw(in: CGRect(origin: .init(x: offset.horizontal, y: offset.vertical), size: image.size))
        return UIGraphicsGetImageFromCurrentImageContext() ?? base
    }
    
      /// 高斯模糊
      ///
      /// - Parameter value: 0 ~ 100, 0为不模糊
      func blur(value: Double) -> UIImage? {
        let ciImage = CIImage(image: base)
        let filter = CIFilter(blur: .gaussianBlur)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(value, forKey: "inputRadius")
        guard let output = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        let context = CIContext()
        guard let cgImage = context.createCGImage(output, from: output.extent) else { return nil }
        let image = UIImage(cgImage: cgImage)
        return image
      }

}
