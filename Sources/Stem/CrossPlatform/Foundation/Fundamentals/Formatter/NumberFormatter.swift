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

public extension Stem where Base: NumberFormatter {

    func string(from value: Int8) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: UInt8) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: Int32) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: UInt32) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: Int64) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: UInt64) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: Float) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: Double) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: Bool) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: Int) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: UInt) -> String? {
        return base.string(from: .init(value: value))
    }

}
