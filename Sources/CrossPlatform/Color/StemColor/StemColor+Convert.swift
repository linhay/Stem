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

public extension StemColor {
    
    func convert() -> STWrapperColor {
        STWrapperColor(red: rgbSpace.red * 255,
                       green: rgbSpace.green * 255,
                       blue: rgbSpace.blue * 255,
                       alpha: alpha)
    }
    
    func convert() -> CGColor {
        return convert().cgColor
    }
    
}


#if canImport(CoreGraphics) && canImport(CoreImage)
import CoreGraphics
import CoreImage

public extension StemColor {
    
    convenience init(_ color: CGColor) {
        self.init(CIColor(cgColor: color))
    }
    
    convenience init(_ color: CIColor) {
        self.init(rgb: RGBSpace(red: Double(color.red),
                                green: Double(color.green),
                                blue: Double(color.blue)),
                  alpha: Double(color.alpha))
    }
    
}

#endif


#if canImport(UIKit)
import UIKit

public extension StemColor {
    
    convenience init(_ color: STWrapperColor) {
        self.init(color.cgColor)
    }
    
    func convert() -> CIColor {
        return CIColor(color: convert())
    }
    
}

#if canImport(SwiftUI)
import SwiftUI

@available(iOSApplicationExtension 13.0, *)
@available(iOS 14.0, OSX 11.0, tvOS 13.0, watchOS 6.0, *)
public extension StemColor {
    
    convenience init(_ color: SwiftUI.Color) {
        self.init(UIColor(color))
    }
    
    func convert() -> SwiftUI.Color {
        return Color(.displayP3,
                     red: rgbSpace.red,
                     green: rgbSpace.green,
                     blue: rgbSpace.blue,
                     opacity: alpha)
    }
    
}

#endif
#endif



