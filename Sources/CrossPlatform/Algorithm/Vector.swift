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

public struct Vector: CustomStringConvertible, Equatable {
    
    public private(set) var length = 0
    public private(set) var data: [Double]
    public private(set) var distance: ((Vector, Vector) -> Double)?
    
    public init(_ data: [Double], distance: ((Vector, Vector) -> Double)? = nil) {
        self.data = data
        self.length = data.count
        self.distance = distance
    }
    
    public var description: String {
        return "Vector (\(data)"
    }
    
    func distanceTo(_ other: Vector) -> Double {
        if let distance = distance {
            return distance(self, other)
        }
        var result = 0.0
        for idx in 0..<length {
            result += pow(data[idx] - other.data[idx], 2.0)
        }
        return sqrt(result)
    }
    
    
    public static func == (left: Self, right: Self) -> Bool {
        for idx in 0..<left.length {
            if left.data[idx] != right.data[idx] {
                return false
            }
        }
        return true
    }

    public static func + (left: Self, right: Self) -> Vector {
        var results = [Double]()
        for idx in 0..<left.length {
            results.append(left.data[idx] + right.data[idx])
        }
        return Vector(results)
    }

    public static func += (left: inout Self, right: Self) {
        left = left + right
    }

    public static func - (left: Self, right: Self) -> Vector {
        var results = [Double]()
        for idx in 0..<left.length {
            results.append(left.data[idx] - right.data[idx])
        }
        return Vector(results)
    }

    public static func -= (left: inout Self, right: Self) {
        left = left - right
    }

    public static func / (left: Self, right: Double) -> Self {
        var results = [Double](repeating: 0, count: left.length)
        for (idx, value) in left.data.enumerated() {
            results[idx] = value / right
        }
        return Vector(results)
    }

    public static func /= (left: inout Self, right: Double) {
        left = left / right
    }

}
