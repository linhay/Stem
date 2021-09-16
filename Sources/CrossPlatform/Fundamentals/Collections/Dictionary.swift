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

// MARK: - Dictionary 重载操作符
extension Dictionary {
    
    @inlinable public func mapKeys<T: Hashable>(_ transform: (Key) throws -> T) rethrows -> [T: Value] {
        var dict = [T: Value]()
        
        for (key, value) in self {
            let newKeys = try transform(key)
            dict.updateValue(value, forKey: newKeys)
        }
        
        return dict
    }
    
    @inlinable public func compactMapKeys<T: Hashable>(_ transform: (Key) throws -> T?) rethrows -> [T: Value] {
        var dict = [T: Value]()
        for (key, value) in self {
            if let newKeys = try transform(key) {
                dict.updateValue(value, forKey: newKeys)
            }
        }
        return dict
    }
    
}

// MARK: - 函数
public extension Dictionary {
    
    /// 格式化为Json
    ///
    /// - Returns: Json字符串
    func formatJSON(prettify: Bool = false) -> String {
        guard JSONSerialization.isValidJSONObject(self) else { return "{}" }
        let options = prettify ? JSONSerialization.WritingOptions.prettyPrinted: JSONSerialization.WritingOptions()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            return "{}"
        }
    }
    
}
