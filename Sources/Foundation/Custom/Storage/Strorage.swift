//
//  Pods
//
//  Copyright (c) 2019/6/13 linhey - https://github.com/linhay
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

public class Strorage {

    var memory: MemoryStrorage = MemoryStrorage()
    var disk: DiskFileStorage?

}

// MARK: - subscript
public extension Strorage {

    subscript<T: Codable>(_ key: String) -> T? {
        set { _ = set(value: newValue, for: key) }
        get { return get(key: key) }
    }

}

// MARK: - set / get with Codable
public extension Strorage {

    func set<T: Codable>(value: T?, for key: String) -> Bool {
        _ = memory.set(value: value, for: key)
        _ = disk?.set(value: value, for: key)
        return true
    }

    func get<T: Codable>(key: String) -> T? {
        if let value = memory.get(key: key) as T? { return value }
        if let value = disk?.get(key: key) as T? { return value }
        return nil
    }

}

extension Strorage {

    func remove(key: String) {
        _ = disk?.remove(key: key)
        memory.remove(key: key)
    }

    func removeAll() {
        memory.removeAll()
        _ = disk?.removeAll()
    }

}
