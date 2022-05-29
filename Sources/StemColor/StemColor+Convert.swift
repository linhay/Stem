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

import Foundation

public extension StemColor {
    
    enum DisplayMode {
        case srgb
        case displayP3
        case rgb
        case device
        case calibrated
    }
    
}

#if canImport(CoreGraphics)
import CoreGraphics
public extension StemColor {
    
    func convert() -> CGColor {
        return convert().cgColor
    }
    
}
#endif

#if canImport(AppKit)
import AppKit

@available(macCatalyst, unavailable)
public extension StemColor {

    func convert(mode: DisplayMode = .displayP3) -> NSColor {
        switch mode {
        case .srgb:
            return .init(srgbRed: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: alpha)
        case .displayP3:
            return .init(displayP3Red: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: alpha)
        case .rgb:
            return .init(red: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: alpha)
        case .device:
            return .init(deviceRed: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: alpha)
        case .calibrated:
            return .init(calibratedRed: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: alpha)
        }
    }
    
}
#endif

#if canImport(UIKit)
import UIKit

public extension StemColor {

    func convert(mode: DisplayMode = .displayP3) -> UIColor {
        switch mode {
        case .srgb:
            return .init(red: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: alpha)
        case .displayP3:
            return .init(displayP3Red: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: alpha)
        case .rgb:
            return .init(red: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: alpha)
        case .device:
            return .init(red: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: alpha)
        case .calibrated:
            return .init(red: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: alpha)
        }
    }
    
}
#endif

