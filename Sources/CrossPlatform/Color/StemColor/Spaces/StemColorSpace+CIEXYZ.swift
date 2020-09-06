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

    struct CIEXYZSpace: StemColorSpace {

        public var ranges: [ClosedRange<Double>] {
            [0...illuminants.rawValue[0],
             0...illuminants.rawValue[1],
             0...illuminants.rawValue[2]]
        }

        public let illuminants: CIEStandardIlluminants
        public let x: Double
        public let y: Double
        public let z: Double

        public init(x: Double, y: Double, z: Double, illuminants: CIEStandardIlluminants) {
            self.illuminants = illuminants
            self.x = x
            self.y = y
            self.z = z
        }
    }

}

public extension StemColor.CIEXYZSpace {

    func x(with value: Double) -> Self { .init(x: value, y: y, z: z, illuminants: illuminants) }
    func y(with value: Double) -> Self { .init(x: x, y: value, z: z, illuminants: illuminants) }
    func z(with value: Double) -> Self { .init(x: x, y: y, z: value, illuminants: illuminants) }

}

extension StemColor.CIEXYZSpace: StemColorCIELABSpaceConversion {

    public func convertToLAB(illuminants: CIEStandardIlluminants) -> (l: Double, a: Double, b: Double) {
        func map(_ value: Double) -> Double {
            if (value > pow(6.0 / 29.0, 3.0)) {
                return pow(value, 1.0 / 3.0)
            } else {
                return ((1.0 / 3.0) * pow(29.0 / 6.0, 2.0) * value) + (4.0 / 29.0)
            }
        }

        let fx = map(x / (illuminants.rawValue[0] * 100))
        let fy = map(y / (illuminants.rawValue[1] * 100))
        let fz = map(z / (illuminants.rawValue[2] * 100))

        let l = (116.0 * fy) - 16.0
        let a = 500 * (fx - fy)
        let b = 200 * (fy - fz)

        return (l, a, b)
    }

    public init(l: Double, a: Double, b: Double, illuminants: CIEStandardIlluminants) {
        func map(_ value: Double) -> Double {
            if (value > (6.0 / 29.0)) {
                return pow(value, 3.0)
            } else {
                return 3.0 * pow(6.0 / 29.0, 2.0) * (value - (4.0 / 29.0))
            }
        }

        let y = (1.0 / 116.0) * (l + 16.0)

        self.init(x: illuminants.rawValue[0] * 100 * map(y + a / 500.0),
                  y: illuminants.rawValue[1] * 100 * map(y),
                  z: illuminants.rawValue[2] * 100 * map(y - b / 200.0),
                  illuminants: illuminants)
    }

}

extension StemColor.CIEXYZSpace: StemColorRGBSpaceConversion {

    public var convertToRGB: (red: Double, green: Double, blue: Double) {
        let (x, y, z) = unpack

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

        return (red, green, blue)
    }

    public init(red: Double, green: Double, blue: Double) {
        func map(_ value: Double) -> Double {
            if value > 0.04045 {
                return pow((value + 0.055) / 1.055, 2.4)
            } else {
                return value / 12.92
            }
        }

        let r = map(red)
        let g = map(green)
        let b = map(blue)

        let x = (r * 41.24564 + g * 35.75761 + b * 18.04375) / 100
        let y = (r * 21.26729 + g * 71.51522 + b * 07.21750) / 100
        let z = (r * 01.93339 + g * 11.91920 + b * 95.03041) / 100
        
        self.init(x: x, y: y, z: z, illuminants: .D65)
    }

}

extension StemColor.CIEXYZSpace: StemColorSpacePack {

    public var unpack: (x: Double, y: Double, z: Double) { (x, y, z) }
    public var list: [Double] { [x, y, z] }

    public init(_ list: [Double]) {
        self.init(x: list[0], y: list[1], z: list[2], illuminants: .D65)
    }

    public init() {
        self.init([0.0, 0.0, 0.0])
    }
}

extension StemColor.CIEXYZSpace: StemColorSpaceRandom {

    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }

}
