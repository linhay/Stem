//
//  Stone
//
//  Copyright (c) 2019 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

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

// MARK: - shuffled & pass for unit test & document
public extension Array {

    /// Returns the elements of the sequence, shuffled.
    ///
    /// For example, you can shuffle the numbers between `0` and `9` by calling
    /// the `shuffled()` method on that range:
    ///
    ///     let numbers = 0...9
    ///     let shuffledNumbers = numbers.shuffled
    ///     // shuffledNumbers == [1, 7, 6, 2, 8, 9, 4, 3, 5, 0]
    ///
    /// This method is equivalent to calling `shuffled(using:)`, passing in the
    /// system's default random generator.
    ///
    /// - Returns: A shuffled array of this sequence's elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    var shuffled: [Element] {
        return self.shuffled()
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

// MARK: - Array about remove
#warning("unit test")
#warning("document")
public extension Array where Element: Equatable {

    mutating func removeFirst(with value: Element) {
        if let index = firstIndex(of: value) { remove(at: index) }
    }

    mutating func removeLast(with value: Element) {
        if let index = lastIndex(of: value) { remove(at: index) }
    }

    mutating func removeAll(with value: Element) {
        self.removeAll(where: { $0 == value })
    }

}

// MARK: - Array about other
#warning("unit test")
#warning("document")
public extension Array {

    func decompose() -> (head: Iterator.Element, tail: SubSequence)? {
        return (count > 0) ? (self[0], self[1..<count]): nil
    }

    func formatJSON(prettify: Bool = false) -> String {
        guard JSONSerialization.isValidJSONObject(self) else {
            return "[]"
        }
        let options = prettify ? JSONSerialization.WritingOptions.prettyPrinted: JSONSerialization.WritingOptions()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            return String(data: jsonData, encoding: .utf8) ?? "[]"
        } catch {
            return "[]"
        }
    }

}
