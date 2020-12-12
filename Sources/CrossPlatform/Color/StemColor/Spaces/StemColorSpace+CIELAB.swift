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

public extension StemColor.CIELABSpace {
    
    /// 数值压缩至 0-1 区间之间
    func compressionValues() -> [Double] {
        return zip(list, ranges).map { (value, range) -> Double in
            return value / (range.upperBound - range.lowerBound)
        }
    }
    
    /// 数值从 0-1 区间复位
    static func resetValues(_ list: [Double]) -> [Double] {
        return zip(list, ranges).map { (value, range) -> Double in
            let result = value * (range.upperBound - range.lowerBound)
            if result > range.upperBound {
                return result - range.upperBound
            } else {
                return result
            }
        }
    }
    
}

extension StemColor.CIELABSpace: StemColorSpacePack {

    public static var ranges: [ClosedRange<Double>] {
        return [0...100, -128...128, -128...128]
    }
    
    public var ranges: [ClosedRange<Double>] {
        return Self.ranges
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
