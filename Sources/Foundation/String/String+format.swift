/// MIT License
///
/// Copyright (c) 2020 linhey
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.

/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import Foundation
// MARK: - format

public extension StemValue where Base == String {
    /// format: NSNumber
    var number: NSNumber? { return NumberFormatter().number(from: base) }
    /// format: Int
    var int: Int? { return number?.intValue }
    /// format: Double
    var double: Double? { return number?.doubleValue }
    /// format: Float
    var float: Float? { return number?.floatValue }
    /// format: Bool
    var bool: Bool? {
        if let num = number { return num.boolValue }
        switch base.lowercased() {
        case "1", "true", "yes": return true
        case "0", "false", "no": return false
        default: return nil
        }
    }

    /// format: Date
    func date(mode: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = mode
        return formatter.date(from: base)
    }

    
    /// URL
    var url: URL? { return URL(string: base) }
    
    /// get json
    var jsonObject: Any? {
        guard let data = base.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
    }
    
}
