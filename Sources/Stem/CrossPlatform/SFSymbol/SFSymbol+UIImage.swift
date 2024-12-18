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

#if canImport(UIKit)
import UIKit

@available(iOS 13.0, *)
public extension UIImage {
    
    /// Retrieve a system symbol image of the given type.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    convenience init(_ symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)!
    }
    
    /// Retrieve a system symbol image of the given type and with the given configuration.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    /// - Parameter configuration: The `UIImage.Configuration` applied to this system image.
    convenience init(sfSymbol: SFSymbol, with configuration: UIImage.Configuration) {
        self.init(systemName: sfSymbol.rawValue, withConfiguration: configuration)!
    }
}

@available(iOS 13.0, *)
public extension SFSymbol {

    func convert(_ configuration: UIImage.SymbolConfiguration) -> UIImage {
        return UIImage.init(sfSymbol: self, with: configuration)
    }
    
    func convert() -> UIImage {
        return UIImage(self)
    }
    
}
#endif
