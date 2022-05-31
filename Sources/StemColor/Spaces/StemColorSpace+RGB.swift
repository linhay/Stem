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
        public let unpack: Unpack<Double>
        
        // value: 0 - 1.0
        public var red: Double { unpack.red }
        // value: 0 - 1.0
        public var green: Double { unpack.green }
        // value: 0 - 1.0
        public var blue: Double { unpack.blue }
        
        public init(red: Double, green: Double, blue: Double) {
            func map(_ value: Double) -> Double {
                var value = value
                if value > 0.9999 { value = 1 }
                else if value < 0 { value = 0 }
                return value
            }
            self.unpack = .init(red: map(red), green: map(green), blue: map(blue))
        }
        
        public init(int red: UInt8, green: UInt8, blue: UInt8) {
            func map(_ value: UInt8) -> Double {
                return Double(value) / 255
            }
            self.unpack = .init(red: map(red), green: map(green), blue: map(blue))
        }
        
    }
    
}

public extension StemColor.RGBSpace {

    var linear: StemColor.RGBSpace {
        func f(_ value: Double) -> Double {
            if (value <= 0.04045) {
                return value / 12.92
            } else {
                return pow((value + 0.055) / 1.055, 2.4)
            }
        }
        return StemColor.RGBSpace(list(as: Double.self).map(f))
    }
    
    init(linear: StemColor.RGBSpace) {
        func f(_ linear: Double) -> Double {
            if (linear <= 0.0031308) {
                return linear * 12.92
            } else {
                return 1.055 * pow(linear, 1.0 / 2.4) - 0.055
            }
        }
        
        let list = linear.list(as: Double.self)
        self.init(list.map(f))
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

public extension StemColor.RGBSpace {
    
    enum Channel {
        case red
        case green
        case blue
    }

    struct Unpack<T: Codable & Hashable>: Codable, Hashable {
        
        public var red: T
        public var green: T
        public var blue: T
        
        public init(red: T, green: T, blue: T) {
            self.red = red
            self.green = green
            self.blue = blue
        }
                        
        public func map<V>(_ transform: (T) throws -> V) rethrows -> Unpack<V> {
            .init(red: try transform(red), green: try transform(green), blue: try transform(blue))
        }

        public func with<O, V>(_ other: Unpack<O>, _ transform: (T, O) throws -> V) rethrows -> Unpack<V> {
            .init(red: try transform(red, other.red), green: try transform(green, other.green), blue: try transform(blue, other.blue))
        }
        
        public var list: [T] {
            [red, green, blue]
        }
        
        public func contains(where predicate: (T) throws -> Bool) rethrows -> Bool {
            return try predicate(red) || predicate(green) || predicate(blue)
        }
                
        public func simd() -> SIMD3<T> where T: FixedWidthInteger {
            return SIMD3(list)
        }
        
        public func simd() -> SIMD3<T> where T: BinaryFloatingPoint {
            return SIMD3(list)
        }

        public func min() -> T where T: Comparable {
            Swift.min(red, green, blue)
        }
        
        public func max() -> T where T: Comparable {
            Swift.max(red, green, blue)
        }
        
        public func sum() -> T where T: BinaryFloatingPoint {
            return red + green + blue
        }
        
        public func sum() -> T where T: FixedWidthInteger {
            return red + green + blue
        }
        
        public func multiplier() -> T where T: BinaryFloatingPoint {
            return red * green * blue
        }
        
        public func multiplier() -> T where T: FixedWidthInteger {
            return red * green * blue
        }
        
    }
    
    func unpack<T: FixedWidthInteger>(as type: T.Type) -> Unpack<T> {
        let list = list(as: type)
        return .init(red: list[0], green: list[1], blue: list[2])
    }
    
    func unpack<T: BinaryFloatingPoint>(as type: T.Type) -> Unpack<T> {
        return .init(red: .init(red), green: .init(green), blue: .init(blue))
    }
    
    func list<T: FixedWidthInteger>(as type: T.Type) -> [T] {
        func map(_ v: Double) -> T { T(round(v * 255)) }
        return [map(red),map(green),map(blue)]
    }
    
    func list<T: BinaryFloatingPoint>(as type: T.Type) -> [T] {
        [T(red),T(green),T(blue)]
    }
    
    func simd<T: FixedWidthInteger>(as type: T.Type) -> SIMD3<T> {
        return .init(list(as: type))
    }
    
    func simd<T: BinaryFloatingPoint>(as type: T.Type) -> SIMD3<T> {
        return .init(list(as: type))
    }
    
    init<T: BinaryFloatingPoint & Codable>(_ list: [T]) {
        self.init(Unpack(red: list[0], green: list[1], blue: list[2]))
    }

    init<T: FixedWidthInteger>(_ list: SIMD3<T>) {
        self.init(Unpack(red: list.x, green: list.y, blue: list.z))
    }
    
    init<T: BinaryFloatingPoint>(_ list: SIMD3<T>) {
        self.init(Unpack(red: list.x, green: list.y, blue: list.z))
    }
    
    init<T: FixedWidthInteger>(_ list: Unpack<T>) {
        let list = list.map({ Double($0) / 255 })
        self.init(red: list.red, green: list.green, blue: list.blue)
    }
    
    init<T: BinaryFloatingPoint>(_ list: Unpack<T>) {
        self.init(red: Double(list.red), green: Double(list.green), blue: Double(list.blue))
    }
    
    init() {
        self.init(red: 0.0, green: 0.0, blue: 0.0)
    }
    
}

extension StemColor.RGBSpace: StemColorSpaceRandom {
    
    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }
    
}
