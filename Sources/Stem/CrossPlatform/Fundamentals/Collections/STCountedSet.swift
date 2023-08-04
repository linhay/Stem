//
//  File.swift
//  
//
//  Created by linhey on 2023/6/19.
//

import Foundation

public struct STCountedSet<T: Hashable>: SetAlgebra {

    
    public typealias Element = T

    fileprivate var backingDictionary = [Element: Int]()

    public var count: Int {
        return backingDictionary.count
    }

    public var isEmpty: Bool {
        return count == 0
    }

    public init() {}
    public init(_ dict: [Element: Int]) {
        backingDictionary = dict
    }

    public init(_ object: Element) {
        insert(object)
    }

    public init(_ set: STCountedSet<Element>) {
        backingDictionary = set.backingDictionary
    }
    
    public init(_ list: [(Element, Int)]) {
        for item in list {
            insert(item.0, count: item.1)
        }
    }

    public init(arrayLiteral elements: STCountedSet.Element...) {
        insert(elements)
    }

    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        insert(sequence as! [T])
    }

    public func count(for object: Element) -> Int {
        return backingDictionary[object] ?? 0
    }

    public func contains(_ member: STCountedSet.Element) -> Bool {
        return backingDictionary[member] != nil
    }

    fileprivate mutating func insert(_ members: [T]) {
        for member in members {
            let (inserted, existing) = insert(member)

            if !inserted {
                update(with: existing)
            }
        }
    }

    @discardableResult
    public mutating func insert(_ newMember: __owned T) -> (inserted: Bool, memberAfterInsert: T) {
        insert(newMember, count: 1)
    }
    
    @discardableResult
    public mutating func insert(_ newMember: T, count: Int) -> (inserted: Bool, memberAfterInsert: T) {
        if backingDictionary.keys.contains(newMember) {
            return (false, newMember)
        } else {
            backingDictionary[newMember] = count
            return (true, newMember)
        }
    }

    @discardableResult
    public mutating func update(with newMember: T) -> T? {
        return update(with: newMember, count: 1)
    }

    @discardableResult
    public mutating func update(with newMember: T, count: Int) -> T? {
        if let existing = backingDictionary[newMember] {
            backingDictionary[newMember] = (existing + count)
            return newMember
        } else {
            backingDictionary[newMember] = count
            return nil
        }
    }

    @discardableResult
    public mutating func remove(_ member: STCountedSet.Element) -> STCountedSet.Element? {
        return remove(member, count: 1)
    }

    @discardableResult
    public mutating func remove(_ member: STCountedSet.Element, count: Int = 1) -> STCountedSet.Element? {
        guard let value = backingDictionary[member] else {
            return nil
        }

        if value > count {
            backingDictionary[member] = (value - count)
        } else {
            backingDictionary.removeValue(forKey: member)
        }

        return member
    }

    public mutating func formUnion(_ other: [Element]) {
        formUnion(.init(other))
    }
    
    public mutating func formUnion(_ other: STCountedSet<Element>) {
        for (key, value) in other.backingDictionary {
            if let existingValue = backingDictionary[key] {
                backingDictionary[key] = existingValue + value
            } else {
                backingDictionary[key] = value
            }
        }
    }

    public func union(_ other: STCountedSet<Element>) -> STCountedSet<Element> {
        var unionized = self
        unionized.formUnion(other)

        return unionized
    }

    public mutating func formIntersection(_ other: STCountedSet<Element>) {
        for (key, value) in backingDictionary {
            if let existingValue = other.backingDictionary[key] {
                backingDictionary[key] = existingValue + value
            } else {
                backingDictionary.removeValue(forKey: key)
            }
        }
    }

    public func intersectsSet(_ other: STCountedSet<Element>) -> Bool {
        for (key, _) in other.backingDictionary {
            if let _ = backingDictionary[key] {
                return true
            }
        }

        return false
    }

    public func intersection(_ other: STCountedSet<Element>) -> STCountedSet<Element> {
        var intersected = self
        intersected.formIntersection(other)

        return intersected
    }

    public mutating func formSymmetricDifference(_ other: STCountedSet<Element>) {
        for (key, value) in other.backingDictionary {
            if let _ = backingDictionary[key] {
                backingDictionary.removeValue(forKey: key)
            } else {
                backingDictionary[key] = value
            }
        }
    }

    public func symmetricDifference(_ other: STCountedSet<Element>) -> STCountedSet<Element> {
        var xored = self
        xored.formSymmetricDifference(other)

        return xored
    }

    public mutating func subtract(_ other: STCountedSet<Element>) {
        for (key, value) in other.backingDictionary {
            guard let existingValue = backingDictionary[key] else {
                continue
            }

            if value >= existingValue {
                backingDictionary.removeValue(forKey: key)
            } else {
                backingDictionary[key] = existingValue - value
            }
        }
    }

    public func subtracting(_ other: STCountedSet<Element>) -> STCountedSet<Element> {
        var subtracted = self
        subtracted.subtract(other)

        return subtracted
    }

    public func isSubset(of other: STCountedSet<Element>) -> Bool {
        for (key, _) in backingDictionary {
            if !other.backingDictionary.keys.contains(key) {
                return false
            }
        }

        return true
    }

    public func isDisjoint(with other: STCountedSet<Element>) -> Bool {
        return intersection(other).isEmpty
    }

    public func isSuperset(of other: STCountedSet<Element>) -> Bool {
        for (key, _) in other.backingDictionary {
            if !backingDictionary.keys.contains(key) {
                return false
            }
        }

        return true
    }

    public func isStrictSupersetOf(_ other: STCountedSet<Element>) -> Bool {
        return isSuperset(of: other) && count > other.count
    }

    public func isStrictSubsetOf(_ other: STCountedSet<Element>) -> Bool {
        return isSubset(of: other) && count < other.count
    }

    public static func element(_ a: STCountedSet.Element, subsumes b: STCountedSet.Element) -> Bool {
        return STCountedSet([a]).isSuperset(of: STCountedSet([b]))
    }

    public static func element(_ a: STCountedSet.Element, isDisjointWith b: STCountedSet.Element) -> Bool {
        return !STCountedSet.element(a, subsumes: b) && !STCountedSet.element(b, subsumes: a)
    }
}

extension STCountedSet: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return backingDictionary.description
    }

    public var debugDescription: String {
        return backingDictionary.debugDescription
    }
}

extension STCountedSet : Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(backingDictionary)
    }
}

public func == <T: Hashable>(lhs: STCountedSet<T>, rhs: STCountedSet<T>) -> Bool {
    return lhs.backingDictionary == rhs.backingDictionary
}

extension STCountedSet: Sequence {
    public func makeIterator() -> AnyIterator<Element> {
        var keysIterator = backingDictionary.keys.makeIterator()
        return AnyIterator { keysIterator.next() }
    }
}

extension STCountedSet {
    
    public func map<U>(_ transform: (Element) throws -> U) rethrows -> STCountedSet<U> {
        try .init(backingDictionary.mapKeys(transform))
    }
    
    public func compactMap<U: Hashable>(_ transform: ((Element, Int)) throws -> U?) rethrows -> STCountedSet<U> {
        try .init(backingDictionary.compactMap(transform))
    }
    
    public func filterToSTCountedSet(_ inclusionCount: (Element, Int) throws -> Int) rethrows -> STCountedSet<Element> {
        var result = STCountedSet<Element>()
        
        for (element, count) in backingDictionary {
            let newCount = try inclusionCount(element, count)
            
            if newCount > 0 {
                result.update(with: element, count: newCount)
            }
        }
        
        return result
    }
    
    public func sorted(by areInIncreasingOrder: ((key: Element, value: Int), (key: Element, value: Int)) throws -> Bool) rethrows -> [(key: Element, value: Int)] {
       try backingDictionary.sorted(by: areInIncreasingOrder)
    }
    
}
