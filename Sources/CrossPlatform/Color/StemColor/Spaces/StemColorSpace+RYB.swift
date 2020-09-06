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

    struct RYBSpace: StemColorSpace {
        public private(set) var ranges: [ClosedRange<Double>] = [0...1, 0...1, 0...1]

        public let red: Double
        public let yellow: Double
        public let blue: Double

        public init(red: Double, yellow: Double, blue: Double) {
            self.red = red
            self.yellow = yellow
            self.blue = blue
        }
    }

}

extension StemColor.RYBSpace: StemColorRGBSpaceConversion {

    public var convertToRGB: (red: Double, green: Double, blue: Double) {
        var (r, y, b) = (red, yellow, blue)

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

        return (r, g, b)
    }

    public init(red: Double, green: Double, blue: Double) {
        var (r, g, b) = (red, green, blue)
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

        self.init(red: r, yellow: y, blue: b)
    }

}

extension StemColor.RYBSpace: StemColorSpacePack {

    public var unpack: (red: Double, yellow: Double, blue: Double) { (red, yellow, blue) }
    public var list: [Double] { [red, yellow, blue] }

    public init(_ list: [Double]) {
        self.init(red: list[0], yellow: list[1], blue: list[2])
    }

    public init() {
        self.init([0.0, 0.0, 0.0])
    }

}

extension StemColor.RYBSpace: StemColorSpaceRandom {

    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }

}
