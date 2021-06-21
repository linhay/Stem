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

#if canImport(CoreGraphics)
import Foundation
import CoreGraphics

extension CGRect: StemValueCompatible { }

public extension StemValue where Base == CGRect {

    /// 判断一个 CGRect 是否合法（例如不带无穷大的值、不带非法数字）
    var isValidated: Bool {
        guard !base.isNull, !base.isInfinite else { return false }
        return true
    }
    
    /// 获取合并后的最小矩形
    /// - Parameter list: 矩形列表
    /// - Returns: 合并后的最小矩形
    static func union(_ list: [CGRect]) -> CGRect {
        guard var value = list.first else {
            return .zero
        }
        
        for item in list.dropFirst() {
            value = value.union(item)
        }
        return value
    }
    
}
#endif
