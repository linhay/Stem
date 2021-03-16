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
    
    struct RGBSpace: StemColorSpace {
        public private(set) var ranges: [ClosedRange<Double>] = [0...1, 0...1, 0...1]
        // value: 0 - 1.0
        public let red: Double
        // value: 0 - 1.0
        public let green: Double
        // value: 0 - 1.0
        public let blue: Double
        
        public init(red: Double, green: Double, blue: Double) {
            func map(_ value: Double) -> Double {
                var value = value
                if value > 0.9999 { value = 1 }
                else if value < 0 { value = 0 }
                return value
            }
            
            self.red   = map(red)
            self.green = map(green)
            self.blue  = map(blue)
        }
    }
    
}

public extension StemColor.RGBSpace {
    
    // See <https://www.w3.org/TR/WCAG20/#relativeluminancedef>
    func linearize(_ value: Double) -> Double {
        if (value <= 0.03928) {
            return value / 12.92
        }
        return pow((value + 0.055) / 1.055, 2.4)
    }
    
    /// Returns a brightness value between 0 for darkest and 1 for lightest.
    ///
    /// Represents the relative luminance of the color. This value is computationally
    /// expensive to calculate.
    ///
    /// See <https://en.wikipedia.org/wiki/Relative_luminance>.
    var luminance: Double {
        // See <https://www.w3.org/TR/WCAG20/#relativeluminancedef>
        let R = linearize(red)
        let G = linearize(green)
        let B = linearize(blue)
        return 0.2126 * R + 0.7152 * G + 0.0722 * B;
    }
    
}

public extension StemColor.RGBSpace {
    
    func red(with value: Double)   -> Self { .init(red: value, green: green, blue: blue)  }
    func green(with value: Double) -> Self { .init(red: red,   green: value, blue: blue)  }
    func blue(with value: Double)  -> Self { .init(red: red,   green: green, blue: value) }
    
}

extension StemColor.RGBSpace: StemColorSpacePack {
    
    public var unpack: (red: Double, green: Double, blue: Double) { (red, green, blue) }
    public var list: [Double] { [red, green, blue] }
    public var intUnpack: (red: Int, green: Int, blue: Int) {
        func map(_ v: Double) -> Int { Int(round(v * 255)) }
        return (map(red), map(green), map(blue))
    }
    
    public init(_ list: [Double]) {
        self.init(red: list[0], green: list[1], blue: list[2])
    }
    
    public init() {
        self.init([0.0, 0.0, 0.0])
    }
    
}

extension StemColor.RGBSpace: StemColorSpaceRandom {
    
    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }
    
}
