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

fileprivate struct STRGBAPixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8
}

private extension Stem where Base: CGImage {

    func pixelsPointer() -> UnsafeMutablePointer<STRGBAPixel>? {
        let width = Int(base.width)
        let height = Int(base.height)
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).rawValue) else {
            return nil
        }
        context.draw(base, in: .init(origin: .zero, size: .init(width: width, height: height)))
        return unsafeBitCast(context.data, to: UnsafeMutablePointer<STRGBAPixel>.self)
    }
    
}

public extension Stem where Base: CGImage {
    
    /// 获取全部像素的颜色
    /// - Parameter points: 点位
    /// - Returns: 颜色集合
    func colorCountedSet() -> [StemColor: Int] {
        var result = [StemColor: Int]()
        pixels().flatMap({ $0 }).forEach { color in
            if result[color] == nil {
                result[color] = 1
            } else {
                result[color] = result[color]! + 1
            }
        }
        return result
    }
    
    /// 获取某几个点位像素的颜色
    /// - Parameter points: 点位
    /// - Returns: 颜色集合
    func pixels(at points: [(x: Int, y: Int)]) -> [StemColor] {
        guard let data = pixelsPointer() else { return [] }
        let width = Int(base.width)
        var row   = [StemColor]()
        
        for point in points {
            let rgba = data[point.x + point.y * width]
            row.append(.init(rgb: .init([rgba.r, rgba.g, rgba.b].map({ Double($0) / 255 })), alpha: Double(rgba.a) / 255))
        }
        
        return row
    }
    
    /// 获取某全部点位像素的颜色
    /// - Parameter points: 点位
    /// - Returns: 颜色集合
    func pixels() -> [[StemColor]] {
        guard let data = pixelsPointer() else { return [] }
        
        let width = Int(base.width)
        var rows  = [[StemColor]]()
        
        for y in 0 ..< Int(base.height) {
            var row = [StemColor]()
            for x in 0 ..< width {
                let rgba = data[Int(x + y * width)]
                row.append(.init(rgb: .init([rgba.r, rgba.g, rgba.b].map({ Double($0) / 255 })), alpha: Double(rgba.a) / 255))
            }
            rows.append(row)
        }
        
        return rows
    }
}
