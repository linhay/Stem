//
//  StemColorSpace+RGB.swift
//  Stem
//
//  Created by 林翰 on 2020/8/19.
//

import Foundation

public extension StemColor.RGBSpace {

    func red(with value: Double)   -> StemColor.RGBSpace { .init(red: value, green: green, blue: blue) }
    func green(with value: Double) -> StemColor.RGBSpace { .init(red: red, green: value, blue: blue)   }
    func blue(with value: Double)  -> StemColor.RGBSpace { .init(red: blue, green: green, blue: value) }

}
