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

extension Array where Array.Element: NSAttributedString {

    /**
     NSAttributedString 拼接

     - Authors: linhey
     - Date: 2019/11/26

     - Example:

     ```

     [NSAttributedString(string: "a"), NSAttributedString(string: "b")].joined(separator: NSAttributedString(string: " : "))

     // Print: a : b

     ```
     */
    public func joined(separator: NSAttributedString? = nil) -> NSMutableAttributedString {
        let temp = NSMutableAttributedString()
        for (index, item) in self.enumerated() {
            temp.append(item)
            if index != self.count - 1, let separator = separator {
                temp.append(separator)
            }
        }
        return temp
    }
}

// MARK: - convenience String
public extension StemValue where Base == String {

    ///  获取富文本类型字符串
    ///
    /// - Parameter attributes: 富文本属性
    /// - Returns: 富文本类型字符串
    func attributes(_ attributes: NSAttributedString.Attribute...) -> NSAttributedString {
        return NSAttributedString(string: base, attributes: attributes)
    }

    ///  获取富文本类型字符串
    ///
    /// - Parameter attributes: 富文本属性
    /// - Returns: 富文本类型字符串
    func attributes(_ attributes: [NSAttributedString.Attribute]) -> NSAttributedString {
        return NSAttributedString(string: base, attributes: attributes)
    }

}

// MARK: - convenience NSMutableAttributedString
public extension Stem where Base: NSAttributedString {

    /**
     创建标签图片

     ```
     大致长这样:
     -------
     | 文字 |
     -------

     ```

     - Authors: linhey
     - Date: 2019/11/26

     - Parameter lineHeight: 文字行高
     - Parameter insets: 上下左右间距
     - Parameter backgroundColor: 背景色
     - Parameter cornerRadius: 圆角
     - Parameter border: 描边

     - Example:

     ```
     let image = NSAttributedString(string: "测试").createTagImage(lineHeight: 20,
                                                                    insets: .zero,
                                                                    backgroundColor: UIColor.white,
                                                                    cornerRadius: 4,
                                                                    border: (width: 1, color: UIColor.red))

     ```

     - Important:

     - # lineHeight: 是文字行高 不是 标签文本高度
     - # insets: 不论咋设置, 文字都将居中显示
     - # 文字偏移: 由于字体差异, 可能需要单独设置 `baselineOffset` 来校正上下偏移
     - Returns: 图片
     */
    func createTagImage(lineHeight: CGFloat,
                        insets: UIEdgeInsets,
                        backgroundColor: UIColor,
                        cornerRadius: CGFloat,
                        border: (width: CGFloat, color: UIColor)? = nil) -> UIImage? {

        let string = NSMutableAttributedString(attributedString: base)

        let textSize = string.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                        height: lineHeight),
                                           options: [.usesLineFragmentOrigin, .usesFontLeading],
                                           context: nil).size

        var insets = insets
        if let border = border {
            insets = UIEdgeInsets(top: insets.top + border.width, left: insets.left + border.width, bottom: insets.bottom + border.width, right: insets.right + border.width)
        }

        let rect = CGRect(origin: .zero, size: CGSize(width: textSize.width + insets.left + insets.right, height: lineHeight + insets.top + insets.bottom))

        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        let bezierPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        bezierPath.addClip()
        backgroundColor.setFill()
        UIRectFill(rect)

        let textRect = CGRect(origin: CGPoint(x: insets.left, y: (rect.height - textSize.height) * 0.5), size: textSize)

        if let border = border {
            bezierPath.lineWidth = border.width
            bezierPath.lineJoinStyle = .miter
            border.color.setStroke()
            bezierPath.stroke()
        }

        string.draw(in: textRect)
        guard UIGraphicsGetCurrentContext() != nil else { return nil }
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}

public extension Stem where Base: NSMutableAttributedString {

    private var paragraphStyle: NSMutableParagraphStyle {
        if base.length > 0, let style = base.attributes(at: 0, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle {
            return style.mutableCopy() as! NSMutableParagraphStyle
        }
        return NSMutableParagraphStyle()
    }

    func setAttributes(_ value: [NSAttributedString.Key: Any]?, range: NSRange?) -> Base {
        base.setAttributes(value, range: range ?? NSRange(location: 0, length: base.length))
        return base
    }

}

// MARK: - NSAttributedString
public extension Stem where Base: NSAttributedString {

    /// 获取字符串的Bounds
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - size: 字符串长宽限制
    ///   - option: option
    /// - Returns: 字符串的Bounds
    func bounds(size: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude,
                                      height: CGFloat.greatestFiniteMagnitude),
                option: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGRect {

        guard base.length != 0 else {
            return CGRect.zero
        }

        let mutableCopy = NSMutableAttributedString(attributedString: base)
        mutableCopy.st.paragraphStyle.lineBreakMode = .byWordWrapping
        return mutableCopy.boundingRect(with: size, options: option, context: nil)
    }

    /// 获取字符串的CGSize
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - size: 字符串长宽限制
    /// - Returns: 字符串的Bounds
    func size(maxWidth width: CGFloat = CGFloat.greatestFiniteMagnitude,
              maxHeight height: CGFloat = CGFloat.greatestFiniteMagnitude,
              option: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGSize {
        return self.bounds(size: CGSize(width: width, height: height), option: option).size
    }

    /// 文本行数
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 最大宽度
    /// - Returns: 行数
    func rows(maxWidth width: CGFloat, lineHeight: CGFloat? = nil) -> Int {
        if base.length == 0 { return 0 }
        // 获取单行时候的内容的高度
        var lineHeight = lineHeight

        if lineHeight != nil {} else {
            lineHeight = self.size().height
        }

        guard let singleLineHeight = lineHeight else {
            return 0
        }

        // 获取多行时候,文字的size
        let textSize = self.size(maxWidth: width)

        // 返回计算的行数
        return Int(ceil(textSize.height / singleLineHeight))
    }
}

// MARK: - convenience init
public extension NSAttributedString {

    /// 初始化函数
    ///
    /// - Parameters:
    ///   - string: 字符串
    ///   - attributes: 富文本属性
    convenience init(string: String, attributes: Attribute...) {
        self.init(string: string, attributes: attributes)
    }

    /// 初始化函数
    ///
    /// - Parameters:
    ///   - string: 字符串
    ///   - attributes: 富文本属性
    convenience init(string: String, attributes: [Attribute]) {
        self.init(string: string, attributes: Attribute.create(from: attributes))
    }

}
#endif
