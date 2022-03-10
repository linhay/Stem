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

public extension JSON {
    
    subscript(keys keys: String...) -> LazyMapSequence<[String], JSON> {
        return keys.lazy.map { (key) -> JSON in
            return self[key]
        }
    }
    
}

public extension LazyMapSequence where Base == [String], Element == JSON {
    
    private var firstValue: JSON? {
        first(where: { $0.exists() })
    }
    
    var string: String? {
        firstValue?.string
    }
    
    var stringValue: String {
        firstValue?.stringValue ?? ""
    }
    
    var int: Int? {
        firstValue?.int
    }
    
    var intValue: Int {
        firstValue?.intValue ?? 0
    }
    
    var double: Double? {
        firstValue?.double
    }
    
    var doubleValue: Double {
        firstValue?.double ?? 0
    }
    
    var bool: Bool? {
        firstValue?.bool
    }
    
    var boolValue: Bool {
        firstValue?.boolValue ?? false
    }
    
    var url: URL? {
        firstValue?.url
    }
    
}
