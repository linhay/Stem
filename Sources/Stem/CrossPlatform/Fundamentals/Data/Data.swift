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
    
    /// get json
    var jsonObject: Any? {
        return try? JSONSerialization.jsonObject(with: base, options: [.allowFragments])
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
        let hexLen = base.count * 2
        let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: hexLen)
        var offset = 0
        
        let charA = UInt8(UnicodeScalar("a").value)
        let char0 = UInt8(UnicodeScalar("0").value)
        
        base.regions.forEach { (_) in
            for i in base {
                ptr[Int(offset * 2)] = itoh((i >> 4) & 0xF, charA: charA, char0: char0)
                ptr[Int(offset * 2 + 1)] = itoh(i & 0xF, charA: charA, char0: char0)
                offset += 1
            }
        }
        return String(bytesNoCopy: ptr, length: hexLen, encoding: .utf8, freeWhenDone: true)!
    }
    
    private func itoh(_ value: UInt8, charA: UInt8, char0: UInt8) -> UInt8 {
        return (value > 9) ? (charA + value - 10) : (char0 + value)
    }
    
}
