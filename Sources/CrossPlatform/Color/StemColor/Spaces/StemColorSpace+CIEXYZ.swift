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
            [0...illuminants.x,
             0...illuminants.y,
             0...illuminants.z]
        }

        public let illuminants: CIEStandardIlluminants
        public let x: Double
        public let y: Double
        public let z: Double

        public init(x: Double, y: Double, z: Double, illuminants: CIEStandardIlluminants = .D65) {
            self.illuminants = illuminants
            self.x = x
            self.y = y
            self.z = z
        }
    }

}

/// SIMD3
public extension StemColor.CIEXYZSpace {
    
    var simd: SIMD3<Double> { .init(x, y, z) }
    
    init(simd: SIMD3<Double>, illuminants: CIEStandardIlluminants = .D65) {
        self.init(x: simd.x, y: simd.y, z: simd.z, illuminants: illuminants)
    }
    
}

public extension StemColor.CIEXYZSpace {

    func x(with value: Double) -> Self { .init(x: value, y: y, z: z, illuminants: illuminants) }
    func y(with value: Double) -> Self { .init(x: x, y: value, z: z, illuminants: illuminants) }
    func z(with value: Double) -> Self { .init(x: x, y: y, z: value, illuminants: illuminants) }

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
