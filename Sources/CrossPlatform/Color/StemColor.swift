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
    
    // value: 0 - 1.0
    public private(set) var alpha: Double = 1
    
    public struct RGBSpace {
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
        
        public init(space: HSBSpace) {
            if space.saturation == 0 {
                self.red   = space.brightness
                self.green = space.brightness
                self.blue  = space.brightness
            } else {
                let hue = space.hue * 6
                let varI = floor(hue)
                let var1 = space.brightness * (1 - space.saturation)
                let var2 = space.brightness * (1 - space.saturation * (hue - varI))
                let var3 = space.brightness * (1 - space.saturation * (1 - (hue - varI)))

                switch varI {
                case 0:
                    self.red = space.brightness
                    self.green = var3
                    self.blue = var1
                case 1:
                    self.red = var2
                    self.green = space.brightness
                    self.blue = var1
                case 2:
                    self.red = var1
                    self.green = space.brightness
                    self.blue = var3
                case 3:
                    self.red = var1
                    self.green = var2
                    self.blue = space.brightness
                case 4:
                    self.red = var3
                    self.green = var1
                    self.blue = space.brightness
                default:
                    self.red = space.brightness
                    self.green = var1
                    self.blue = var2
                }
            }
            
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

            if space.saturation == 0 {
                self.red = 1
                self.green = 1
                self.blue = 1
            } else {
                let var2: Double
                if space.lightness < 0.5 {
                    var2 = space.lightness * (1 + space.saturation)
                } else {
                    var2 = (space.lightness + space.saturation) - (space.saturation * space.lightness)
                }

                let var1 = 2 * space.lightness - var2

                self.red   = map(v1: var1, v2: var2, hue: space.hue + 1/3)
                self.green = map(v1: var1, v2: var2, hue: space.hue)
                self.blue  = map(v1: var1, v2: var2, hue: space.hue + 2/3)
            }
        }
        
    }
    
    public struct HSLSpace {
        
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
    
    public struct HSBSpace {
        // value: 0 - 1.0
        let hue: Double
        // value: 0 - 1.0
        let saturation: Double
        // value: 0 - 1.0
        let brightness: Double

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
    
    public struct XYZSpace {
        
        public let x: Double
        public let y: Double
        public let z: Double
        
        public init(from value: RGBSpace) {
            let map: (Double) -> Double = { value in
                return (value > 0.04045) ? pow((value + 0.055) / 1.055, 2.40) : (value / 12.92)
            }
            let red   = map(value.red   / 255)
            let green = map(value.green / 255)
            let blue  = map(value.blue  / 255)
            x = (red * 41.24 + green * 35.76 + blue * 18.05)
            y = (red * 21.26 + green * 71.52 + blue * 7.22)
            z = (red * 1.93  + green * 11.92 + blue * 95.05)
        }
        
    }
    
    public var rgbSpace: RGBSpace
    public var xyzSpace: XYZSpace { XYZSpace(from: rgbSpace) }
    public var hslSpace: HSLSpace { HSLSpace(from: rgbSpace) }
    public var hsbSpace: HSBSpace { HSBSpace(from: rgbSpace) }

    public init(hsl space: HSLSpace, alpha: Double = 1) {
        self.rgbSpace = RGBSpace(space: space)
        self.alpha = alpha
    }

    public init(hsb space: HSBSpace, alpha: Double = 1) {
        self.rgbSpace = RGBSpace(space: space)
        self.alpha = alpha
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
        if alpha == 1 {
            return String(format: "#%02lX%02lX%02lX", Int(rgb.red), Int(rgb.green), Int(rgb.blue))
        } else {
            return String(format: "#%02lX%02lX%02lX%02lX", Int(alpha), Int(rgb.red), Int(rgb.green), Int(rgb.blue))
        }
    }
    
    /// 获取颜色16进制
    var uInt: UInt {
        var colorAsUInt32: UInt = 0
        colorAsUInt32 += UInt(alpha * 255)    << 24
        colorAsUInt32 += UInt(rgbSpace.red)   << 16
        colorAsUInt32 += UInt(rgbSpace.green) << 8
        colorAsUInt32 += UInt(rgbSpace.blue)
        return UInt(colorAsUInt32)
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
    
}
