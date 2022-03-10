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

#if canImport(AVFoundation) && canImport(UIKit)
import UIKit
import AVFoundation

public struct TapticEngine {

    /// 在有 Taptic Engine 的设备上触发一个轻微的振动
    ///
    /// - Parameter params: level  (number)  0 ~ 3 表示振动等级
    public static func taptic(level: Int, isSupportTaptic: Bool = true) {
        if #available(iOS 10.0, *), isSupportTaptic, let style = UIImpactFeedbackGenerator.FeedbackStyle(rawValue: level) {
            let tapticEngine = UIImpactFeedbackGenerator(style: style)
            tapticEngine.prepare()
            tapticEngine.impactOccurred()
        }
        switch level {
        case 3:  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        case 2:  AudioServicesPlaySystemSound(1521) // 连续三次短震
        case 1:  AudioServicesPlaySystemSound(1520) // 普通短震，3D Touch 中 Pop 震动反馈
        default: AudioServicesPlaySystemSound(1519) // 普通短震，3D Touch 中 Peek 震动反馈
        }
    }

}

#endif
