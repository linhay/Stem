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

public extension StemColor.RYBSpace {

    struct Unpack<T: Equatable> {
        
        public let red: T
        public let yellow: T
        public let blue: T
        
        public func map<V>(_ transform: (T) throws -> V) rethrows -> Unpack<V> {
            .init(red: try transform(red), yellow: try transform(yellow), blue: try transform(blue))
        }
    }
    
    func unpack<T: FixedWidthInteger>(as type: T.Type) -> Unpack<T> {
        let list = list(as: type)
        return .init(red: list[0], yellow: list[1], blue: list[2])
    }
    
    func unpack<T: BinaryFloatingPoint>(as type: T.Type) -> Unpack<T> {
        return .init(red: .init(red), yellow: .init(yellow), blue: .init(blue))
    }
    
    func list<T: FixedWidthInteger>(as type: T.Type) -> [T] {
        func map(_ v: Double) -> T { T(round(v * 255)) }
        return [map(red),map(yellow),map(blue)]
    }
    
    func list<T: BinaryFloatingPoint>(as type: T.Type) -> [T] {
        [T(red),T(yellow),T(blue)]
    }
    
    func simd<T: BinaryFloatingPoint>(as type: T.Type) -> SIMD3<T> {
        return .init(list(as: type))
    }
    
    init<T: BinaryFloatingPoint>(_ list: [T]) {
        self.init(red: Double(list[0]), yellow: Double(list[1]), blue: Double(list[2]))
    }
    
    init<T: BinaryFloatingPoint>(_ list: SIMD3<T>) {
        self.init(red: Double(list.x), yellow: Double(list.y), blue: Double(list.z))
    }
    
    init() {
        self.init([0.0, 0.0, 0.0])
    }

}

extension StemColor.RYBSpace: StemColorSpaceRandom {

    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }

}
