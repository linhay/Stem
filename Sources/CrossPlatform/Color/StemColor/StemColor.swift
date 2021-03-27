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

// http://www.easyrgb.com/en/math.php
// https://zh.wikipedia.org/wiki/HSL%E5%92%8CHSV%E8%89%B2%E5%BD%A9%E7%A9%BA%E9%97%B4
public class StemColor {

    // value: 0 - 1.0
    public private(set) var alpha: Double = 1

    public let rgbSpace: RGBSpace
    public lazy var rybSpace: RYBSpace    = { Self.calculator.convert(rgbSpace) }()
    public lazy var hslSpace: HSLSpace    = { Self.calculator.convert(rgbSpace) }()
    public lazy var hsbSpace: HSBSpace    = { Self.calculator.convert(rgbSpace) }()
    public lazy var cmySpace: CMYSpace    = { Self.calculator.convert(rgbSpace) }()
    public lazy var cmykSpace: CMYKSpace  = { Self.calculator.convert(cmySpace) }()
    public lazy var xyzSpace: CIEXYZSpace = { Self.calculator.convert(rgbSpace) }()
    public lazy var labSpace: CIELABSpace = { Self.calculator.convert(xyzSpace) }()
    
    static let calculator = StemColor.SpaceCalculator()

    public convenience init(cmyk space: CMYKSpace, alpha: Double = 1) {
        let cmy: CMYSpace   = Self.calculator.convert(space)
        let space: RGBSpace = Self.calculator.convert(cmy)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(lab space: CIELABSpace, alpha: Double = 1) {
        let xyz: CIEXYZSpace = Self.calculator.convert(space)
        let space: RGBSpace  = Self.calculator.convert(xyz)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(cmy space: CMYSpace, alpha: Double = 1) {
        let space: RGBSpace  = Self.calculator.convert(space)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(xyz space: CIEXYZSpace, alpha: Double = 1) {
        let space: RGBSpace  = Self.calculator.convert(space)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(hsl space: HSLSpace, alpha: Double = 1) {
        let space: RGBSpace  = Self.calculator.convert(space)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(ryb space: RYBSpace, alpha: Double = 1) {
        let space: RGBSpace  = Self.calculator.convert(space)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(hsb space: HSBSpace, alpha: Double = 1) {
        let space: RGBSpace  = Self.calculator.convert(space)
        self.init(rgb: space, alpha: alpha)
    }

    public init(rgb space: RGBSpace, alpha: Double = 1) {
        self.rgbSpace = space
        self.alpha = max(min(alpha, 1), 0)
    }

    public init(alpha: Double = 1) {
        self.rgbSpace = .init(red: 1, green: 1, blue: 1)
        self.alpha = max(min(alpha, 1), 0)
    }

}

extension StemColor: Hashable, Equatable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rgbSpace.hashValue)
    }
    
    public static func == (lhs: StemColor, rhs: StemColor) -> Bool {
        lhs.rgbSpace == rhs.rgbSpace
    }
    
}

public extension StemColor {

    /// 十六进制色: 0x666666
    ///
    /// - Parameter str: "#666666" / "0X666666" / "0x666666"
    convenience init(hex value: String) {
        var cString = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("0X") { cString = String(cString.dropFirst(2)) }
        if cString.hasPrefix("#") { cString = String(cString.dropFirst(1)) }
        guard cString.count == 6 || cString.count == 8 else {
            assertionFailure("StemColor: 位数错误, 只支持 6 或 8 位, value: \(value)")
            self.init(rgb: RGBSpace(red: 1, green: 1, blue: 1), alpha: 1)
            return
        }
        var value: UInt64 = 0x0
        Scanner(string: String(cString)).scanHexInt64(&value)
        self.init(hex: Int(value))
    }

    /// 十六进制色: 0x666666
    ///
    /// - Parameter RGBValue: 十六进制颜色
    convenience init(hex value: Int) {

        var hex = value
        var count = 0

        while count <= 8, hex > 0 {
            hex = hex >> 4
            count += 1
            if count > 8 { break }
        }

        let divisor = Double(255)

        if count <= 6 {
            let red     = Double((value & 0xFF0000) >> 16) / divisor
            let green   = Double((value & 0x00FF00) >>  8) / divisor
            let blue    = Double( value & 0x0000FF       ) / divisor
            self.init(rgb: RGBSpace(red: red, green: green, blue: blue), alpha: 1)
        } else if count <= 8 {
            let red     = Double((Int64(value) & 0xFF000000) >> 24) / divisor
            let green   = Double((Int64(value) & 0x00FF0000) >> 16) / divisor
            let blue    = Double((Int64(value) & 0x0000FF00) >>  8) / divisor
            let alpha   = Double( Int64(value) & 0x000000FF       ) / divisor
            self.init(rgb: RGBSpace(red: red, green: green, blue: blue), alpha: alpha)
        } else {
            assertionFailure("StemColor: 位数错误, 只支持 6 或 8 位, count: \(count)")
            self.init(rgb: RGBSpace(red: 1, green: 1, blue: 1), alpha: 1)
        }
    }

}

public extension StemColor {
    
    enum HexFormatter {
        case auto
        case digits6
        case digits8
    }
    
    enum HexPrefixFormatter: String {
        /// "#"
        case hashKey = "#"
        /// "0x"
        case bits = "0x"
        /// ""
        case none = ""
    }

    func hexString(_ formatter: HexFormatter = .auto, prefix: HexPrefixFormatter = .hashKey) -> String {
        func map(_ value: Double) -> Int {
            if value.isNaN {
                return 255
            } else {
                return Int(round(value * 255))
            }
        }

        switch formatter {
        case .auto:
            return hexString(alpha >= 1 ? .digits6 : .digits8, prefix: prefix)
        case .digits6:
            return prefix.rawValue + String(format: "%02lX%02lX%02lX", map(rgbSpace.red), map(rgbSpace.green), map(rgbSpace.blue))
        case .digits8:
            return prefix.rawValue + String(format: "%02lX%02lX%02lX%02lX", map(alpha), map(rgbSpace.red), map(rgbSpace.green), map(rgbSpace.blue))
        }
    }

    /// 获取颜色16进制
    var uInt: UInt {
        var value: UInt = 0

        func map(_ value: Double) -> UInt {
            return UInt(round(value * 255))
        }

        value += map(alpha) << 24
        value += map(rgbSpace.red)   << 16
        value += map(rgbSpace.green) << 8
        value += map(rgbSpace.blue)
        return value
    }

}

public extension StemColor {

    var invert: StemColor {
        return StemColor(rgb: .init(red:   1 - rgbSpace.red,
                                    green: 1 - rgbSpace.green,
                                    blue:  1 - rgbSpace.blue),
                         alpha: alpha)
    }

}

public extension StemColor {
    
    @discardableResult
    func alpha(with value: Double) -> StemColor {
        self.alpha = value
        return self
    }

    static var random: StemColor { .init(rgb: .random, alpha: 1) }

}
