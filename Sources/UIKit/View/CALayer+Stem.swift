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

import QuartzCore

public extension Stem where Base: CALayer {

    func addSublayers(_ layers: CALayer...) {
        addSublayers(layers)
    }

    func addSublayers(_ layers: [CALayer]) {
        layers.forEach({ base.addSublayer($0) })
    }

    /** 获取视图显示内容

     示例:

     ```
     UIImageView(image: CALayer().st.snapshot)
     ```
     */
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        base.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /**
     设置边框样式

     - Authors: linhey
     - Date: 2020/01/06

     - Parameter color: 颜色
     - Parameter width: 宽度
     */
    func setBorder(color: UIColor, width: CGFloat) {
        base.borderColor = color.cgColor
        base.borderWidth = width
    }

    /**
     Sketch 中的阴影效果

     - Authors: linhey
     - Date: 2019/11/28
     */
    func setSketchShadow(color: UIColor,
                         alpha: CGFloat,
                         x: CGFloat,
                         y: CGFloat,
                         blur: CGFloat,
                         spread: CGFloat) {
        base.shadowOffset = CGSize(width: x, height: y)
        base.shadowRadius = blur * 0.5
        base.shadowColor = color.cgColor
        base.shadowOpacity = Float(alpha)

        if spread == 0 {
            base.shadowPath = nil
            return
        }

        let rect = base.bounds.insetBy(dx: -spread, dy: -spread)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: base.cornerRadius)
        base.shadowPath = path.cgPath
    }
}
