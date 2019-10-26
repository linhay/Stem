//
//  Stem
//
//  github: https://github.com/linhay/Stem
//  Copyright (c) 2019 linhay - https://github.com/linhay
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

extension Data: StemValueCompatible { }

extension StemValue where Base == Data {

    // http://stackoverflow.com/questions/39248092/nsattributedstring-extension-in-swift-3
    @available(iOS 9.0, *)
    public var attributedString: NSAttributedString? {
        return try? NSAttributedString(data: base,
                                       options: [.documentType: NSAttributedString.DocumentType.html,
                                                 .characterEncoding: String.Encoding.utf8.rawValue],
                                       documentAttributes: nil)
    }

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

}
