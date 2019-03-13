//
//  CGPoint.swift
//  FBSnapshotTestCase
//
//  Created by linhey on 2019/3/13.
//

import Foundation

extension CGPoint {
  
  public func distance(to point: CGPoint) -> CGFloat {
    return sqrt(pow((point.x - self.x), 2) + pow((point.y - self.y), 2))
  }
  
}
