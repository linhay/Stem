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
