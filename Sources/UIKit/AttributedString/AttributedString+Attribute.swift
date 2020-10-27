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

import UIKit

public extension NSAttributedString {

    /// 富文本属性
    enum Attribute {
        /// 字体, [default: Helvetica(Neue) 12]
        case font(UIFont)
        /// 文本前景颜色 [default: blackColor]
        case foregroundColor(UIColor)
        /// 文本背景颜色 [default nil]
        case backgroundColor(UIColor)
        /// 删除线颜色
        case strikethroughColor(UIColor)
        /// 下划线颜色
        case underlineColor(UIColor)
        /// 笔刷颜色
        case strokeColor(UIColor)
        /// 字距，负值间距变窄，正值间距变宽
        case kern(CGFloat)
        /// 基线偏移值 正值上偏，负值下偏 [default: 0]
        case baselineOffset(CGFloat)
        /// 设置字体倾斜度，正值右倾，负值左倾
        case obliqueness(CGFloat)
        /// 字体的横向拉伸，正值拉伸，负值压缩
        case expansion(CGFloat)
        /// 笔刷样式
        case strokeWidth(CGFloat)
        /// 删除线样式
        case strikethroughStyle(NSUnderlineStyle)
        /// 下划线样式
        case underlineStyle(NSUnderlineStyle)
        /// 阴影 [default: nil]
        case shadow(NSShadow)
        /// 文本特殊效果
        case textEffect(TextEffectStyle)
        /// 文本附件
        case attachment(NSTextAttachment)
        /// 超链接
        case link(Any)
        /// 文字的书写方向
        case writingDirection([NSWritingDirection])
        /// 段落属性
        case paragraphStyle([ParagraphStyle])
        /// 连体属性
        case ligature(AttributeLigatureType)
        /// 文字排版方向
        case verticalGlyphForm(_: VerticalGlyphFormStyle)

        public static func create(from value: [NSAttributedString.Key: Any]) -> [Attribute] {
            var list = [Attribute]()
            list.reserveCapacity(value.keys.count)

            value.forEach { (key, value) in
                if key == .font, let result = value as? UIFont {
                    list.append(.font(result))
                }
                else if key == .foregroundColor, let result = value as? UIColor {
                    list.append(.foregroundColor(result))
                }
                else if key == .backgroundColor, let result = value as? UIColor {
                    list.append(.backgroundColor(result))
                }
                else if key == .strikethroughColor, let result = value as? UIColor {
                    list.append(.strikethroughColor(result))
                }
                else if key == .underlineColor, let result = value as? UIColor {
                    list.append(.underlineColor(result))
                }
                else if key == .strokeColor, let result = value as? UIColor {
                    list.append(.strokeColor(result))
                }
                else if key == .kern, let result = value as? CGFloat {
                    list.append(.kern(result))
                }
                else if key == .baselineOffset, let result = value as? CGFloat {
                    list.append(.baselineOffset(result))
                }
                else if key == .obliqueness, let result = value as? CGFloat {
                    list.append(.obliqueness(result))
                }
                else if key == .expansion, let result = value as? CGFloat {
                    list.append(.expansion(result))
                }
                else if key == .strokeWidth, let result = value as? CGFloat {
                        list.append(.strokeWidth(result))
                    }
                else if key == .strikethroughStyle, let result = value as? NSUnderlineStyle {
                    list.append(.strikethroughStyle(result))
                }
                else if key == .underlineStyle, let result = value as? NSUnderlineStyle {
                    list.append(.underlineStyle(result))
                }
                else if key == .shadow, let result = value as? NSShadow {
                    list.append(.shadow(result))
                }
                else if key == .textEffect, let result = value as? TextEffectStyle {
                    list.append(.textEffect(result))
                }
                else if key == .attachment, let result = value as? NSTextAttachment {
                    list.append(.attachment(result))
                }
                else if key == .link {
                    list.append(.link(value))
                }
                else if key == .writingDirection, let result = value as? [NSWritingDirection] {
                    list.append(.writingDirection(result))
                }
                else if key == .paragraphStyle, let result = value as? NSParagraphStyle {
                    list.append(.paragraphStyle(ParagraphStyle.create(from: result)))
                }
                else if key == .ligature, let result = value as? Int {
                    list.append(.ligature(AttributeLigatureType(rawValue: result) ?? .default))
                }
                else if key == .verticalGlyphForm, let result = value as? Int {
                    list.append(.verticalGlyphForm(VerticalGlyphFormStyle(rawValue: result) ?? .horizontal))
                }

            }

            return list
        }

        public static func create(from value: [Attribute]) -> [NSAttributedString.Key: Any] {
            var dict = [NSAttributedString.Key: Any]()

            value.forEach { item in
                switch item {
                case .font(let v):
                    dict[.font] = v
                case .paragraphStyle(let v):
                    dict[.paragraphStyle] = ParagraphStyle.create(from: v)
                case .foregroundColor(let v):
                    dict[.foregroundColor] = v
                case .backgroundColor(let v):
                    dict[.backgroundColor] = v
                case .ligature(let v):
                    dict[.ligature] = v
                case .kern(let v):
                    dict[.kern] = v
                case .strikethroughStyle(let v):
                    dict[.strikethroughStyle] = v
                case .strikethroughColor(let v):
                    dict[.strikethroughColor] = v
                case .underlineColor(let v):
                    dict[.underlineColor] = v
                case .underlineStyle(let v):
                    dict[.underlineStyle] = v
                case .strokeColor(let v):
                    dict[.strokeColor] = v
                case .strokeWidth(let v):
                    dict[.strokeWidth] = v
                case .shadow(let v):
                    dict[.shadow] = v
                case .verticalGlyphForm(let v):
                    dict[.verticalGlyphForm] = v.rawValue
                case .textEffect(let v):
                    dict[.textEffect] = v
                case .attachment(let v):
                    dict[.attachment] = v
                case .link(let v):
                    dict[.link] = v
                case .baselineOffset(let v):
                    dict[.baselineOffset] = v
                case .obliqueness(let v):
                    dict[.obliqueness] = v
                case .expansion(let v):
                    dict[.expansion] = v
                case .writingDirection(let v):
                    dict[.writingDirection] = v
                }
            }
            return dict
        }

    }

    enum ParagraphStyle {
        case lineSpacing(CGFloat)
        case paragraphSpacing(CGFloat)
        case alignment(NSTextAlignment)
        case firstLineHeadIndent(CGFloat)
        case headIndent(CGFloat)
        case tailIndent(CGFloat)
        case lineBreakMode(NSLineBreakMode)
        case minimumLineHeight(CGFloat)
        case maximumLineHeight(CGFloat)
        case baseWritingDirection(NSWritingDirection)
        case lineHeightMultiple(CGFloat)
        case paragraphSpacingBefore(CGFloat)
        case hyphenationFactor(Float)
        @available(iOS 7.0, *)
        case tabStops([NSTextTab])
        @available(iOS 7.0, *)
        case defaultTabInterval(CGFloat)
        @available(iOS 9.0, *)
        case allowsDefaultTighteningForTruncation(Bool)

        public static func create(from value: [ParagraphStyle]) -> NSParagraphStyle {
            let result = NSMutableParagraphStyle()

            value.forEach { item in
                switch item {
                case .lineSpacing(let v):
                    result.lineSpacing = v
                case .paragraphSpacing(let v):
                    result.paragraphSpacing = v
                case .alignment(let v):
                    result.alignment = v
                case .firstLineHeadIndent(let v):
                    result.firstLineHeadIndent = v
                case .headIndent(let v):
                    result.headIndent = v
                case .tailIndent(let v):
                    result.tailIndent = v
                case .lineBreakMode(let v):
                    result.lineBreakMode = v
                case .minimumLineHeight(let v):
                    result.minimumLineHeight = v
                case .maximumLineHeight(let v):
                    result.maximumLineHeight = v
                case .baseWritingDirection(let v):
                    result.baseWritingDirection = v
                case .lineHeightMultiple(let v):
                    result.lineHeightMultiple = v
                case .paragraphSpacingBefore(let v):
                    result.paragraphSpacingBefore = v
                case .hyphenationFactor(let v):
                    result.hyphenationFactor = v
                case .tabStops(let v):
                    result.tabStops = v
                case .defaultTabInterval(let v):
                    result.defaultTabInterval = v
                case .allowsDefaultTighteningForTruncation(let v):
                    result.allowsDefaultTighteningForTruncation = v
                }
            }

            return result
        }

        public static func create(from value: NSParagraphStyle) -> [ParagraphStyle] {

            return [.lineSpacing(value.lineSpacing),
                    .paragraphSpacing(value.paragraphSpacing),
                    .alignment(value.alignment),
                    .firstLineHeadIndent(value.firstLineHeadIndent),
                    .headIndent(value.headIndent),
                    .tailIndent(value.tailIndent),
                    .lineBreakMode(value.lineBreakMode),
                    .minimumLineHeight(value.minimumLineHeight),
                    .maximumLineHeight(value.maximumLineHeight),
                    .baseWritingDirection(value.baseWritingDirection),
                    .lineHeightMultiple(value.lineHeightMultiple),
                    .paragraphSpacingBefore(value.paragraphSpacingBefore),
                    .hyphenationFactor(value.hyphenationFactor),
                    .tabStops(value.tabStops),
                    .defaultTabInterval(value.defaultTabInterval),
                    .allowsDefaultTighteningForTruncation(value.allowsDefaultTighteningForTruncation)]

        }

    }

    /// 文字排版方向
    enum VerticalGlyphFormStyle: Int {
        /// 横排文本 [default]
        case horizontal = 0
        /// 竖排文本 [iOS 不支持]
        case vertical = 1
    }

    /// 连字符
    enum AttributeLigatureType: Int {
        /// 没有连体字符
        case none = 0
        /// 默认的连体字符 [default]
        case `default` = 1
        /// 所有连体符号 [iOS 不支持]
        case all = 2
    }

    static func+(lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(attributedString: lhs)
        attr.append(rhs)
        return attr
    }

}
