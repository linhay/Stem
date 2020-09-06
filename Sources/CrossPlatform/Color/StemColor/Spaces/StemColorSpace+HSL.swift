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

    struct HSLSpace: StemColorSpace {
        public private(set) var ranges: [ClosedRange<Double>] = [0...1, 0...1, 0...1]
        // value: 0 - 1.0
        public let hue: Double
        // value: 0 - 1.0
        public let saturation: Double
        // value: 0 - 1.0
        public let lightness: Double

        public init(hue: Double, saturation: Double, lightness: Double) {
            if hue > 1 {
                self.hue = hue.truncatingRemainder(dividingBy: 1)
            } else if hue < 0 {
                self.hue = hue.truncatingRemainder(dividingBy: 1) + 1
            } else {
                self.hue = hue
            }
            self.saturation = max(min(saturation, 1), 0)
            self.lightness = max(min(lightness, 1), 0)
        }

    }
    
}

public extension StemColor.HSLSpace {

    func lighter(amount: Double = 0.25) -> Self {
        return lightness(with: lightness * (1 + amount))
    }

    func darker(amount: Double = 0.25) -> Self {
        return lightness(with: lightness * (1 - amount))
    }

}

public extension StemColor.HSLSpace {

    func hue(with value: Double)        -> Self { .init(hue: value, saturation: saturation, lightness: lightness) }
    func saturation(with value: Double) -> Self { .init(hue: hue, saturation: value, lightness: lightness)   }
    func lightness(with value: Double)  -> Self { .init(hue: hue, saturation: saturation, lightness: value)  }

}

extension StemColor.HSLSpace: StemColorRGBSpaceConversion {

    public var convertToRGB: (red: Double, green: Double, blue: Double) {
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

       return (red, green, blue)
    }

    public init(red: Double, green: Double, blue: Double) {
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
        self.init(hue: hue, saturation: saturation, lightness: lightness)
    }

}

extension StemColor.HSLSpace: StemColorSpacePack {

    public var unpack: (hue: Double, saturation: Double, lightness: Double) { (hue, saturation, lightness) }
    public var list: [Double] { [hue, saturation, lightness] }

    public init(_ list: [Double]) {
        self.init(hue: list[0], saturation: list[1], lightness: list[2])
    }

    public init() {
        self.init([0.0, 0.0, 0.0])
    }

}

extension StemColor.HSLSpace: StemColorSpaceRandom {

    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }

}
