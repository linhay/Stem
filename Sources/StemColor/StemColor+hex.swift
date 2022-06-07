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
        guard cString.count == 6 || cString.count == 8 else {
            throw ThrowError("StemColor: 位数错误, 只支持 6 或 8 位, value: \(value)")
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
            throw ThrowError("StemColor: 位数错误, 只支持 6 或 8 位, value: \(value)")
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
