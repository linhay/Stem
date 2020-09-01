//
//  STColor.swift
//  Pods-macOS
//
//  Created by 林翰 on 2020/8/3.
//

import Foundation

extension StemColorRGBSpaceConversion {

    init(space: StemColor.RGBSpace) {
        self.init(red: space.red, green: space.green, blue: space.blue)
    }

    var rgbSpace: StemColor.RGBSpace {
        let (red, green, blue) = convertToRGB
        return .init(red: red, green: green, blue: blue)
    }

}

extension StemColorCMYKSpaceConversion {

    init(space: StemColor.CMYKSpace) {
        self.init(cyan: space.cyan, magenta: space.magenta, yellow: space.yellow, key: space.key)
    }

    var cmykSpace: StemColor.CMYKSpace {
        let (c, m, y, k) = convertToCMYK
        return .init(cyan: c, magenta: m, yellow: y, key: k)
    }

}

extension StemColorCIELABSpaceConversion {

    init(space: StemColor.CIELABSpace) {
        self.init(l: space.l, a: space.a, b: space.b)
    }

    var labSpace: StemColor.CIELABSpace {
        let (l, a, b) = convertToLAB
        return .init(l: l, a: a, b: b)
    }

}

// http://www.easyrgb.com/en/math.php
// https://zh.wikipedia.org/wiki/HSL%E5%92%8CHSV%E8%89%B2%E5%BD%A9%E7%A9%BA%E9%97%B4
public class StemColor {

    // value: 0 - 1.0
    public private(set) var alpha: Double = 1

    public var rgbSpace: RGBSpace
    public var xyzSpace: CIEXYZSpace   { .init(space: rgbSpace) }
    public var labSpace: CIELABSpace   { xyzSpace.labSpace }
    public var hslSpace: HSLSpace   { .init(space: rgbSpace) }
    public var hsbSpace: HSBSpace   { .init(space: rgbSpace) }
    public var cmySpace: CMYSpace   { .init(space: rgbSpace) }
    public var cmykSpace: CMYKSpace { cmySpace.cmykSpace }

    public convenience init(cmyk space: CMYKSpace, alpha: Double = 1) {
        self.init(rgb: CMYSpace(space: space).rgbSpace, alpha: alpha)
    }

    public convenience init(lab space: CIELABSpace, alpha: Double = 1) {
        self.init(rgb: CIEXYZSpace(space: space).rgbSpace, alpha: alpha)
    }

    public convenience init(cmy space: CMYSpace, alpha: Double = 1) {
        self.init(rgb: space.rgbSpace, alpha: alpha)
    }

    public convenience init(xyz space: CIEXYZSpace, alpha: Double = 1) {
        self.init(rgb: space.rgbSpace, alpha: alpha)
    }

    public convenience init(hsl space: HSLSpace, alpha: Double = 1) {
        self.init(rgb: space.rgbSpace, alpha: alpha)
    }

    public convenience init(hsb space: HSBSpace, alpha: Double = 1) {
        self.init(rgb: space.rgbSpace, alpha: alpha)
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

    /// 获取hex字符
    var hexString: String {
        let rgb = self.rgbSpace

        func map(_ value: Double) -> Int {
            return Int(round(value * 255))
        }

        if alpha == 1 {
            return String(format: "#%02lX%02lX%02lX", map(rgb.red), map(rgb.green), map(rgb.blue))
        } else {
            return String(format: "#%02lX%02lX%02lX%02lX", map(alpha), map(rgb.red), map(rgb.green), map(rgb.blue))
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

    static var random: StemColor { .init(rgb: .random, alpha: 1) }

}
