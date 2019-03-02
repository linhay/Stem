//
//  UIGestureRecognizer.swift
//  FBSnapshotTestCase
//
//  Created by linhey on 2019/3/2.
//

import UIKit

public extension Stem where Base: UIGestureRecognizer {

  /// 获取当前手势直接作用到的 view
  var targetView: UIView? {
    let location = base.location(in: base.view)
    return base.view?.hitTest(location, with: nil)
  }
  
}
