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

extension CharacterSet: StemValueCompatible { }

public extension StemValue where Base == CharacterSet {

    // 对urlQuery中的value转义
    static let urlQueryValueAllowed = CharacterSet(charactersIn: "&\"#%<>[]^`{|}=").inverted


    /// 获取集中的字符
    var unicodeScalars: [UnicodeScalar] {
        var result: [UnicodeScalar] = []
        for plane in Unicode.UTF8.CodeUnit.min...16 where base.hasMember(inPlane: plane) {
            for unicode in Unicode.UTF32.CodeUnit(plane) << 16 ..< Unicode.UTF32.CodeUnit(plane + 1) << 16 {
                if let uniChar = UnicodeScalar(unicode), base.contains(uniChar) {
                    result.append(uniChar)
                }
            }
        }
        return result
    }
}
