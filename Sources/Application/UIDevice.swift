//
//  UIDevice.swift
//  FBSnapshotTestCase
//
//  Created by linhey on 2019/1/16.
//

import UIKit

#if canImport(AVFoundation)
import AVFoundation
public extension Stem where Base: UIDevice {
  
  /// 开启/关闭 手电筒
  public func torch(level: Double) {
    guard let device = AVCaptureDevice.default(for: .video) else { return }
    do {
      try device.lockForConfiguration()
      device.torchMode = level > 0 ? .on : .off
      try device.setTorchModeOn(level: Float(level))
      device.unlockForConfiguration()
    }catch{
     print(error.localizedDescription)
    }
  }
  
  /// 在有 Taptic Engine 的设备上触发一个轻微的振动
  ///
  /// - Parameter params: level  (number)  0 ~ 3 表示振动等级
  public func taptic(level: Int, isSupportTaptic: Bool = true) {
    if #available(iOS 10.0, *),
      isSupportTaptic,
      let style = UIImpactFeedbackGenerator.FeedbackStyle(rawValue: level) {
      let tapticEngine = UIImpactFeedbackGenerator(style: style)
      tapticEngine.prepare()
      tapticEngine.impactOccurred()
    }else{
      switch level {
      case 3:
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
      case 2:
        // 连续三次短震
        AudioServicesPlaySystemSound(1521)
      case 1:
        // 普通短震，3D Touch 中 Pop 震动反馈
        AudioServicesPlaySystemSound(1520)
      default:
        // 普通短震，3D Touch 中 Peek 震动反馈
        AudioServicesPlaySystemSound(1519)
      }
    }
  }
  
}

#endif


