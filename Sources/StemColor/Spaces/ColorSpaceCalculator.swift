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
import simd

public extension StemColor {

    static let spaceCalculator = SpaceCalculator()
    
    struct SpaceCalculator { }

}

// MARK: - RGB <=> HSL
public extension StemColor.SpaceCalculator {
    
    func convert(_ space: StemColor.RGBSpace) -> StemColor.HSLSpace {
        let (red, green, blue) = (space.red, space.green, space.blue)
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
        var ryb = space.simd
        let w = ryb.min()
        
        ryb -= w
        let my = ryb.max()
        
        var rgb = SIMD3(ryb.x, min(ryb.y, ryb.z), ryb.z)
        let matrix = SIMD3(0, ryb.y, ryb.y)
        
        rgb -= matrix
        if rgb.z != 0, rgb.y != 0 {
            rgb *= SIMD3(1, 2, 2)
        }
        rgb += matrix

        let mg = rgb.max()
        if mg != 0 {
            rgb *= my / mg
        }
        
        rgb += w
        return .init(rgb)
    }
    
    func convert(_ space: StemColor.RGBSpace) -> StemColor.RYBSpace {
        var rgb = space.simd
        let w = rgb.min()
        rgb -= w
        let mg = rgb.max()
        
        var ryb = SIMD3(rgb.x, min(rgb.x, rgb.y), rgb.z)
        rgb -= SIMD3(ryb.y, ryb.y, 0)

        if rgb.z != 0, rgb.y != 0 {
            rgb /= SIMD3(1, 2, 2)
        }
        
        ryb += SIMD3(0, rgb.y, rgb.y)
        
        let my = ryb.max()
        
        if my != 0 {
            ryb *= mg / my
        }
        
        ryb += w
        return .init(ryb)
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
        guard let key = space.list.min(), key != 1 else {
            return .init(cyan: 0, magenta: 0, yellow: 0, key: 1)
        }
        
        let vector = (space.simd - key) / (1 - key)
        return .init(cyan: vector.x, magenta: vector.y, yellow: vector.z, key: key)
    }
    
    func convert(_ space: StemColor.CMYKSpace) -> StemColor.CMYSpace {
        var vector = SIMD3(space.cyan, space.magenta, space.yellow)
        vector *= 1 - space.key
        vector += space.key
        return .init(vector)
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
        let (red, green, blue) = (space.red, space.green, space.blue)

        let Max = max(red, green, blue)
        let Min = min(red, green, blue)
        let delMax = Max - Min
        
        var hue = 0.0
        var saturation = 0.0
        let brightness = Max
        
        //h 0-360
        if delMax != 0 {
            saturation = delMax / Max
            
            var vector = SIMD3(Max, Max, Max) - space.simd
            vector /= 6
            vector += delMax / 2
            vector /= delMax
            
            if red == Max {
                hue = vector.z - vector.y
            } else if green == Max {
                hue = (1 / 3) + vector.x - vector.z
            } else if blue == Max {
                hue = (2 / 3) + vector.y - vector.x
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
        func map(_ value: Double) -> Double {
            if value > 0.0031308 {
                return 1.055 * pow(value, 1/2.4) - 0.055
            } else {
                return 12.92 * value
            }
        }
        
        let matrix = simd_double3x3([
            SIMD3( 3.2404542, -0.9692660,  0.0556434),
            SIMD3(-1.5371385,  1.8760108, -0.2040259),
            SIMD3(-0.4985314,  0.0415560,  1.0572252)
        ])
        
        let vector = matrix * space.simd
        return .init(red: map(vector.x), green: map(vector.y), blue: map(vector.z))
    }
    
    func convert(_ space: StemColor.RGBSpace, illuminants: CIEStandardIlluminants) -> StemColor.CIEXYZSpace {
        
        func map(_ value: Double) -> Double {
            if value > 0.04045 {
                return pow((value + 0.055) / 1.055, 2.4)
            } else {
                return value / 12.92
            }
        }
        
        let matrix = simd_double3x3([
            SIMD3(0.4124564, 0.2126729, 0.0193339),
            SIMD3(0.3575761, 0.7151522, 0.1191920),
            SIMD3(0.1804375, 0.0721750, 0.9503041)
        ])
               
        let vector = matrix * SIMD3(map(space.red), map(space.green), map(space.blue))
        return .init(vector, illuminants: illuminants)
    }
    
}

// MARK: - CIELAB <=> CIEXYZ
public extension StemColor.SpaceCalculator {

    /// https://en.wikipedia.org/wiki/CIELAB_color_space
    func convert(_ space: StemColor.CIEXYZSpace) -> StemColor.CIELABSpace {
        
        func map(_ value: Double) -> Double {
            let delta = 6.0 / 29.0
            if (value > pow(delta, 3.0)) {
                return pow(value, 1.0 / 3.0)
            } else {
                return ((value / 3.0 * pow(delta, 2.0))) + (4.0 / 29.0)
            }
        }

        var vector = space.simd / space.illuminants.simd
        vector = .init(map(vector.x), map(vector.y), map(vector.z))
        vector = .init(-16 + (116.0 * vector.y),
                       500 * (vector.x - vector.y),
                       200 * (vector.y - vector.z))
        
        return .init(vector, illuminants: space.illuminants)
    }
    
    func convert(_ space: StemColor.CIELABSpace) -> StemColor.CIEXYZSpace {
        
        func map(_ value: Double) -> Double {
            let delta = 6.0 / 29.0
            if (value > delta) {
                return pow(value, 3.0)
            } else {
                return 3.0 * pow(delta, 2.0) * (value - (4.0 / 29.0))
            }
        }
        
        let y = (space.l + 16.0) / 116
        
        return .init(x: space.illuminants.x * map(y + space.a / 500.0),
                     y: space.illuminants.y * map(y),
                     z: space.illuminants.z * map(y - space.b / 200.0),
                     illuminants: space.illuminants)
    }
    
}

// MARK: - RGB <=> CIELAB
public extension StemColor.SpaceCalculator {
    
    func convert(_ space: StemColor.RGBSpace, illuminants: CIEStandardIlluminants) -> StemColor.CIELABSpace {
        let temp: StemColor.CIEXYZSpace = convert(space, illuminants: illuminants)
        return convert(temp)
    }
    
    func convert(_ space: StemColor.CIELABSpace) -> StemColor.RGBSpace {
        let temp: StemColor.CIEXYZSpace = convert(space)
        return convert(temp)
    }
    
}
