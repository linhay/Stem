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

    func hue(with value: Double)        -> Self { .init(hue: value, saturation: saturation, lightness: lightness) }
    func saturation(with value: Double) -> Self { .init(hue: hue, saturation: value, lightness: lightness)   }
    func lightness(with value: Double)  -> Self { .init(hue: hue, saturation: saturation, lightness: value)  }

}

public extension StemColor.XYZSpace {

    func x(with value: Double) -> Self { .init(x: value, y: y, z: z) }
    func y(with value: Double) -> Self { .init(x: x, y: value, z: z) }
    func z(with value: Double) -> Self { .init(x: x, y: y, z: value) }

}

public extension StemColor.LABSpace {

    func l(with value: Double) -> Self { .init(l: value, a: a, b: b) }
    func a(with value: Double) -> Self { .init(l: l, a: value, b: b) }
    func b(with value: Double) -> Self { .init(l: l, a: a, b: value) }

}

public extension StemColor.CMYSpace {

    func cyan(with value: Double)    -> Self { .init(cyan: value, magenta: magenta, yellow: yellow) }
    func magenta(with value: Double) -> Self { .init(cyan: cyan, magenta: value, yellow: yellow) }
    func yellow(with value: Double)  -> Self { .init(cyan: cyan, magenta: magenta, yellow: value) }

}

public extension StemColor.CMYKSpace {

    func cyan(with value: Double)    -> Self { .init(cyan: value, magenta: magenta, yellow: yellow, key: key) }
    func magenta(with value: Double) -> Self { .init(cyan: cyan, magenta: value, yellow: yellow, key: key) }
    func yellow(with value: Double)  -> Self { .init(cyan: cyan, magenta: magenta, yellow: value, key: key) }
    func key(with value: Double)     -> Self { .init(cyan: cyan, magenta: magenta, yellow: yellow, key: value) }

}


