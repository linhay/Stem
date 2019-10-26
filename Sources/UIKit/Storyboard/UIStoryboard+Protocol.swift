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

public protocol StoryboardInstantiable {
    static var storyboardID: String { get }
}

extension StoryboardInstantiable {
    public static var storyboardID: String {
        String(describing: self)
    }
}

extension StoryboardInstantiable where Self: UIViewController {
    /// Instantiates and returns the view controller of type `Self`.
    ///
    /// - Parameters:
    ///   - named: The name of the storyboard file without the file extension. The
    ///            default value is `Main`.
    ///   - bundle: The bundle containing the storyboard file and its related
    ///             resources. If `nil`, then this method looks in the `main` bundle
    ///             of the current application. The default value is `nil`.
    /// - Returns: The view controller of type `Self`.
    public static func initFromStoryboard(named: String = "Main", bundle: Bundle? = nil) -> Self {
        let bundle = bundle ?? Bundle(for: Self.self)
        return UIStoryboard(name: named, bundle: bundle).instantiateViewController(withIdentifier: storyboardID) as! Self
    }
}
