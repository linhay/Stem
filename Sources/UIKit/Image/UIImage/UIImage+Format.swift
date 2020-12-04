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

#if canImport(UIKit)
import UIKit

// MARK: - format(格式转换)
public extension Stem where Base: UIImage {

    /// 转换为 png 数据格式
    /// 可能会在 `UIImageWriteToSavedPhotosAlbum` 中使用
    var png: UIImage? {
        guard let data = base.pngData() else {
            return nil
        }
        return UIImage(data: data)
    }

}

// MARK: - AttributedString(富文本)
public extension Stem where Base: UIImage {

    func attributedString(bounds: CGRect) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = base
        attachment.bounds = bounds
        return NSAttributedString(attachment: attachment)
    }

    func mutableAttributedString(bounds: CGRect) -> NSMutableAttributedString {
        self.attributedString(bounds: bounds).mutableCopy() as! NSMutableAttributedString
    }

}
#endif
