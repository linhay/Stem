//
//  Stem
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
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

import UIKit

public extension CGFloat {
    
    static var max = CGFloat.greatestFiniteMagnitude
    
}

public extension Float {
    var cgFloat: CGFloat { return CGFloat(self) }
}

public extension Double {
    var cgFloat: CGFloat { return CGFloat(self) }
}

public extension Int {
    var cgFloat: CGFloat { return CGFloat(self) }
}

public extension CGFloat {
    /// 绝对值
    var abs: CGFloat { return Swift.abs(self) }
    /// 向上取整
    var ceil: CGFloat { return Foundation.ceil(self) }
    /// 向下取整
    var floor: CGFloat { return Foundation.floor(self) }
    
    var string: String { return description }
    
    var int: Int { return Int(self) }
    var float: Float { return Float(self) }
}
