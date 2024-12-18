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

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - static Api
public extension Stem where Base: STWrapperColor {
    
    /// 是否启用sRGB色彩模式
    static var displayMode: STWrapperColor.DisplayMode {
        set { STWrapperColor.displayMode = newValue }
        get { return STWrapperColor.displayMode }
    }

}

// MARK: - api
public extension Stem where Base: STWrapperColor {
        
    /// 透明度
    var alpha: CGFloat { base.cgColor.alpha }
    
}

// MARK: - private api
extension STWrapperColor {

    public enum DisplayMode {
        case srgb
        case displayP3
        case rgb
    }
    
    static var displayMode = DisplayMode.displayP3
    
}

// MARK: - init
public extension STWrapperColor {
    
    /// 设置RGBA颜色
    ///
    /// - Parameters:
    ///   - r: red    0 - 255
    ///   - g: green  0 - 255
    ///   - b: blue   0 - 255
    ///   - a: alpha  0 - 1
    convenience init(red: Double, green: Double, blue: Double, alpha: Double = 1) {

        var red   = CGFloat(red)
        var green = CGFloat(green)
        var blue  = CGFloat(blue)
        let alpha = CGFloat(alpha)

        if red > 1 || green > 1 || blue > 1 {
             red   = red   / 255
             green = green / 255
             blue  = blue  / 255
        }

        switch Self.displayMode {
        case .srgb:
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        case .displayP3:
            if #available(iOS 10.0, *) {
                self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
            } else {
                self.init(red: red, green: green, blue: blue, alpha: alpha)
            }
        case .rgb:
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }

}
