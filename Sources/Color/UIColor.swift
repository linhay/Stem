//
//  Stem
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import UIKit

// MARK: - static Api
public extension Stem where Base: UIColor {

    /// 是否启用sRGB色彩模式
    static var isDisplayP3Enabled: Bool {
        set { UIColor.isDisplayP3Enabled = newValue }
        get { return UIColor.isDisplayP3Enabled }
    }

    /// hex to RGB value
    /// - Parameter value: hex
    static func rgb(from value: UInt32) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        return (red: CGFloat((value & 0xFF0000) >> 16),
                green: CGFloat((value & 0x00FF00) >> 8),
                blue: CGFloat(value & 0x0000FF))
    }

    /// hex to RGB value
    /// - Parameter str: value: hex
    static func rgb(from str: String) -> (red: CGFloat, green: CGFloat, blue: CGFloat)? {
        var cString = str.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("0X") { cString = String(cString.dropFirst(2)) }
        if cString.hasPrefix("#") { cString = String(cString.dropFirst(1)) }
        if cString.count != 6 { return nil }

        var value: UInt32 = 0x0
        Scanner(string: String(cString)).scanHexInt32(&value)

        return rgb(from: value)
    }

}

// MARK: - api
public extension Stem where Base: UIColor {

    /// 随机色
    static var random: UIColor {
        let r = CGFloat(drand48())
        let g = CGFloat(drand48())
        let b = CGFloat(drand48())
        return UIColor(r: r, g: g, b: b, a: 1.0)
    }

    /// 设置透明度
    ///
    /// - Parameter alpha: 透明度
    /// - Returns: uicolor
    func with(alpha: CGFloat) -> UIColor { return base.withAlphaComponent(alpha) }

    /// 获取RGB色值
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        guard let components = base.cgColor.components else {
            return (red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
        let r = components[0] * 255
        let g = components[1] * 255
        let b = components[2] * 255
        let a = components[3]
        return (red: r, green: g, blue: b, alpha: a)
    }

    /// 获取hex字符
    var hexString: String {
        let rgb = self.rgb
        if rgb.alpha == 1 {
            return String(format: "#%02lX%02lX%02lX",Int(rgb.red),Int(rgb.green),Int(rgb.blue))
        }
        else {
            return String(format: "#%02lX%02lX%02lX%02lX", Int(rgb.red), Int(rgb.green), Int(rgb.blue), Int(rgb.alpha))
        }
    }

}

// MARK: - private api
private extension UIColor {

    /// 是否启用sRGB色彩模式
    static var isDisplayP3Enabled = false

}

// MARK: - init
public extension UIColor {

    /// 十六进制色: 0x666666
    ///
    /// - Parameter str: "#666666" / "0X666666" / "0x666666"
    convenience init(_ str: String){
        guard let value = UIColor.st.rgb(from: str) else {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
            return
        }
        self.init(r: value.red, g: value.green, b: value.blue)
    }

    /// 十六进制色: 0x666666
    ///
    /// - Parameter RGBValue: 十六进制颜色
    convenience init(_ value: UInt32) {
        let value = UIColor.st.rgb(from: value)
        self.init(r: value.red, g: value.green, b: value.blue)
    }

    /// 设置RGBA颜色
    ///
    /// - Parameters:
    ///   - r: red    0 - 255
    ///   - g: green  0 - 255
    ///   - b: blue   0 - 255
    ///   - a: alpha  0 - 255
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        if #available(iOS 10.0, *), UIColor.isDisplayP3Enabled {
            self.init(displayP3Red: r / 255, green: g / 255, blue: b / 255, alpha: a)
        } else {
            self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
        }
    }

}
