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

public extension Stem where Base: UIView {

    /// 设置LayerShadow,offset,radius
    @discardableResult
    func setShadow(color: UIColor, offset: CGSize, radius: CGFloat) -> Stem<Base> {
        base.layoutIfNeeded()
        DispatchQueue.main.async {
            self.base.layer.shadowColor = color.cgColor
            self.base.layer.shadowOffset = offset
            self.base.layer.shadowRadius = radius
            self.base.layer.shadowOpacity = 1
            self.base.layer.shouldRasterize = true
            self.base.layer.rasterizationScale = UIScreen.main.scale
        }
        return self
    }

    /// 设置 shadows (适用于 Zeplin)
    ///
    /// - Parameters:
    ///   - radius: 圆角
    ///   - color: shadows 颜色
    ///   - opacity: 透明度
    ///   - offset: 偏移
    ///   - blur: 高斯模糊
    ///   - spread: spread
    @discardableResult
    func setShadows(radius: CGFloat = 0,
                    color: UIColor,
                    opacity: Float,
                    offset: CGPoint = CGPoint.zero,
                    blur: CGFloat,
                    spread: CGFloat = 0) -> Stem<Base> {
        base.layoutIfNeeded()
        DispatchQueue.main.async {
            self.base.layer.cornerRadius = radius
            self.base.layer.shadowColor = color.cgColor
            self.base.layer.shadowOpacity = opacity
            self.base.layer.shadowOffset = CGSize(width: offset.x, height: offset.y)
            self.base.layer.shadowRadius = blur
            let rect = self.base.bounds.insetBy(dx: -spread, dy: -spread)
            self.base.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
        }
        return self
    }


}
