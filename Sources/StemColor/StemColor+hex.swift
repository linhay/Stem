//
//  File.swift
//  
//
//  Created by linhey on 2022/6/6.
//

import Foundation

public extension StemColor {

    /// 十六进制色: 0x666666
    ///
    /// - Parameter str: "#666666" / "0X666666" / "0x666666"
    convenience init(_ value: String) {
        do {
            try self.init(throwing: value)
        } catch {
            self.init(rgb: .init(red: 0, green: 0, blue: 0))
        }
    }
    
    /// 十六进制色: 0x666666
    ///
    /// - Parameter RGBValue: 十六进制颜色
    convenience init(_ value: Int) {
        do {
            try self.init(throwing: value)
        } catch {
            self.init(rgb: .init(red: 0, green: 0, blue: 0))
        }
    }
    
    /// 十六进制色: 0x666666
    ///
    /// - Parameter str: "#666666" / "0X666666" / "0x666666"
    convenience init(throwing value: String) throws {
        var cString = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("0X") { cString = String(cString.dropFirst(2)) }
        if cString.hasPrefix("#") { cString = String(cString.dropFirst(1)) }
        guard CharacterSet(charactersIn: cString).isSubset(of: .decimalDigits.union(.init(charactersIn: "A"..."F"))) else {
            throw ThrowError("StemColor: 无法解析, value: \(value)")
        }
        var value: UInt64 = 0x0
        Scanner(string: String(cString)).scanHexInt64(&value)
        self.init(Int(value))
    }

    /// 十六进制色: 0x666666
    ///
    /// - Parameter RGBValue: 十六进制颜色
    convenience init(throwing value: Int) throws {
        var hex = value
        var count = 0

        while count <= 8, hex > 0 {
            hex = hex >> 4
            count += 1
            if count > 8 { break }
        }
        
        let a, r, g, b: Int
        switch count {
        case 3: // 0xRGB
            (a, r, g, b) = (255, (hex >> 8) * 17, (hex >> 4 & 0xF) * 17, (hex & 0xF) * 17)
        case 6: // 0xRRGGBB
            (a, r, g, b) = (255, hex >> 16, hex >> 8 & 0xFF, hex & 0xFF)
        case 8: // 0xRRGGBBAA
            (r, g, b, a) = (hex >> 24, hex >> 16 & 0xFF, hex >> 8 & 0xFF, hex & 0xFF)
        default:
            throw ThrowError("StemColor: 位数错误, 只支持 3/6/8 位, value: \(value)")
        }
        self.init(rgb: RGBSpace(red: Double(r), green: Double(g), blue: Double(b)), alpha: Double(a))
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
