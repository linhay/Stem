//
//  StemColorSpace+HSL.swift
//  Stem
//
//  Created by 林翰 on 2020/8/30.
//

import Foundation

public extension StemColor.HSLSpace {

    func lighter(amount: Double = 0.25) -> Self {
        return lightness(with: lightness * (1 + amount))
    }

    func darker(amount: Double = 0.25) -> Self {
        return lightness(with: lightness * (1 - amount))
    }

}

public extension StemColor.HSBSpace {

    func lighter(amount: Double = 0.25) -> Self {
        return brightness(with: brightness * (1 + amount))
    }

    func darker(amount: Double = 0.25) -> Self {
        return brightness(with: brightness * (1 - amount))
    }

}
