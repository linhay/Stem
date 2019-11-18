//
//  MutableAttributedString.swift
//  Stem
//
//  Created by 林翰 on 2019/11/18.
//

import Foundation

extension NSMutableAttributedString {

    static func+=(lhs: inout NSMutableAttributedString, rhs: NSAttributedString?) {
        guard let rhs = rhs else {
            return
        }
        lhs.append(rhs)
    }
    
}

public extension Stem where Base: NSMutableAttributedString {

    func set(_ value: Any?, for key: NSAttributedString.Key, range: Range<Int>? = nil) -> Base {
        var textRange = NSRange(location: 0, length: base.length)
        if let range = range {
            textRange = NSRange(location: range.lowerBound, length: range.upperBound - range.lowerBound)
        }
        guard let value = value else {
            base.removeAttribute(key, range: textRange)
            return base
        }
        base.addAttribute(key, value: value, range: textRange)
        return base
    }

}
