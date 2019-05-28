//
//  UIView+CALayer.swift
//  FBSnapshotTestCase
//
//  Created by linhey on 2019/5/20.
//

import UIKit

public extension Stem where Base: UIView {

    /// 设置LayerShadow,offset,radius
    func setShadow(color: UIColor, offset: CGSize, radius: CGFloat) {
        base.layoutIfNeeded()
        DispatchQueue.main.async {
            self.base.layer.shadowColor = color.cgColor
            self.base.layer.shadowOffset = offset
            self.base.layer.shadowRadius = radius
            self.base.layer.shadowOpacity = 1
            self.base.layer.shouldRasterize = true
            self.base.layer.rasterizationScale = UIScreen.main.scale
        }
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
    func setShadows(radius: CGFloat = 0,
                    color: UIColor,
                    opacity: Float,
                    offset: CGPoint = CGPoint.zero,
                    blur: CGFloat,
                    spread: CGFloat = 0) {
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
    }


}
