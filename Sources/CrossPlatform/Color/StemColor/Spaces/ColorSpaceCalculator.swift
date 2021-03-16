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

    static let spaceCalculator = SpaceCalculator()
    
    struct SpaceCalculator { }

}

// MARK: - RGB <=> HSL
public extension StemColor.SpaceCalculator {
    
    func convert(_ space: StemColor.RGBSpace) -> StemColor.HSLSpace {
        let (red, green, blue) = space.unpack
        let Max = max(red, green, blue)
        let Min = min(red, green, blue)
        let delMax = Max - Min
        
        var hue = 0.0
        var saturation = 0.0
        let lightness = (Max + Min) / 2
        
        if delMax != 0 {
            if lightness < 0.5 {
                saturation = delMax / (Max + Min)
            } else {
                saturation = delMax / (2 - Max - Min)
            }
            
            let delRed   = (((Max - red)   / 6) + delMax / 2) / delMax
            let delGreen = (((Max - green) / 6) + delMax / 2) / delMax
            let delBlue  = (((Max - blue)  / 6) + delMax / 2) / delMax
            
            if red == Max {
                hue = delBlue - delGreen
            } else if green == Max {
                hue = 1/3 + delRed - delBlue
            } else if blue == Max {
                hue = 2/3 + delGreen - delRed
            } else {
                hue = 0
            }
        }
        return .init(hue: hue, saturation: saturation, lightness: lightness)
    }
    
    func convert(_ space: StemColor.HSLSpace) -> StemColor.RGBSpace {
        func map(v1: Double, v2: Double, hue: Double) -> Double {
            var hue = hue
            if hue < 0 { hue += 1 }
            else if hue > 1 { hue -= 1 }
            
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
        
        let (hue, saturation, lightness) = space.unpack
        let var2: Double
        if lightness < 0.5 {
            var2 = lightness * (1 + saturation)
        } else {
            var2 = (lightness + saturation) - (saturation * lightness)
        }
        
        let var1 = 2 * lightness - var2
        
        let red   = map(v1: var1, v2: var2, hue: hue + 1/3)
        let green = map(v1: var1, v2: var2, hue: hue)
        let blue  = map(v1: var1, v2: var2, hue: hue + 2/3)
        
        return .init(red: red, green: green, blue: blue)
    }
    
}

// MARK: - RGB <=> RYB
public extension StemColor.SpaceCalculator {
    
    func convert(_ space: StemColor.RYBSpace) -> StemColor.RGBSpace {
        var (r, y, b) = space.unpack
        
        let w = min(r, y, b)
        r -= w
        y -= w
        b -= w
        
        let my = max(r, y, b)
        var g = min(y, b)
        y -= g
        b -= g
        
        if b != 0, g != 0 {
            b *= 2
            g *= 2
        }
        
        r += y
        g += y
        
        let mg = max(r, g, b)
        if mg != 0 {
            let n = my / mg
            r *= n
            g *= n
            b *= n
        }
        
        r += w
        g += w
        b += w
        
        return .init(red: r, green: g, blue: b)
    }
    
    func convert(_ space: StemColor.RGBSpace) -> StemColor.RYBSpace {
        var (r, g, b) = space.unpack
        let w = min(r, g, b)
        r -= w
        g -= w
        b -= w
        
        let mg = max(r, g, b)
        
        var y = min(r, g)
        r -= y
        g -= y
        
        if b != 0, g != 0 {
            b /= 2.0
            g /= 2.0
        }
        
        y += g
        b += g
        
        let my = max(r, y, b)
        if my != 0 {
            let n = mg / my
            r *= n
            y *= n
            b *= n
        }
        
        r += w
        y += w
        b += w
        
        return .init(red: r, yellow: y, blue: b)
    }
    
}

// MARK: - RGB <=> CMY
public extension StemColor.SpaceCalculator {
    
    func convert(_ space: StemColor.CMYSpace) -> StemColor.RGBSpace {
        return .init(red: 1 - space.cyan, green: 1 - space.magenta, blue: 1 - space.yellow)
    }
    
    func convert(_ space: StemColor.RGBSpace) -> StemColor.CMYSpace {
        return .init(cyan: 1 - space.red, magenta: 1 - space.green, yellow: 1 - space.blue)
    }
    
}

// MARK: - CMY <=> CMYK
public extension StemColor.SpaceCalculator {
    
    func convert(_ space: StemColor.CMYSpace) -> StemColor.CMYKSpace {
        var (cyan, magenta, yellow) = space.unpack
        let key = min(cyan, magenta, yellow)
        if key == 1 {
            cyan = 0
            magenta = 0
            yellow = 0
        } else {
            cyan    = (cyan - key)    / (1 - key)
            magenta = (magenta - key) / (1 - key)
            yellow  = (yellow - key)  / (1 - key)
        }
        
        return .init(cyan: cyan, magenta: magenta, yellow: yellow, key: key)
    }
    
    func convert(_ space: StemColor.CMYKSpace) -> StemColor.CMYSpace {
        var (cyan, magenta, yellow, key) = space.unpack
        cyan    = cyan    * (1 - key) + key
        magenta = magenta * (1 - key) + key
        yellow  = yellow  * (1 - key) + key
        return .init(cyan: cyan, magenta: magenta, yellow: yellow)
    }
    
}

// MARK: - RGB <=> CIELAB
public extension StemColor.SpaceCalculator {
    
    func convert(_ space: StemColor.RGBSpace) -> StemColor.CMYKSpace {
        let temp: StemColor.CMYSpace = convert(space)
        return convert(temp)
    }
    
    func convert(_ space: StemColor.CMYKSpace) -> StemColor.RGBSpace {
        let temp: StemColor.CMYSpace = convert(space)
        return convert(temp)
    }
    
}


// MARK: - RGB <=> HSB
public extension StemColor.SpaceCalculator {
    
    func convert(_ space: StemColor.HSBSpace) -> StemColor.RGBSpace {
        var (red, green, blue) = (0.0, 0.0, 0.0)
        let (hue, saturation, brightness) = space.unpack
        
        if saturation == 0 {
            red   = brightness
            green = brightness
            blue  = brightness
        } else {
            let hue = hue * 6
            let varI = floor(hue)
            let var1 = brightness * (1 - saturation)
            let var2 = brightness * (1 - saturation * (hue - varI))
            let var3 = brightness * (1 - saturation * (1 - (hue - varI)))
            
            switch varI {
            case 0:
                red = brightness
                green = var3
                blue = var1
            case 1:
                red = var2
                green = brightness
                blue = var1
            case 2:
                red = var1
                green = brightness
                blue = var3
            case 3:
                red = var1
                green = var2
                blue = brightness
            case 4:
                red = var3
                green = var1
                blue = brightness
            default:
                red = brightness
                green = var1
                blue = var2
            }
        }
        return .init(red: red, green: green, blue: blue)
    }
    
    func convert(_ space: StemColor.RGBSpace) -> StemColor.HSBSpace {
        let (red, green, blue) = space.unpack
        
        let Max = max(red, green, blue)
        let Min = min(red, green, blue)
        let delMax = Max - Min
        
        var hue = 0.0
        var saturation = 0.0
        let brightness = Max
        
        //h 0-360
        if delMax != 0 {
            saturation = delMax / Max
            
            let delRed   = (((Max - red)   / 6) + delMax / 2) / delMax
            let delGreen = (((Max - green) / 6) + delMax / 2) / delMax
            let delBlue  = (((Max - blue)  / 6) + delMax / 2) / delMax
            
            if red == Max {
                hue = delBlue - delGreen
            } else if green == Max {
                hue = (1 / 3) + delRed - delBlue
            } else if blue == Max {
                hue = (2 / 3) + delGreen - delRed
            } else {
                hue = 0
            }
        }
        
        return .init(hue: hue, saturation: saturation, brightness: brightness)
    }
    
}

// MARK: - RGB <=> CIEXYZ
public extension StemColor.SpaceCalculator {
    
    func convert(_ space: StemColor.CIEXYZSpace) -> StemColor.RGBSpace {
        let (x, y, z) = space.unpack
        
        func map(_ value: Double) -> Double {
            if value > 0.0031308 {
                return 1.055 * pow(value, 1/2.4) - 0.055
            } else {
                return 12.92 * value
            }
        }
        
        let red   = map(x *  3.2404542 + y * -1.5371385 + z * -0.4985314)
        let green = map(x * -0.9692660 + y *  1.8760108 + z *  0.0415560)
        let blue  = map(x *  0.0556434 + y * -0.2040259 + z *  1.0572252)
        
        return .init(red: red, green: green, blue: blue)
    }
    
    func convert(_ space: StemColor.RGBSpace) -> StemColor.CIEXYZSpace {
        func map(_ value: Double) -> Double {
            if value > 0.04045 {
                return pow((value + 0.055) / 1.055, 2.4)
            } else {
                return value / 12.92
            }
        }
        
        let r = map(space.red)
        let g = map(space.green)
        let b = map(space.blue)
        
        let x = (r * 41.24564 + g * 35.75761 + b * 18.04375) / 100
        let y = (r * 21.26729 + g * 71.51522 + b * 07.21750) / 100
        let z = (r * 01.93339 + g * 11.91920 + b * 95.03041) / 100
        
        return .init(x: x, y: y, z: z, illuminants: .D65)
    }
    
}

// MARK: - CIELAB <=> CIEXYZ
public extension StemColor.SpaceCalculator {
    
    func convert(_ space: StemColor.CIEXYZSpace) -> StemColor.CIELABSpace {
        func map(_ value: Double) -> Double {
            if (value > pow(6.0 / 29.0, 3.0)) {
                return pow(value, 1.0 / 3.0)
            } else {
                return ((1.0 / 3.0) * pow(29.0 / 6.0, 2.0) * value) + (4.0 / 29.0)
            }
        }
        
        let fx = map(space.x * 100 / (space.illuminants.rawValue[0] * 100))
        let fy = map(space.y * 100 / (space.illuminants.rawValue[1] * 100))
        let fz = map(space.z * 100 / (space.illuminants.rawValue[2] * 100))
        
        let l = (116.0 * fy) - 16.0
        let a = 500 * (fx - fy)
        let b = 200 * (fy - fz)
        
        return .init(l: l, a: a, b: b, illuminants: space.illuminants)
    }
    
    func convert(_ space: StemColor.CIELABSpace) -> StemColor.CIEXYZSpace {
        func map(_ value: Double) -> Double {
            if (value > (6.0 / 29.0)) {
                return pow(value, 3.0)
            } else {
                return 3.0 * pow(6.0 / 29.0, 2.0) * (value - (4.0 / 29.0))
            }
        }
        
        let y = (space.l + 16.0) / 116
        
        return .init(x: space.illuminants.rawValue[0] * map(y + space.a / 500.0),
                     y: space.illuminants.rawValue[1] * map(y),
                     z: space.illuminants.rawValue[2] * map(y - space.b / 200.0),
                     illuminants: space.illuminants)
    }
    
}

// MARK: - RGB <=> CIELAB
public extension StemColor.SpaceCalculator {
    
    func convert(_ space: StemColor.RGBSpace) -> StemColor.CIELABSpace {
        let temp: StemColor.CIEXYZSpace = convert(space)
        return convert(temp)
    }
    
    func convert(_ space: StemColor.CIELABSpace) -> StemColor.RGBSpace {
        let temp: StemColor.CIEXYZSpace = convert(space)
        return convert(temp)
    }
    
}
