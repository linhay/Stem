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

import UIKit

public protocol NibInstantiable {
    static var nibId: String { get }
}

extension NibInstantiable {
    public static var nibId: String {
        String(describing: self)
    }
}

extension NibInstantiable where Self: UIView {
    /// Instantiates and returns the nib of type `Self`.
    ///
    /// - Parameter bundle: The bundle containing the nib file and its related
    ///                     resources. If `nil`, then this method looks in the
    ///                     `main` bundle of the current application. The default
    ///                     value is `nil`.
    /// - Returns: The nib of type `Self`.
    public static func initFromNib(bundle: Bundle? = nil) -> Self {
        let bundle = bundle ?? Bundle(for: Self.self)
        return bundle.loadNibNamed(nibId, owner: nil, options: nil)!.first as! Self
    }
}

