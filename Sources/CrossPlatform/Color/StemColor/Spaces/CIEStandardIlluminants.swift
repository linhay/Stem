//
//  CIEStandardIlluminants.swift
//  Stem
//
//  Created by 林翰 on 2020/9/6.
//

import Foundation

public struct CIEStandardIlluminants: StemColorSpace {

    public var rawValue: [Double]

    init(rawValue: [Double]) {
        self.rawValue = rawValue
    }

    /// A (ASTM E308-01)
    public static let A   = CIEStandardIlluminants(rawValue: [1.09850, 1.0, 0.35585])
    /// B (Wyszecki & Stiles, p. 769)
    public static let B   = CIEStandardIlluminants(rawValue: [0.99072, 1.0, 0.85223])
    /// C (ASTM E308-01)
    public static let C   = CIEStandardIlluminants(rawValue: [0.98074, 1.0, 1.18232])
    /// D50 (ASTM E308-01)
    public static let D50 = CIEStandardIlluminants(rawValue: [0.96422, 1.0, 0.82521])
    /// D55 (ASTM E308-01)
    public static let D55 = CIEStandardIlluminants(rawValue: [0.95682, 1.0, 0.92149])
    /// D65 (ASTM E308-01)
    public static let D65 = CIEStandardIlluminants(rawValue: [0.95047, 1.0, 1.08883])
    /// D75 (ASTM E308-01)
    public static let D75 = CIEStandardIlluminants(rawValue: [0.94972, 1.0, 1.22638])
    /// E (ASTM E308-01)
    public static let E   = CIEStandardIlluminants(rawValue: [1.00000, 1.0, 1.00000])
    /// F2 (ASTM E308-01)
    public static let F2  = CIEStandardIlluminants(rawValue: [0.99186, 1.0, 0.67393])
    /// F7 (ASTM E308-01)
    public static let F7  = CIEStandardIlluminants(rawValue: [0.95041, 1.0, 1.08747])
    /// F11 (ASTM E308-01)
    public static let F11 = CIEStandardIlluminants(rawValue: [1.00962, 1.0, 0.64350])

}
