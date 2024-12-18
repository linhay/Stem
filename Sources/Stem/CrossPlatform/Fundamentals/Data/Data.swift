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

extension Data: StemValueCompatible { }

public extension StemValue where Base == Data {
    
    func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: base, options: options)
    }
    
    /// 获取bytes 数组
    ///
    /// - Parameter _: 类型
    /// - Returns: bytes
    var bytes: [UInt8] {
        // http://stackoverflow.com/questions/38097710/swift-3-changes-for-getbytes-method
        return [UInt8](base)
    }
    
    /// 获取对应编码类型字符串
    ///
    /// - Parameter using: 字符串编码类型 | default: utf8
    /// - Returns: 字符串
    func string(encoding: String.Encoding = .utf8) -> String? {
        return String(data: base, encoding: encoding)
    }
    
    var hexString: String {
        var hexString = ""
        for byte in base {
            hexString += String(format: "%02x", byte)
        }
        return hexString
    }
    
    private func itoh(_ value: UInt8, charA: UInt8, char0: UInt8) -> UInt8 {
        return (value > 9) ? (charA + value - 10) : (char0 + value)
    }
    
}
