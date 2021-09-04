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

// MARK: - slice & pass for unit test & document
public extension Array {
    
    /// Returns an index that is the specified distance from the given index.
    ///
    /// The following example slices an array from different interval ranges
    /// and then prints the element at that position.
    ///
    ///     let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ///     numbers.slice(0...5)         // Prints [0, 1, 2, 3, 4, 5]
    ///     numbers.slice(1...5)         // Prints [1, 2, 3, 4, 5]
    ///     numbers.slice(-2...5)        // Prints [0, 1, 2, 3, 4, 5]
    ///     numbers.slice(-2...20)       // Prints [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ///     numbers.slice(5...20)        // Prints [5, 6, 7, 8, 9]
    ///     numbers.slice((-10)...(-1))  // Prints []
    ///     numbers.slice(20...50)       // Prints []
    ///
    /// - Parameters:
    ///   - range: A range for slice
    /// - Returns: An new Array
    func slice(_ range: CountableClosedRange<Int>) -> [Element] {
        if isEmpty { return self }
        var range: (start: Int, end: Int) = (range.lowerBound, range.upperBound)
        if range.start < 0 { range.start = 0 }
        if range.end >= count { range.end = count - 1 }
        if range.start > range.end { return [] }
        if range.start == range.end { return [] }
        let start = index(startIndex, offsetBy: range.start)
        let end = index(startIndex, offsetBy: range.end)
        return Array(self[start...end])
    }
    
    /// Returns an index that is the specified distance from the given index.
    ///
    /// The following example slices an array from different interval ranges
    /// and then prints the element at that position.
    ///
    ///     let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ///     numbers.slice(0..<5)    // Prints [0, 1, 2, 3, 4]
    ///     numbers.slice(1..<5)    // Prints [2, 3, 4, 5]
    ///     numbers.slice(-2..<5)   // Prints [0, 1, 2, 3, 4]
    ///     numbers.slice(-2..<20)  // Prints [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ///     numbers.slice(5..<20)   // Prints [5, 6, 7, 8, 9]
    ///     numbers.slice((-10)..<(-1))  // Prints []
    ///     numbers.slice(20..<50)       // Prints []
    ///
    /// - Parameters:
    ///   - range: A range for slice
    /// - Returns: An new Array
    func slice(_ range: CountableRange<Int>) -> [Element] {
        let ran: CountableClosedRange<Int> = range.lowerBound...(range.upperBound - 1)
        return self.slice(ran)
    }
    
    /// Returns an index that is the specified distance from the given index.
    ///
    /// The following example slices an array from different interval ranges
    /// and then prints the element at that position.
    ///
    ///     let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ///     numbers.slice(5...)    // Prints [5, 6, 7, 8, 9]
    ///     numbers.slice(0...)    // Prints [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ///     numbers.slice(20...)   // Prints []
    ///
    /// - Parameters:
    ///   - range: A range for slice
    /// - Returns: An new Array
    func slice(_ range: CountablePartialRangeFrom<Int>) -> [Element] {
        guard (self.count - 1) >= range.lowerBound else { return [] }
        let ran: CountableClosedRange<Int> = range.lowerBound...(self.count - 1)
        return self.slice(ran)
    }
    
    /// Returns an index that is the specified distance from the given index.
    ///
    /// The following example slices an array from different interval ranges
    /// and then prints the element at that position.
    ///
    ///     let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ///     numbers.slice(..<5)    // Prints [1, 2, 3, 4]
    ///     numbers.slice(..<20)   // Prints [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ///     numbers.slice(..<0)    // Prints []
    ///
    /// - Parameters:
    ///   - range: A range for slice
    /// - Returns: An new Array
    func slice(_ range: PartialRangeUpTo<Int>) -> [Element] {
        guard range.upperBound - 1 > 0 else { return [] }
        let ran: CountableClosedRange<Int> = 0...(range.upperBound - 1)
        return self.slice(ran)
    }
    
    /// Returns an index that is the specified distance from the given index.
    ///
    /// The following example slices an array from different interval ranges
    /// and then prints the element at that position.
    ///
    ///     let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ///     numbers.slice(...5)    // Prints [0, 1, 2, 3, 4, 5]
    ///     numbers.slice(...20)   // Prints [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ///     numbers.slice(...0)    // Prints []
    ///
    /// - Parameters:
    ///   - range: A range for slice
    /// - Returns: An new Array
    func slice(_ range: PartialRangeThrough<Int>) -> [Element] {
        let ran: CountableClosedRange<Int> = 0...range.upperBound
        return self.slice(ran)
    }
    
}

// MARK: - Value & pass for unit test & document
public extension Array {
    
    /// Accesses the element at the specified position.
    ///
    /// The following example uses indexed subscripting to get an array's element
    ///
    ///     let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ///     numbers.value(at: 0)     // Prints 0
    ///     numbers.value(at: 9)     // Prints 9
    ///     numbers.value(at: -1)    // Prints 9
    ///     numbers.value(at: -9)    // Prints 1
    ///     numbers.value(at: -20)   // Prints nil
    ///     numbers.value(at: 20)    // Prints nil
    ///
    /// - Parameter index: The location of the element to access.
    ///       When `index` is a positive integer, it is equivalent to [`index`].
    ///       When `index` is a negative integer, it is equivalent to [`count` + `index`].
    ///       Returns `nil` when `index` exceeds the threshold.
    ///
    /// - Complexity: Reading an element from an array is O(1).
    func value(at index: Int) -> Element? {
        let rawIndex = index < 0 ? count + index : index
        guard rawIndex < count, rawIndex >= 0 else { return nil }
        return self[rawIndex]
    }
    
}

public extension Array {
    
    /// Creates a new array containing the specified number of a single, repeated
    /// value.
    ///
    /// Here's an example of creating an array initialized with five strings
    /// containing the letter *Z*.
    ///
    ///     let fiveZs = Array(repeating: "Z", count: 5)
    ///     print(fiveZs)
    ///     // Prints "["Z", "Z", "Z", "Z", "Z"]"
    ///
    /// - Parameters:
    ///   - repeatedValue: The element to repeat.
    ///   - count: The number of times to repeat the value passed in the
    ///     `repeating` parameter. `count` must be zero or greater.
    @inlinable init(repeating block: (_ index: Int) -> Element, count: Int) {
        self = (0..<count).map({ block($0) })
    }
    
    /// Creates a new array containing the specified number of a single, repeated
    /// value.
    ///
    /// Here's an example of creating an array initialized with five strings
    /// containing the letter *Z*.
    ///
    ///     let fiveZs = Array(repeating: "Z", count: 5)
    ///     print(fiveZs)
    ///     // Prints "["Z", "Z", "Z", "Z", "Z"]"
    ///
    /// - Parameters:
    ///   - repeatedValue: The element to repeat.
    ///   - count: The number of times to repeat the value passed in the
    ///     `repeating` parameter. `count` must be zero or greater.
    @inlinable init(repeating block: () -> Element, count: Int) {
        self = (0..<count).map({ _ in block() })
    }
    
}

// MARK: - Array about other
public extension Array {
    
    func decompose() -> (head: Iterator.Element, tail: SubSequence)? {
        return (count > 0) ? (self[0], self[1..<count]): nil
    }
    
}

public extension Array {
    
    func dictionary<Key: Hashable, Value>(key: KeyPath<Element, Key>, value: KeyPath<Element, Value>) -> [Key: Value] {
        var result = [Key: Value]()
        for item in self {
            result[item[keyPath: key]] = item[keyPath: value]
        }
        return result
    }
    
    func dictionary<Key: Hashable>(key: KeyPath<Element, Key>) -> [Key: Element] {
        var result = [Key: Element]()
        for item in self {
            result[item[keyPath: key]] = item
        }
        return result
    }
    
}
