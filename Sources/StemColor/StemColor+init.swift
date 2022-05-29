//
//  File.swift
//  
//
//  Created by linhey on 2022/5/29.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension StemColor {
    
    convenience init(_ color: NSColor) {
       let color = color.usingColorSpace(.deviceRGB) ?? color
        self.init(rgb: .init(red: Double(color.redComponent),
                             green: Double(color.greenComponent),
                             blue: Double(color.blueComponent)),
                  alpha: Double(color.alphaComponent))
    }
    
}

#endif


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
    
    convenience init(_ color: UIColor) {
        self.init(color.cgColor)
    }
    
    func convert() -> CIColor {
        return CIColor(color: convert())
    }
    
}
#endif

