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

    struct CIELABSpace: StemColorSpace {
        
        public let l: Double
        public let a: Double
        public let b: Double

        public init(l: Double, a: Double, b: Double) {
            self.l = l
            self.a = a
            self.b = b
        }

    }

}

public extension StemColor.CIELABSpace {

    func l(with value: Double) -> Self { .init(l: value, a: a, b: b) }
    func a(with value: Double) -> Self { .init(l: l, a: value, b: b) }
    func b(with value: Double) -> Self { .init(l: l, a: a, b: value) }

}

extension StemColor.CIELABSpace: StemColorSpacePack {

    public var ranges: [ClosedRange<Double>] {
       let list = CIEStandardIlluminants.D65.rawValue
        return [0...list[0],
                0...list[1],
                0...list[2]]
    }

    public var unpack: (l: Double, a: Double, b: Double) { (l, a, b) }
    public var list: [Double] { [l, a, b] }

    public init(_ list: [Double]) {
        self.init(l: list[0], a: list[1], b: list[2])
    }

    public init() {
        self.init([0.0, 0.0, 0.0])
    }

}

extension StemColor.CIELABSpace: StemColorSpaceRandom {

    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }

}
