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

     struct CMYKSpace: StemColorSpace {
        public private(set) var ranges: [ClosedRange<Double>] = [0...1, 0...1, 0...1, 0...1]
        // value: 0 - 1.0
        public let cyan: Double
        // value: 0 - 1.0
        public let magenta: Double
        // value: 0 - 1.0
        public let yellow: Double
        // value: 0 - 1.0
        public let key: Double

        public init(cyan: Double, magenta: Double, yellow: Double, key: Double) {
            self.cyan = cyan
            self.magenta = magenta
            self.yellow = yellow
            self.key = key
        }

    }

}

/// SIMD3
public extension StemColor.CMYKSpace {
    
    var simd: SIMD4<Double> { .init(cyan, magenta, yellow, key) }
    
    init(_ simd: SIMD4<Double>) {
        self.init(cyan: simd.x, magenta: simd.y, yellow: simd.z, key: simd.w)
    }
    
}

public extension StemColor.CMYKSpace {

    func cyan(with value: Double)    -> Self { .init(cyan: value, magenta: magenta, yellow: yellow, key: key) }
    func magenta(with value: Double) -> Self { .init(cyan: cyan, magenta: value, yellow: yellow, key: key) }
    func yellow(with value: Double)  -> Self { .init(cyan: cyan, magenta: magenta, yellow: value, key: key) }
    func key(with value: Double)     -> Self { .init(cyan: cyan, magenta: magenta, yellow: yellow, key: value) }

}

extension StemColor.CMYKSpace: StemColorSpacePack {

    public var unpack: (cyan: Double, magenta: Double, yellow: Double, key: Double) { (cyan, magenta, yellow, key) }
    public var list: [Double] { [cyan, magenta, yellow, key] }

    public init(_ list: [Double]) {
        self.init(cyan: list[0], magenta: list[1], yellow: list[2], key: list[3])
    }

    public init() {
        self.init([0.0, 0.0, 0.0, 0.0])
    }

}

extension StemColor.CMYKSpace {

    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }

}
