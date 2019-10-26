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

#if canImport(CoreGraphics)
import Foundation

extension CGRect: StemValueCompatible { }

public extension CGRect {
    
    static var max = CGRect.infinite
    
    /// X
    var x: CGFloat {
        set { self.origin.x = newValue }
        get { return self.origin.x }
    }
    
    /// Y
    var y: CGFloat {
        set { self.origin.y = newValue }
        get { return self.origin.y }
    }
    
}

public extension StemValue where Base == CGRect {

    /// 中心点
    var center: CGPoint {
        return CGPoint(x: base.x + base.width * 0.5, y: base.y + base.height * 0.5)
    }

    /// 判断一个 CGRect 是否合法（例如不带无穷大的值、不带非法数字）
    var isValidated: Bool {
        guard !base.isNull, !base.isInfinite else { return false }
        return true
    }

    func changed(height: CGFloat) -> CGRect {
        return CGRect(x: base.x, y: base.y, width: base.width, height: height)
    }

    func changed(width: CGFloat) -> CGRect {
        return CGRect(x: base.x, y: base.y, width: width, height: base.height)
    }

    func changed(x: CGFloat) -> CGRect {
        return CGRect(x: x, y: base.y, width: base.width, height: base.height)
    }

    func changed(y: CGFloat) -> CGRect {
        return CGRect(x: base.x, y: y, width: base.width, height: base.height)
    }

    func changed(center: CGPoint) -> CGRect {
        return CGRect(x: center.x - base.width * 0.5, y: center.y - base.height * 0.5, width: base.width, height: base.height)
    }
}
#endif
