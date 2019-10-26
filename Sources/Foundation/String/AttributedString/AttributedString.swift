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



import Foundation

extension Array where Element == NSAttributedString.Attribute {

    var attributes: [NSAttributedString.Key: Any] {
        return self.reduce([NSAttributedString.Key: Any]()) { (dict, item) -> [NSAttributedString.Key: Any] in
            var dict = dict
            dict[item.rawValue.key] = item.rawValue.value
            return dict
        }
    }

}

// MARK: - convenience [NSAttributedString.Attribute]
extension Dictionary where Key == NSAttributedString.Key {

    var attributes: [NSAttributedString.Attribute] {
        return self.compactMap { return NSAttributedString.Attribute(key: $0.key, value: $0.value) }
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

    /// 获取可变类型富文本
    var toMutable: NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: base)
    }

}

// MARK: - NSAttributedString
public extension Stem where Base: NSAttributedString {

    /// 获取字符串的Bounds
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - size: 字符串长宽限制
    /// - Returns: 字符串的Bounds
    func bounds(size: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude,
                                      height: CGFloat.greatestFiniteMagnitude),
                option: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGRect {
        if base.length == 0 { return CGRect.zero }
        return base.boundingRect(with: size, options: option, context: nil)
    }

    /// 获取字符串的CGSize
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - size: 字符串长宽限制
    /// - Returns: 字符串的Bounds
    func size(size: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude,
                                    height: CGFloat.greatestFiniteMagnitude),
              option: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGSize {
        return self.bounds(size: size, option: option).size
    }

    /// 文本行数
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 最大宽度
    /// - Returns: 行数
    func rows(maxWidth: CGFloat) -> CGFloat {
        if base.length == 0 { return 0 }
        // 获取单行时候的内容的size
        let singleSize = self.size()
        // 获取多行时候,文字的size
        let textSize = self.size(size: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        // 返回计算的行数
        return ceil(textSize.height / singleSize.height)
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
        self.init(string: string, attributes: attributes.attributes)
    }

    /// 初始化函数
    ///
    /// - Parameters:
    ///   - string: 字符串
    ///   - attributes: 富文本属性
    convenience init(string: String, attributes: [Attribute]) {
        self.init(string: string, attributes: attributes.attributes)
    }

}
