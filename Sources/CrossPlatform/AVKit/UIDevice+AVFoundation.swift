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

#if canImport(UIKit) && canImport(AVFoundation)

import UIKit
import AVFoundation

@available(iOS 4.0, macCatalyst 14.0, *)
public extension Stem where Base: UIDevice {
    
    /// 闪光灯 亮度等级 0 ~ 1
    var torchLevel: Double {
        set {
            let value = min(max(newValue, 0), 1)
            guard let device = AVCaptureDevice.default(for: .video) else { return }
            do {
                try device.lockForConfiguration()
                if value == 0 {
                    device.torchMode = .off
                } else {
                    device.torchMode = .on
                    try device.setTorchModeOn(level: Float(value))
                }
                device.unlockForConfiguration()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        get {
            guard let device = AVCaptureDevice.default(for: .video) else { return 0 }
            return Double(device.torchLevel)
        }
    }
    
}

#endif
