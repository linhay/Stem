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

extension Array where Element == NSAttributedString.Attribute {
    
    var attributes: [NSAttributedString.Key: Any] {
        return self.reduce([NSAttributedString.Key: Any]()) { (dict, item) -> [NSAttributedString.Key: Any] in
            var dict = dict
            dict[item.rawValue.key] = item.rawValue.value
            return dict
        }
    }
    
}

public extension Stem where Base: NSAttributedString {
    
    /// 获取可变类型富文本
    var toMutable: NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: base)
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

public extension NSAttributedString {
    
    /// 富文本属性
    ///
    /// - font: 字体, [default: Helvetica(Neue) 12]
    /// - paragraphStyle: 段落属性, [default: NSParagraphStyle.default]
    /// - foregroundColor: 文本前景颜色 [default: blackColor]
    /// - backgroundColor: 文本背景颜色 [default nil]
    /// - ligature: 连体属性
    /// - kern: 字距，负值间距变窄，正值间距变宽
    /// - strikethroughStyle: 删除线样式
    /// - strikethroughColor: 删除线颜色
    /// - underlineColor: 下划线颜色
    /// - underlineStyle: 下划线样式
    /// - strokeColor: 笔刷颜色
    /// - strokeWidth: 笔刷样式
    /// - shadow: 阴影 [default: nil]
    /// - verticalGlyphForm: 文字排版方向
    /// - textEffect: 文本特殊效果
    /// - attachment: 文本附件
    /// - link: 超链接
    /// - baselineOffset: 基线偏移值 正值上偏，负值下偏 [default: 0]
    /// - obliqueness: 设置字体倾斜度，正值右倾，负值左倾
    /// - expansion: 字体的横向拉伸，正值拉伸，负值压缩
    /// - writingDirection: 文字的书写方向
    enum Attribute {
        case font(_ : UIFont)
        case paragraphStyle(_: NSParagraphStyle)
        case foregroundColor(_: UIColor)
        case backgroundColor(_: UIColor)
        case ligature(_: AttributeLigatureType)
        case kern(_: CGFloat)
        case strikethroughStyle(_: NSUnderlineStyle)
        case strikethroughColor(_: UIColor)
        case underlineColor(_: UIColor)
        case underlineStyle(_: NSUnderlineStyle)
        case strokeColor(_: UIColor)
        case strokeWidth(_: CGFloat)
        case shadow(_: NSShadow)
        case verticalGlyphForm(_: VerticalGlyphFormStyle)
        case textEffect(_: TextEffectStyle)
        case attachment(_: NSTextAttachment)
        case link(_: Any)
        case baselineOffset(_: CGFloat)
        case obliqueness(_: CGFloat)
        case expansion(_: CGFloat)
        case writingDirection(_: [NSWritingDirection])
        
        var rawValue: (key: NSAttributedString.Key, value: Any?) {
            switch self {
            case .font(let value):                return (NSAttributedString.Key.font, value)
            case .paragraphStyle(let value):      return (NSAttributedString.Key.paragraphStyle, value)
            case .foregroundColor(let value):     return (NSAttributedString.Key.foregroundColor, value)
            case .backgroundColor(let value):     return (NSAttributedString.Key.backgroundColor, value)
            case .ligature(let value):            return (NSAttributedString.Key.ligature, value)
            case .kern(let value):                return (NSAttributedString.Key.kern, value)
            case .strikethroughStyle(let value):  return (NSAttributedString.Key.strikethroughStyle, value)
            case .strikethroughColor(let value):  return (NSAttributedString.Key.strikethroughColor, value)
            case .underlineColor(let value):      return (NSAttributedString.Key.underlineColor, value)
            case .underlineStyle(let value):      return (NSAttributedString.Key.underlineStyle, value)
            case .strokeColor(let value):         return (NSAttributedString.Key.strokeColor, value)
            case .strokeWidth(let value):         return (NSAttributedString.Key.strokeWidth, value)
            case .shadow(let value):              return (NSAttributedString.Key.shadow, value)
            case .verticalGlyphForm(let value):   return (NSAttributedString.Key.verticalGlyphForm, value)
            case .textEffect(let value):          return (NSAttributedString.Key.textEffect, value)
            case .attachment(let value):          return (NSAttributedString.Key.attachment, value)
            case .link(let value):                return (NSAttributedString.Key.link, value)
            case .baselineOffset(let value):      return (NSAttributedString.Key.baselineOffset, value)
            case .obliqueness(let value):         return (NSAttributedString.Key.obliqueness, value)
            case .expansion(let value):           return (NSAttributedString.Key.expansion, value)
            case .writingDirection(let value):    return (NSAttributedString.Key.writingDirection, value)
            }
        }
    }
    
    /// 文字排版方向
    ///
    /// - horizontal: 横排文本 [default]
    /// - vertical: 竖排文本 [iOS 不支持]
    enum VerticalGlyphFormStyle: Int {
        case horizontal = 0
        case vertical = 1
    }
    
    /// 连字符
    ///
    /// - none: 没有连体字符
    /// - `default`: 默认的连体字符 [default]
    /// - all: 所有连体符号 [iOS 不支持]
    enum AttributeLigatureType: Int {
        case none = 0
        case `default` = 1
        case all = 2
    }
    
    static func+(lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(attributedString: lhs)
        attr.append(rhs)
        return attr
    }
    
    static func+=(lhs: NSMutableAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
        lhs.append(rhs)
        return lhs
    }
    
}
