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

import Foundation

extension NSMutableAttributedString {

    static func+=(lhs: inout NSMutableAttributedString, rhs: NSAttributedString?) {
        guard let rhs = rhs else {
            return
        }
        lhs.append(rhs)
    }
    
}

extension Stem where Base: NSMutableAttributedString {

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
