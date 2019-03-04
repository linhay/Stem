//
//  UIImage+Color.swift
//  FBSnapshotTestCase
//
//  Created by linhey on 2019/1/12.
//

import UIKit

// MARK: - 初始化
public extension UIImage{
  /// 获取指定颜色的图片
  ///
  /// - Parameters:
  ///   - color: UIColor
  ///   - size: 图片大小
  public convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    UIGraphicsBeginImageContextWithOptions(size, false, 1)
    defer { UIGraphicsEndImageContext() }
    color.setFill()
    UIRectFill(CGRect(origin: .zero, size: size))
    
    guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
      self.init()
      return
    }
    self.init(cgImage: aCgImage)
  }
}

// MARK: - UIImage
public extension Stem where Base: UIImage{
  /// 返回一张没有被渲染图片
  public var original: UIImage { return base.withRenderingMode(.alwaysOriginal) }
  /// 返回一张可被渲染图片
  public var template: UIImage { return base.withRenderingMode(.alwaysTemplate) }
}

public extension Stem where Base: UIImage{
  /// 修改单色系图片颜色
  ///
  /// - Parameter color: 颜色
  /// - Returns: 新图
  public func setTint(color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(base.size, false, 1)
    defer { UIGraphicsEndImageContext() }
    color.setFill()
    let bounds = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
    UIRectFill(bounds)
    base.draw(in: bounds, blendMode: .overlay, alpha: 1)
    base.draw(in: bounds, blendMode: .destinationIn, alpha: 1)
    return UIGraphicsGetImageFromCurrentImageContext() ?? base
  }
  
  /// 修改单色系图片颜色
  ///
  /// - Parameter color: 颜色
  /// - Returns: 新图
  public func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage {
    let drawRect = CGRect(x: 0.0, y: 0.0, width: base.size.width, height: base.size.height)
    UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
    let context = UIGraphicsGetCurrentContext()
    context!.clip(to: drawRect, mask: base.cgImage!)
    color.setFill()
    UIRectFill(drawRect)
    base.draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
    let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return tintedImage!
  }
}
