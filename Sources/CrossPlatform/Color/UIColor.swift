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
public typealias STWrapperColor = UIColor
#elseif canImport(AppKit)
import AppKit
public typealias STWrapperColor = NSColor
#endif

public extension StemColor {

    var color: STWrapperColor {
        STWrapperColor(red: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: alpha)
    }

    convenience init(cgColor color: CGColor) {
        guard let components = color.components, components.count >= 4 else {
            self.init(rgb: RGBSpace(red: 1, green: 1, blue: 1), alpha: 1)
            return
        }

        let red   = Double(components[0]) * 255
        let green = Double(components[1]) * 255
        let blue  = Double(components[2]) * 255
        let alpha = Double(components[3])

        self.init(rgb: RGBSpace(red: red, green: green, blue: blue), alpha: alpha)
    }

    convenience init(color: STWrapperColor) {
        self.init(cgColor: color.cgColor)
    }

}

public extension Stem where Base: STWrapperColor {

    var stemColor: StemColor {
        .init(color: base)
    }

}

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
    
    /// 随机色
    static var random: STWrapperColor { StemColor.random.color }
    
    /// 透明度
    var alpha: CGFloat { base.cgColor.alpha }
    
    /// 设置透明度
    ///
    /// - Parameter alpha: 透明度
    /// - Returns: uicolor
    func with(alpha: CGFloat) -> STWrapperColor { return base.withAlphaComponent(alpha) }
    
}

// MARK: - private api
 extension STWrapperColor {

 public enum DisplayMode {
        case srgb
        case p3
        case rgb
    }
    
    static var displayMode = DisplayMode.srgb
    
}

// MARK: - init
public extension STWrapperColor {
    
    /// 十六进制色: 0x666666
    ///
    /// - Parameter str: "#666666" / "0X666666" / "0x666666"
    convenience init(_ value: String) {
        let color = StemColor(hex: value)
        let rgbSpace = color.rgbSpace
        self.init(red: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: color.alpha)
    }
    
    /// 十六进制色: 0x666666
    ///
    /// - Parameter RGBValue: 十六进制颜色
    convenience init(_ value: Int) {
        let color = StemColor(hex: value)
        let rgbSpace = color.rgbSpace
        self.init(red: rgbSpace.red, green: rgbSpace.green, blue: rgbSpace.blue, alpha: color.alpha)
    }
    
    /// 设置RGBA颜色
    ///
    /// - Parameters:
    ///   - r: red    0 - 255
    ///   - g: green  0 - 255
    ///   - b: blue   0 - 255
    ///   - a: alpha  0 - 1
    convenience init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
        let red = CGFloat(red)
        let green = CGFloat(green)
        let blue = CGFloat(blue)
        let alpha = CGFloat(alpha)
        switch Self.displayMode {
        case .srgb:
            self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
        case .p3:
            if #available(iOS 10.0, *) {
                self.init(displayP3Red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
            } else {
                self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
            }
        case .rgb:
            self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
        }
    }

}

// MARK: - Brightness
public extension Stem where Base: STWrapperColor {
    
    func lighter(amount: CGFloat = 0.25) -> STWrapperColor {
        return hueColor(withBrightnessAmount: 1 + amount)
    }
    
    func darker(amount: CGFloat = 0.25) -> STWrapperColor {
        return hueColor(withBrightnessAmount: 1 - amount)
    }
    
    private func hueColor(withBrightnessAmount amount: CGFloat) -> STWrapperColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        #if os (iOS) || os (tvOS) || os (watchOS)
        if base.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue,
                           saturation: saturation,
                           brightness: brightness * amount,
                           alpha: alpha)
        }
        return base
        #else
        base.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return STWrapperColor(hue: hue,
                              saturation: saturation,
                              brightness: brightness * amount,
                              alpha: alpha)
        #endif
    }
    
}
