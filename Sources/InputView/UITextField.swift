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

public extension Stem where Base: UITextField {
    
    var selectedRange: NSRange? {
        guard let selectedTextRange = base.selectedTextRange else { return nil }
        let location = base.offset(from: base.beginningOfDocument, to: selectedTextRange.start)
        let length = base.offset(from: selectedTextRange.start, to: selectedTextRange.end)
        return NSRange(location: location, length: length)
    }
    
}

// MARK: - Padding
public extension Stem where Base: UITextField {

    /// 左边间距
    var leftPadding: CGFloat {
        get {
            return base.leftView?.frame.size.width ?? 0
        }
        set {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: base.frame.size.height))
            base.leftView = view
            base.leftViewMode = .always
        }
    }

    /// 右边间距
    var rightPadding: CGFloat {
        get {
            return base.rightView?.frame.size.width ?? 0
        }
        set {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: base.frame.size.height))
            base.rightView = view
            base.rightViewMode = .always
        }
    }
}

// MARK: - placeholder
public extension Stem where Base: UITextField {

    /// 占位文本控件
    var placeholderLabel: UILabel? { return self.ivar(for: "_placeholderLabel") as? UILabel }

    /// 占位文字颜色
    var placeholderColor: UIColor? {
        get{ return placeholderLabel?.textColor }
        set{ placeholderLabel?.textColor = newValue }
    }

    /// 占位文字字体
    var placeholderFont: UIFont? {
        get{ return placeholderLabel?.font }
        set{ placeholderLabel?.font = newValue }
    }

}
