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

// http://www.easyrgb.com/en/math.php
// https://zh.wikipedia.org/wiki/HSL%E5%92%8CHSV%E8%89%B2%E5%BD%A9%E7%A9%BA%E9%97%B4
public class StemColor {
    
    struct ThrowError: Error {
        let message: String
        init(_ message: String) {
            self.message = message
        }
    }

    // value: 0 - 1.0
    public private(set) var alpha: Double = 1

    public let rgbSpace: RGBSpace
    public lazy var rybSpace: RYBSpace    = { Self.calculator.convert(rgbSpace) }()
    public lazy var hslSpace: HSLSpace    = { Self.calculator.convert(rgbSpace) }()
    public lazy var hsbSpace: HSBSpace    = { Self.calculator.convert(rgbSpace) }()
    public lazy var hsvSpace: HSBSpace    = { self.hsbSpace }()
    public lazy var cmySpace: CMYSpace    = { Self.calculator.convert(rgbSpace) }()
    public lazy var cmykSpace: CMYKSpace  = { Self.calculator.convert(cmySpace) }()
    public lazy var xyzSpace: CIEXYZSpace = { Self.calculator.convert(rgbSpace, illuminants: .D65) }()
    public lazy var labSpace: CIELABSpace = { Self.calculator.convert(xyzSpace) }()
    
    static let calculator = StemColor.SpaceCalculator()

    public convenience init(cmyk space: CMYKSpace, alpha: Double = 1) {
        let cmy: CMYSpace   = Self.calculator.convert(space)
        let space: RGBSpace = Self.calculator.convert(cmy)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(lab space: CIELABSpace, alpha: Double = 1) {
        let xyz: CIEXYZSpace = Self.calculator.convert(space)
        let space: RGBSpace  = Self.calculator.convert(xyz)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(cmy space: CMYSpace, alpha: Double = 1) {
        let space: RGBSpace  = Self.calculator.convert(space)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(xyz space: CIEXYZSpace, alpha: Double = 1) {
        let space: RGBSpace  = Self.calculator.convert(space)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(hsl space: HSLSpace, alpha: Double = 1) {
        let space: RGBSpace  = Self.calculator.convert(space)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(ryb space: RYBSpace, alpha: Double = 1) {
        let space: RGBSpace  = Self.calculator.convert(space)
        self.init(rgb: space, alpha: alpha)
    }

    public convenience init(hsb space: HSBSpace, alpha: Double = 1) {
        let space: RGBSpace  = Self.calculator.convert(space)
        self.init(rgb: space, alpha: alpha)
    }

    public init(rgb space: RGBSpace, alpha: Double = 1) {
        self.rgbSpace = space
        self.alpha = max(min(alpha, 1), 0)
    }

    public init(alpha: Double = 1) {
        self.rgbSpace = .init(red: 1, green: 1, blue: 1)
        self.alpha = max(min(alpha, 1), 0)
    }

}

extension StemColor: Hashable, Equatable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rgbSpace.hashValue)
    }
    
    public static func == (lhs: StemColor, rhs: StemColor) -> Bool {
        lhs.rgbSpace == rhs.rgbSpace
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

public extension StemColor {
    
    @discardableResult
    func alpha(with value: Double) -> StemColor {
        self.alpha = value
        return self
    }

    static var random: StemColor { .init(rgb: .random, alpha: 1) }

}
