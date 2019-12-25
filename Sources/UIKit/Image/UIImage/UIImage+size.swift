//
//  Stem
//
//  github: https://github.com/linhay/Stem
//  Copyright (c) 2019 linhay - https://github.com/linhay
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

// MARK: - byte(数据尺寸)
public extension Stem where Base: UIImage {
    
    /// 图片尺寸: byte as jpeg
    var byte: Int {
        return base.jpegData(compressionQuality: 1)?.count ?? 0
    }

    /// 图片尺寸: 1 KB | 1MB | 1TB
    var byteString: String {
        return ByteCountFormatter().string(fromByteCount: Int64(byte))
    }

    /// 基于像素的尺寸
    var pixelSize: CGSize {
        return CGSize(width: base.size.width * base.scale, height: base.size.height * base.scale)
    }
    
}

// MARK: - scale(缩放)
public extension Stem where Base: UIImage {

    /// 缩放至指定高度
    ///
    /// - Parameters:
    ///   - toWidth: 高度
    ///   - opaque: 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储
    /// - Returns: 新的图片
    func scale(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / base.size.height
        let newWidth = base.size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
        defer { UIGraphicsEndImageContext() }
        base.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// 缩放至指定宽度
    ///
    /// - Parameters:
    ///   - toWidth: 宽度
    ///   - opaque: 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储
    /// - Returns: 新的图片
    func scale(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / base.size.width
        let newHeight = base.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
        defer { UIGraphicsEndImageContext() }
        base.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}

// MARK: - compress(压缩)
public extension Stem where Base: UIImage {
    
    /// 压缩至指定字节大小
    ///
    /// - Parameters:
    ///   - limit: 字节大小
    ///   - leeway: 精度
    /// - Returns: data
    func compress(withMB limit: Int, leeway: CGFloat = 0.3) -> Data? {
        return compress(withB: limit * 1000)
    }
    
    /// 压缩至指定字节大小
    ///
    /// - Parameters:
    ///   - limit: 字节大小
    ///   - leeway: 精度
    /// - Returns: data
    func compress(withKB limit: Int, leeway: CGFloat = 0.3) -> Data? {
        return compress(withB: limit * 1000 * 1000)
    }
    
    /// 压缩至指定字节大小
    ///
    /// - Parameters:
    ///   - limit: 字节大小
    ///   - leeway: 精度
    /// - Returns: data
    func compress(withB limit: Int, leeway: CGFloat = 0.3) -> Data? {
        var compression: CGFloat = 1
        guard var data = base.jpegData(compressionQuality: compression) else { return nil }
        if data.count <= limit { return data }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        
        while data.count > limit || (max - min) > leeway {
            let mid = (max + min) * 0.5
            compression = mid
            guard let temp = base.jpegData(compressionQuality: compression) else { return nil }
            data = temp
            if temp.count > limit {
                max = mid
            } else {
                min = mid
            }
        }
        
        return data
    }
    
}
