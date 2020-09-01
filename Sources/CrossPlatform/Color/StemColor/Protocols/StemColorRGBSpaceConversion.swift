//
//  StemColorRGBSpaceConversion.swift
//  Pods-macOS
//
//  Created by 林翰 on 2020/9/1.
//

import Foundation

public protocol StemColorRGBSpaceConversion {
    init(red: Double, green: Double, blue: Double)
    var convertToRGB: (red: Double, green: Double, blue: Double) { get }
}


public protocol StemColorCMYKSpaceConversion {
    init(cyan: Double, magenta: Double, yellow: Double, key: Double)
    var convertToCMYK: (cyan: Double, magenta: Double, yellow: Double, key: Double) { get }
}

public protocol StemColorCIELABSpaceConversion {
    init(l: Double, a: Double, b: Double)
    var convertToLAB: (l: Double, a: Double, b: Double) { get }
}
