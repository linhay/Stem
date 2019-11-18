//
//  ParagraphStyle.swift
//  Stem
//
//  Created by 林翰 on 2019/11/18.
//

import Foundation

public extension Stem where Base: NSParagraphStyle {

    var mutabled: NSMutableParagraphStyle {
        if let value = base as? NSMutableParagraphStyle {
            return value
        }
        let style = NSMutableParagraphStyle()
        style.lineSpacing            = base.lineSpacing
        style.paragraphSpacing       = base.paragraphSpacing
        style.alignment              = base.alignment
        style.firstLineHeadIndent    = base.firstLineHeadIndent
        style.headIndent             = base.headIndent
        style.tailIndent             = base.tailIndent
        style.lineBreakMode          = base.lineBreakMode
        style.minimumLineHeight      = base.minimumLineHeight
        style.maximumLineHeight      = base.maximumLineHeight
        style.baseWritingDirection   = base.baseWritingDirection
        style.lineHeightMultiple     = base.lineHeightMultiple
        style.paragraphSpacingBefore = base.paragraphSpacingBefore
        style.hyphenationFactor      = base.hyphenationFactor
        style.tabStops               = base.tabStops
        style.defaultTabInterval     = base.defaultTabInterval
        if #available(iOS 9.0, *) {
            style.allowsDefaultTighteningForTruncation = base.allowsDefaultTighteningForTruncation
        }
        return style
    }

}
