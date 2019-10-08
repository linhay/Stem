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

#if canImport(UIKit) && canImport(CoreMedia)
import UIKit
import CoreMedia

public extension UIImage {
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

#if canImport(UIKit) && canImport(AVKit)
import UIKit
import AVKit

extension Stem where Base: UIImage {

    func frame(asset: AVAsset, seconds: [TimeInterval], _ handle: @escaping (UIImage) -> Void) {
        let generator = AVAssetImageGenerator(asset: asset)
        generator.requestedTimeToleranceBefore = CMTime.zero
        generator.requestedTimeToleranceAfter  = CMTime.zero

        let duration = asset.duration
        let times  = seconds.map({ CMTime(seconds: Double($0), preferredTimescale: duration.timescale) })
        let values = times.map { NSValue(time: $0) }

        generator.generateCGImagesAsynchronously(forTimes: values) { (_, cgImage, _, _, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            if let cgImage = cgImage {
                DispatchQueue.main.async { handle(UIImage(cgImage: cgImage)) }
            }
        }
    }

}
#endif
