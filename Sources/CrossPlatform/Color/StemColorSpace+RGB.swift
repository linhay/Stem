//
//  StemColorSpace+RGB.swift
//  Stem
//
//  Created by 林翰 on 2020/8/19.
//

import Foundation

public extension StemColor.RGBSpace {

    func red(with value: Double)   -> Self { .init(red: value, green: green, blue: blue)  }
    func green(with value: Double) -> Self { .init(red: red,   green: value, blue: blue)  }
    func blue(with value: Double)  -> Self { .init(red: red,   green: green, blue: value) }

}

public extension StemColor.HSBSpace {

    func hue(with value: Double)        -> Self { .init(hue: value, saturation: saturation, brightness: brightness)  }
    func saturation(with value: Double) -> Self { .init(hue: hue, saturation: value, brightness: brightness)  }
    func brightness(with value: Double) -> Self { .init(hue: hue, saturation: saturation, brightness: value)  }

}

public extension StemColor.HSLSpace {

    func hue(with value: Double)        -> Self { .init(hue: hue, saturation: saturation, lightness: lightness) }
    func saturation(with value: Double) -> Self { .init(hue: hue, saturation: value, lightness: lightness)   }
    func lightness(with value: Double)  -> Self { .init(hue: hue, saturation: saturation, lightness: value)  }

}


