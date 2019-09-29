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

// MARK: - 文本区域
public extension String {

    /// 解析HTML样式
    ///
    /// https://github.com/Luur/SwiftTips#57-render-html-within-a-uilabel
    ///
    /// - Parameters:
    ///   - fontName: 字体名称
    ///   - fontSize: 字体大小
    ///   - colorHex: 字体颜色
    /// - Returns: 富文本

    @available(iOS, deprecated: 8.0, message:"Use st.htmlAttributedString(font:colorHex:) instead.")
    func htmlAttributedString(with fontName: String, fontSize: CGFloat, colorHex: String) -> NSAttributedString? {
        return self.st.htmlAttributedString(font: UIFont(name: fontName, size: fontSize)!, color: colorHex)
    }

    /// 获取字符串的Bounds
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - size: 字符串长宽限制
    /// - Returns: 字符串的Bounds
    @available(iOS, deprecated: 8.0, message:"Use bounds(attributes:size:option:) instead.")
    func bounds(font: UIFont, size: CGSize) -> CGRect {
        return self.st.bounds(attributes: [NSAttributedString.Attribute.font(font)], size: size)
    }

    /// 获取字符串的Bounds
    ///
    /// - parameter font:    字体大小
    /// - parameter size:    字符串长宽限制
    /// - parameter margins: 头尾间距
    /// - parameter space:   内部间距
    ///
    /// - returns: 字符串的Bounds
    @available(iOS, deprecated: 8.0, message:"Use bounds(attributes:size:option:) instead.")
    func size(with font: UIFont, size: CGSize, margins: CGFloat = 0, space: CGFloat = 0) -> CGSize {
        if self.isEmpty { return CGSize.zero }
        var bound = self.bounds(font: font, size: size)
        let rows = self.rows(font: font, width: size.width)
        bound.size.height += margins * 2
        bound.size.height += space * (rows - 1)
        return bound.size
    }

    /// 文本行数
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 最大宽度
    /// - Returns: 行数
    @available(iOS, deprecated: 8.0, message:"Use st.rows(font:width:) instead.")
    func rows(font: UIFont, width: CGFloat) -> CGFloat {
        return self.st.rows(font: font, width: width)
    }

}
