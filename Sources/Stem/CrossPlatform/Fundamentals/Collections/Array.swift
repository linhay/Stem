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
import Accessibility

// MARK: - slice & pass for unit test & document
public extension Array {
    
    /// Make several slices out of a given array.
    /// - Returns:
    ///   An array of slices of `maxStride` elements each.
    @inlinable
    func slice(maxStride: Int) -> [ArraySlice<Element>] {
        let elementsCount = self.count
        let groupsCount = (elementsCount + maxStride - 1) / maxStride
        return (0..<groupsCount).map({ n in
            self[n*maxStride..<Swift.min(elementsCount, (n+1)*maxStride)]
        })
    }
    
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
    @inlinable
    func slice(_ range: CountableClosedRange<Int>) -> ArraySlice<Element> {
        if isEmpty { return ArraySlice(self) }
        var range: (start: Int, end: Int) = (range.lowerBound, range.upperBound)
        if range.start < 0 { range.start = 0 }
        if range.end >= count { range.end = count - 1 }
        if range.start > range.end { return [] }
        if range.start == range.end { return [] }
        let start = index(startIndex, offsetBy: range.start)
        let end = index(startIndex, offsetBy: range.end)
        return self[start...end]
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
    @inlinable
    func slice(_ range: CountableRange<Int>) -> ArraySlice<Element> {
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
    @inlinable
    func slice(_ range: CountablePartialRangeFrom<Int>) -> ArraySlice<Element> {
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
    @inlinable
    func slice(_ range: PartialRangeUpTo<Int>) -> ArraySlice<Element> {
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
    @inlinable
    func slice(_ range: PartialRangeThrough<Int>) -> ArraySlice<Element> {
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
    @inlinable
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
    @inlinable
    init(repeating block: (_ index: Int) -> Element, count: Int) {
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
    @inlinable
    init(repeating block: () -> Element, count: Int) {
        self = (0..<count).map({ _ in block() })
    }
    
}

extension Array where Element: Hashable {
    
    var unique: [Element] {
        var uniq = Set<Element>()
        uniq.reserveCapacity(count)
        return filter { uniq.insert($0).inserted }
    }
    
}

public extension Array {
    
    struct STKeyPathComparator {
        
        let compare: (Element, Element) throws -> Bool?
        
        /// Comparator for custom comparison closure
        public init(_ compare: @escaping (Element, Element) -> Bool) {
            self.compare = compare
        }
        
        /// Comparator for key path with ascending order
        public init<Key: Comparable>(_ keyPath: KeyPath<Element, Key>, ascending: Bool) {
            self.compare = { lhs, rhs in
                let lhsValue = lhs[keyPath: keyPath]
                let rhsValue = rhs[keyPath: keyPath]
                if lhsValue == rhsValue {
                    return nil
                } else if ascending {
                    return lhsValue < rhsValue
                } else {
                    return lhsValue > rhsValue
                }
            }
        }
        
        /// Comparator for key path with ascending order
        public init<Key: Comparable>(_ keyPath: KeyPath<Element, Key?>, default: Key, ascending: Bool) {
            self.compare = { lhs, rhs in
                let lhsValue = lhs[keyPath: keyPath] ?? `default`
                let rhsValue = rhs[keyPath: keyPath] ?? `default`
                if lhsValue == rhsValue {
                    return nil
                } else if ascending {
                    return lhsValue < rhsValue
                } else {
                    return lhsValue > rhsValue
                }
            }
        }
    }
    
    @inlinable
    func sorted<Key: Comparable>(by key: KeyPath<Element, Key>, _ areInIncreasingOrder: (Key, Key) throws -> Bool) rethrows -> Self {
        try self.sorted { (lhs, rhs) in
            try areInIncreasingOrder(lhs[keyPath: key], rhs[keyPath: key])
        }
    }
    
    func sorted(by comparators: STKeyPathComparator) throws -> [Element] {
        try sorted(by: [comparators])
    }
    
    /// Sorts the array using multiple comparators
    func sorted(by comparators: [STKeyPathComparator]) throws -> [Element] {
        return try self.sorted { lhs, rhs in
            for comparator in comparators {
                if let result = try comparator.compare(lhs, rhs) {
                    return result
                }
            }
            return false
        }
    }
    
    @inlinable
    func decompose<Key: Hashable, Value>(key: KeyPath<Element, Key>, value: KeyPath<Element, Value>) -> [Key: [Value]] {
        return decompose(key: { $0[keyPath: key] }, value: { $0[keyPath: value] })
    }
    
    @inlinable
    func decompose<Key: Hashable, Value>(key: KeyPath<Element, Key>, value: (Element) throws -> Value?) rethrows -> [Key: [Value]] {
        return try decompose(key: { $0[keyPath: key] }, value: value)
    }
    
    @inlinable
    func decompose<Key: Hashable, Value>(key: (Element) throws -> Key?, value: KeyPath<Element, Value>) rethrows -> [Key: [Value]] {
        return try decompose(key: key, value: { $0[keyPath: value] })
    }
    
    @inlinable
    func decompose<Key: Hashable>(key: KeyPath<Element, Key>) -> [Key: [Element]] {
        return decompose(key: key, value: \.self)
    }
    
    @inlinable
    func decompose<Key: Hashable, Value>(key: (Element) throws -> Key?, value: (Element) throws -> Value?) rethrows -> [Key: [Value]] {
        var result = [Key: [Value]]()
        for item in self {
            if let key = try key(item), let value = try value(item) {
                if result[key] == nil {
                    result[key] = [value]
                } else {
                    result[key]?.append(value)
                }
            }
        }
        return result
    }

    
    @inlinable
    func dictionary<Key: Hashable, Value>(key: KeyPath<Element, Key>, value: KeyPath<Element, Value>) -> [Key: Value] {
        return dictionary(key: { $0[keyPath: key] }, value: { $0[keyPath: value] })
    }
    
    @inlinable
    func dictionary<Key: Hashable, Value>(key: KeyPath<Element, Key>, value: (Element) throws -> Value?) rethrows -> [Key: Value] {
        return try dictionary(key: { $0[keyPath: key] }, value: value)
    }
    
    @inlinable
    func dictionary<Key: Hashable, Value>(key: (Element) throws -> Key?, value: KeyPath<Element, Value>) rethrows -> [Key: Value] {
        return try dictionary(key: key, value: { $0[keyPath: value] })
    }
    
    @inlinable
    func dictionary<Key: Hashable>(key: KeyPath<Element, Key>) -> [Key: Element] {
        return dictionary(key: key, value: \.self)
    }
    
    @inlinable
    func dictionary<Key: Hashable, Value>(key: (Element) throws -> Key?, value: (Element) throws -> Value?) rethrows -> [Key: Value] {
        var result = [Key: Value]()
        for item in self {
            if let key = try key(item) {
                result[key] = try value(item)
            }
        }
        return result
    }
    
    /// 在数组的每个元素之间插入一个指定的对象数组。
    /// - Parameter separator: 要插入的对象数组。
    /// - Returns: 插入对象后的新数组。
    func inserted(separator: () -> [Element]) -> [Element] {
        guard !self.isEmpty else { return [] }
        var result: [Element] = []
        for (index, element) in self.enumerated() {
            result.append(element)
            if index < self.count - 1 {
                result.append(contentsOf: separator())
            }
        }
        return result
    }
    
    func inserted(separator: [Element]) -> [Element] {
        inserted(separator: { separator })
    }
    
    func inserted(separator: Element?) -> [Element] {
        inserted(separator: { separator })
    }
    
    func inserted(separator: () -> Element?) -> [Element] {
        guard !self.isEmpty else { return [] }
        var result: [Element] = []
        for (index, element) in self.enumerated() {
            result.append(element)
            if index < self.count - 1 {
                if let item = separator() {
                    result.append(item)
                }
            }
        }
        return result
    }
    
}
