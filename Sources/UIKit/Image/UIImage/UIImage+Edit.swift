//
//  Stem
//
//  github: https://github.com/linhay/Stem
//  Copyright (c) 2019 linhay - https://github.com/linhay
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

public extension UIImage {

    public enum OverlayAlignment {
        /// 居中
        case center(x: CGFloat, y: CGFloat)
        /// 左上
        case zero(x: CGFloat, y: CGFloat)
    }

}

// MARK: - edit(图片编辑)
public extension Stem where Base: UIImage {

    /// 叠加图片
    ///
    /// - Parameters:
    ///   - image: 覆盖至上方图片
    ///   - offset: 覆盖图片偏移 正值向下向右
    /// - Returns: 新图
    func overlay(image: UIImage, alignment: UIImage.OverlayAlignment = .center(x: 0, y: 0)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        base.draw(in: CGRect(origin: .zero, size: base.size))
        switch alignment {
        case .center(x: let x, y: let y):
            let origin = CGPoint(x: (base.size.width - image.size.width) * 0.5 + x,
                                 y: (base.size.height - image.size.height) * 0.5 + y)
            image.draw(in: CGRect(origin: origin, size: image.size))
        case .zero(x: let x, y: let y):
            let origin = CGPoint(x: x, y: y)
            image.draw(in: CGRect(origin: origin, size: image.size))
        }
        return UIGraphicsGetImageFromCurrentImageContext() ?? base
    }
    
    /// 裁剪对应区域
    ///
    /// - Parameter bound: 裁剪区域
    /// - Returns: 新图
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width < base.size.width && rect.size.height < base.size.height,
            let image: CGImage = base.cgImage?.cropping(to: rect)
            else { return base }
        return UIImage(cgImage: image)
    }
    
    /**
     图片处理: 图像边缘处理 - 圆角
     
     - Authors: linhey
     - Date: 2019/23/06
     
     - Parameter radius: 圆角半径
     - Returns: 新图
     - Example:
     
     ```
     
     let image = UIImage().st.edgeEditing(radius: 8)
     
     ```
     
     */
    func edgeEditing(radius: CGFloat? = nil) -> UIImage {
        return self.edgeEditing(radius: radius ?? base.size.height * 0.5,
                                corners: .allCorners,
                                borderWidth: 0,
                                borderColor: nil,
                                borderLineJoin: .miter)
    }
    
    /**
     图像处理: 图像边缘处理
     
     - Authors: linhey
     - Date: 2019/12/06
     
     - Parameter radius: 圆角半径
     - Parameter corners: 圆角区域
     - Parameter borderWidth: 描边大小
     - Parameter borderColor: 描边颜色
     - Parameter borderLineJoin: 描边类型
     - Returns: 新图
     
     - Example:
     
     ```
     
     UIImage().st.edgeEditing(radius: 8,
     corners: .allCorners,
     borderWidth: 0,
     borderColor: nil,
     borderLineJoin: .miter)
     
     ```
     */
    func edgeEditing(radius: CGFloat,
                     corners: UIRectCorner = .allCorners,
                     borderWidth: CGFloat = 0,
                     borderColor: UIColor? = nil,
                     borderLineJoin: CGLineJoin = .miter) -> UIImage {
        var corners = corners
        if corners != UIRectCorner.allCorners {
            var rawValue: UInt = 0
            if (corners.rawValue & UIRectCorner.topLeft.rawValue) != 0 { rawValue = rawValue | UIRectCorner.bottomLeft.rawValue }
            if (corners.rawValue & UIRectCorner.topRight.rawValue) != 0 { rawValue = rawValue | UIRectCorner.bottomRight.rawValue }
            if (corners.rawValue & UIRectCorner.bottomLeft.rawValue) != 0 { rawValue = rawValue | UIRectCorner.topLeft.rawValue }
            if (corners.rawValue & UIRectCorner.bottomRight.rawValue) != 0 { rawValue = rawValue | UIRectCorner.topRight.rawValue }
            corners = UIRectCorner(rawValue: rawValue)
        }
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return base }
        let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.height)
        let minSize = min(base.size.width, base.size.height)
        
        if borderWidth < minSize * 0.5 {
            let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth),
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: borderWidth))
            
            path.close()
            context.saveGState()
            path.addClip()
            guard let cgImage = base.cgImage else { return base }
            context.draw(cgImage, in: rect)
            context.restoreGState()
        }
        
        if borderColor != nil, borderWidth < minSize / 2, borderWidth > 0 {
            let strokeInset = (floor(borderWidth * base.scale) + 0.5) / base.scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > base.scale / 2 ? CGFloat(radius - base.scale / 2): 0
            let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
            path.close()
            path.lineWidth = borderWidth
            path.lineJoinStyle = borderLineJoin
            borderColor?.setStroke()
            path.stroke()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image?.st.png ?? base
    }
    
}
