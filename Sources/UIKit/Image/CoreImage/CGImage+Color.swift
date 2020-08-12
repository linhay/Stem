// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CoreImage

extension CGImage: StemCompatible {}

fileprivate struct RGBAPixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8
}

public extension Stem where Base: CGImage {

    func generator(callback: (_ point: CGPoint, _ color: UIColor) -> Void) {
        let width = Int(base.width)
        let height = Int(base.height)
        guard let context = CGContext(data: nil,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width * 4,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).rawValue) else {
        return
       }
        context.draw(base, in: .init(origin: .zero, size: .init(width: width, height: height)))
        let data = unsafeBitCast(context.data, to: UnsafeMutablePointer<RGBAPixel>.self)
        for y in 0 ..< height {
            for x in 0 ..< width {
                let rgba = data[Int(x + y * width)]
                callback(.init(x: x, y: y), UIColor(red: CGFloat(rgba.r) / 255,
                                                    green: CGFloat(rgba.g) / 255,
                                                    blue: CGFloat(rgba.b) / 255,
                                                    alpha: CGFloat(rgba.a) / 255))
            }
        }
    }


}
