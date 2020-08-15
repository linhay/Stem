//
//  STColor.swift
//  Pods-macOS
//
//  Created by 林翰 on 2020/8/3.
//

import Foundation

// http://www.easyrgb.com/en/math.php
// https://zh.wikipedia.org/wiki/HSL%E5%92%8CHSV%E8%89%B2%E5%BD%A9%E7%A9%BA%E9%97%B4
public class StemColor {
    static let D65tristimulus = XYZSpace(x: 95.047, y: 100.0, z: 108.883)
    
    // value: 0 - 1.0
    public private(set) var alpha: Double = 1
    
    public struct RGBSpace: Codable, Equatable {
        // value: 0 - 1.0
        public let red: Double
        // value: 0 - 1.0
        public let green: Double
        // value: 0 - 1.0
        public let blue: Double
        
        public init(red: Double, green: Double, blue: Double) {
            self.red   = max(min(red,   1), 0)
            self.green = max(min(green, 1), 0)
            self.blue  = max(min(blue,  1), 0)
        }
        
        public init(space: XYZSpace) {
            let x = space.x
            let y = space.y
            let z = space.z
            
            func map(_ value: Double) -> Double {
                let value = value / 100
                if value > 0.0031308 {
                    return 1.055 * pow(value, 1/2.4) - 0.055
                } else {
                    return 12.92 * value
                }
            }
            
            let red   = map(x *  3.2404542 + y * -1.5371385 + z * -0.4985314)
            let green = map(x * -0.9692660 + y *  1.8760108 + z *  0.0415560)
            let blue  = map(x *  0.0556434 + y * -0.2040259 + z *  1.0572252)

            self.init(red: red, green: green, blue: blue)
        }
        
        public init(space: HSBSpace) {
            var red = 0.0
            var green = 0.0
            var blue = 0.0

            if space.saturation == 0 {
                red   = space.brightness
                green = space.brightness
                blue  = space.brightness
            } else {
                let hue = space.hue * 6
                let varI = floor(hue)
                let var1 = space.brightness * (1 - space.saturation)
                let var2 = space.brightness * (1 - space.saturation * (hue - varI))
                let var3 = space.brightness * (1 - space.saturation * (1 - (hue - varI)))
                
                switch varI {
                case 0:
                    red = space.brightness
                    green = var3
                    blue = var1
                case 1:
                    red = var2
                    green = space.brightness
                    blue = var1
                case 2:
                    red = var1
                    green = space.brightness
                    blue = var3
                case 3:
                    red = var1
                    green = var2
                    blue = space.brightness
                case 4:
                    red = var3
                    green = var1
                    blue = space.brightness
                default:
                    red = space.brightness
                    green = var1
                    blue = var2
                }
            }
            self.init(red: red, green: green, blue: blue)
        }
        
        public init(space: HSLSpace) {
            func map(v1: Double, v2: Double, hue: Double) -> Double {
                if 6 * hue < 1 {
                    return v1 + (v2 - v1) * 6 * hue
                }
                if 2 * hue < 1 {
                    return v2
                }
                if 3 * hue < 2 {
                    return v1 + (v2 - v1) * (2/3 - hue) * 6
                }
                return v1
            }
            
            let var2: Double
            if space.lightness < 0.5 {
                var2 = space.lightness * (1 + space.saturation)
            } else {
                var2 = (space.lightness + space.saturation) - (space.saturation * space.lightness)
            }

            let var1 = 2 * space.lightness - var2

            let red   = map(v1: var1, v2: var2, hue: space.hue + 1/3)
            let green = map(v1: var1, v2: var2, hue: space.hue)
            let blue  = map(v1: var1, v2: var2, hue: space.hue + 2/3)

            self.init(red: red, green: green, blue: blue)
        }
        
        public init(space: CMYSpace) {
            self.init(red: 1 - space.cyan,
                      green: 1 - space.magenta,
                      blue: 1 - space.yellow)
        }
    }
    
    public struct HSLSpace: Codable, Equatable {
        
        // value: 0 - 1.0
        public let hue: Double
        // value: 0 - 1.0
        public let saturation: Double
        // value: 0 - 1.0
        public let lightness: Double
        
        public init(hue: Double, saturation: Double, lightness: Double) {
            self.hue = abs(hue.truncatingRemainder(dividingBy: 1))
            self.saturation = max(min(saturation, 1), 0)
            self.lightness = max(min(lightness, 1), 0)
        }
        
        public init(from value: RGBSpace) {
            let red   = value.red
            let green = value.green
            let blue  = value.blue
            
            let Max = max(red, green, blue)
            let Min = min(red, green, blue)
            let delMax = Max - Min
            
            let lightness = (Max + Min) / 2
            self.lightness = lightness
            
            if delMax == 0 {
                hue = 0
                saturation = 0
            } else {
                if lightness < 0.5 {
                    saturation = delMax / (Max + Min)
                } else {
                    saturation = delMax / (2 - Max - Min)
                }
                
                let delRed   = (((Max - red)   / 6) + delMax / 2) / delMax
                let delGreen = (((Max - green) / 6) + delMax / 2) / delMax
                let delBlue  = (((Max - blue)  / 6) + delMax / 2) / delMax
                
                let hue: Double
                if red == Max {
                    hue = delBlue - delGreen
                } else if green == Max {
                    hue = 1/3 + delRed - delBlue
                } else if blue == Max {
                    hue = 2/3 + delGreen - delRed
                } else {
                    hue = 0
                }
                self.hue = abs(hue.truncatingRemainder(dividingBy: 1))
            }
        }
        
    }
    
    public struct HSBSpace: Codable, Equatable {
        // value: 0 - 1.0
        public let hue: Double
        // value: 0 - 1.0
        public let saturation: Double
        // value: 0 - 1.0
        public let brightness: Double
        
        public init(hue: Double, saturation: Double, brightness: Double) {
            self.hue = hue.truncatingRemainder(dividingBy: 1)
            self.saturation = max(min(saturation, 1), 0)
            self.brightness = max(min(brightness, 1), 0)
        }
        
        public init(from value: RGBSpace) {
            let red   = value.red
            let green = value.green
            let blue  = value.blue
            
            let Max = max(red, green, blue)
            let Min = min(red, green, blue)
            let delMax = Max - Min
            
            self.brightness = Max
            
            //h 0-360
            if delMax == 0 {
                hue = 0
                saturation = 0
            } else {
                saturation = delMax / Max
                
                let delRed   = (((Max - red)   / 6) + delMax / 2) / delMax
                let delGreen = (((Max - green) / 6) + delMax / 2) / delMax
                let delBlue  = (((Max - blue)  / 6) + delMax / 2) / delMax
                
                let hue: Double
                if red == Max {
                    hue = delBlue - delGreen
                } else if green == Max {
                    hue = (1 / 3) + delRed - delBlue
                } else if blue == Max {
                    hue = (2 / 3) + delGreen - delRed
                } else {
                    hue = 0
                }
                self.hue = hue.truncatingRemainder(dividingBy: 1)
            }
            
        }
    }
    
    public struct XYZSpace: Codable, Equatable {
        
        public let x: Double
        public let y: Double
        public let z: Double
        
        public init(x: Double, y: Double, z: Double) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        public init(from value: RGBSpace) {
            func map(_ value: Double) -> Double {
                if value > 0.04045 {
                    return pow((value + 0.055) / 1.055, 2.4)
                } else {
                    return value / 12.92
                }
            }
            
            let r = map(value.red)
            let g = map(value.green)
            let b = map(value.blue)
            
            x = r * 41.24564 + g * 35.75761 + b * 18.04375
            y = r * 21.26729 + g * 71.51522 + b * 07.21750
            z = r * 01.93339 + g * 11.91920 + b * 95.03041
        }
        
        public init(from value: LABSpace, tristimulus: XYZSpace? = nil) {
            func map(_ value: Double) -> Double {
                if (value > (6.0 / 29.0)) {
                    return pow(value, 3.0)
                } else {
                    return 3.0 * pow(6.0 / 29.0, 2.0) * (value - (4.0 / 29.0))
                }
            };
            let y = (1.0 / 116.0) * (value.l + 16.0)
            
            let tristimulus = tristimulus ?? D65tristimulus
            self.y = tristimulus.y * map(y)
            self.x = tristimulus.x * map(y + value.a / 500.0)
            self.z = tristimulus.z * map(y - value.b / 200.0)
        }
        
    }
    
    public struct LABSpace: Codable, Equatable {
        public let l: Double
        public let a: Double
        public let b: Double
        
        public init(l: Double, a: Double, b: Double) {
            self.l = l
            self.a = a
            self.b = b
        }
        
        public init(from value: XYZSpace, tristimulus: XYZSpace? = nil) {
            
            func map(_ value: Double) -> Double {
                if (value > pow(6.0 / 29.0, 3.0)) {
                    return pow(value, 1.0 / 3.0)
                } else {
                    return ((1.0 / 3.0) * pow(29.0 / 6.0, 2.0) * value) + (4.0 / 29.0)
                }
            }
            
            let tristimulus = tristimulus ?? D65tristimulus
            let fx = map(value.x / tristimulus.x)
            let fy = map(value.y / tristimulus.y)
            let fz = map(value.z / tristimulus.z)
            
            l = (116.0 * fy) - 16.0
            a = 500 * (fx - fy)
            b = 200 * (fy - fz)
        }
        
    }
    
    public struct CMYSpace: Codable, Equatable {
        // value: 0 - 1.0
        public let cyan: Double
        // value: 0 - 1.0
        public let magenta: Double
        // value: 0 - 1.0
        public let yellow: Double
        
        public init(from value: RGBSpace) {
            cyan    = 1 - value.red
            magenta = 1 - value.green
            yellow  = 1 - value.blue
        }
        
        public init(from value: CMYKSpace) {
            cyan    = value.cyan * (1 - value.key) + value.key
            magenta = value.magenta * (1 - value.key) + value.key
            yellow  = value.yellow * (1 - value.key) + value.key
        }
    }
    
    public struct CMYKSpace: Codable, Equatable {
        // value: 0 - 1.0
        public let cyan: Double
        // value: 0 - 1.0
        public let magenta: Double
        // value: 0 - 1.0
        public let yellow: Double
        // value: 0 - 1.0
        public let key: Double
        
        public init(from value: CMYSpace) {
            let key = min(value.cyan, value.magenta, value.yellow)
            self.key = key
            
            if key == 1 {
                cyan = 0
                magenta = 0
                yellow = 0
            } else {
                cyan    = (value.cyan - key) / (1 - key)
                magenta = (value.magenta - key) / (1 - key)
                yellow  = (value.yellow - key) / (1 - key)
            }
        }
    }
    
    public var rgbSpace: RGBSpace
    public var xyzSpace: XYZSpace   { .init(from: rgbSpace) }
    public var labSpace: LABSpace   { .init(from: xyzSpace) }
    public var hslSpace: HSLSpace   { .init(from: rgbSpace) }
    public var hsbSpace: HSBSpace   { .init(from: rgbSpace) }
    public var cmySpace: CMYSpace   { .init(from: rgbSpace) }
    public var cmykSpace: CMYKSpace { .init(from: cmySpace) }
    
    public convenience init(cmyk space: CMYKSpace, alpha: Double = 1) {
        self.init(rgb: RGBSpace(space: CMYSpace(from: space)), alpha: alpha)
    }

    public convenience init(lab space: LABSpace, alpha: Double = 1) {
        self.init(rgb: RGBSpace(space: XYZSpace(from: space)), alpha: alpha)
    }

    public convenience init(cmy space: CMYSpace, alpha: Double = 1) {
        self.init(rgb: RGBSpace(space: space), alpha: alpha)
    }
    
    public convenience init(xyz space: XYZSpace, alpha: Double = 1) {
        self.init(rgb: RGBSpace(space: space), alpha: alpha)
    }
    
    public convenience init(hsl space: HSLSpace, alpha: Double = 1) {
        self.init(rgb: RGBSpace(space: space), alpha: alpha)
    }
    
    public convenience init(hsb space: HSBSpace, alpha: Double = 1) {
        self.init(rgb: RGBSpace(space: space), alpha: alpha)
    }
    
    public init(rgb space: RGBSpace, alpha: Double = 1) {
        self.rgbSpace = space
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
        
        if count <= 6 {
            self.init(rgb: RGBSpace(red:   Double((value & 0xFF0000) >> 16) / 255,
                                    green: Double((value & 0x00FF00) >> 8) / 255,
                                    blue:  Double(value & 0x0000FF) / 255))
        } else if count <= 8 {
            self.init(rgb: RGBSpace(red:   Double((value & 0x00FF0000) >> 16) / 255,
                                    green: Double((value & 0x0000FF00) >> 8) / 255,
                                    blue:  Double(value & 0x000000FF) / 255),
                      alpha: Double((value & 0xFF000000) >> 24) / 255)
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
    
    /// 随机色
    static var random: StemColor {
        let red   = Double.random(in: 0.0 ... 255) / 255
        let green = Double.random(in: 0.0 ... 255) / 255
        let blue  = Double.random(in: 0.0 ... 255) / 255
        return .init(rgb: .init(red: red, green: green, blue: blue), alpha: 1)
    }
    
}

public extension StemColor {
    
    var invert: StemColor {
        return StemColor(rgb: .init(red:   1 - rgbSpace.red,
                                    green: 1 - rgbSpace.green,
                                    blue:  1 - rgbSpace.blue),
                         alpha: alpha)
    }
    
    func lighter(amount: Double = 0.25) -> StemColor {
        var space = hsbSpace
        let brightness = space.brightness * (1 + amount)
        space = HSBSpace(hue: space.hue, saturation: space.saturation, brightness: brightness)
        return .init(hsb: space)
    }
    
    func darker(amount: Double = 0.25) -> StemColor {
        var space = hsbSpace
        let brightness = space.brightness * (1 - amount)
        space = HSBSpace(hue: space.hue, saturation: space.saturation, brightness: brightness)
        return .init(hsb: space)
    }
    
}
