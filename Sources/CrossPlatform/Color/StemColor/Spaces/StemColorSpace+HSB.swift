//
//  StemColorSpace+RYB.swift
//  Pods-macOS
//
//  Created by 林翰 on 2020/9/1.
//

import Foundation

public extension StemColor {

    struct HSBSpace: StemColorSpace {
        // value: 0 - 1.0
        public let hue: Double
        // value: 0 - 1.0
        public let saturation: Double
        // value: 0 - 1.0
        public let brightness: Double

        public init(hue: Double, saturation: Double, brightness: Double) {
            if hue > 1 {
                self.hue = hue.truncatingRemainder(dividingBy: 1)
            } else if hue < 0 {
                self.hue = hue.truncatingRemainder(dividingBy: 1) + 1
            } else {
                self.hue = hue
            }
            self.saturation = max(min(saturation, 1), 0)
            self.brightness = max(min(brightness, 1), 0)
        }

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

public extension StemColor.HSBSpace {

    func hue(with value: Double)        -> Self { .init(hue: value, saturation: saturation, brightness: brightness)  }
    func saturation(with value: Double) -> Self { .init(hue: hue, saturation: value, brightness: brightness)  }
    func brightness(with value: Double) -> Self { .init(hue: hue, saturation: saturation, brightness: value)  }

}

extension StemColor.HSBSpace: StemColorRGBSpaceConversion {

    public var convertToRGB: (red: Double, green: Double, blue: Double) {
        var (red, green, blue) = (0.0, 0.0, 0.0)
        let (hue, saturation, brightness) = unpack

        if saturation == 0 {
            red   = brightness
            green = brightness
            blue  = brightness
        } else {
            let hue = hue * 6
            let varI = floor(hue)
            let var1 = brightness * (1 - saturation)
            let var2 = brightness * (1 - saturation * (hue - varI))
            let var3 = brightness * (1 - saturation * (1 - (hue - varI)))

            switch varI {
            case 0:
                red = brightness
                green = var3
                blue = var1
            case 1:
                red = var2
                green = brightness
                blue = var1
            case 2:
                red = var1
                green = brightness
                blue = var3
            case 3:
                red = var1
                green = var2
                blue = brightness
            case 4:
                red = var3
                green = var1
                blue = brightness
            default:
                red = brightness
                green = var1
                blue = var2
            }
        }
        return (red, green, blue)
    }

    public init(red: Double, green: Double, blue: Double) {
        let Max = max(red, green, blue)
        let Min = min(red, green, blue)
        let delMax = Max - Min

        var hue = 0.0
        var saturation = 0.0
        let brightness = Max

        //h 0-360
        if delMax != 0 {
            saturation = delMax / Max

            let delRed   = (((Max - red)   / 6) + delMax / 2) / delMax
            let delGreen = (((Max - green) / 6) + delMax / 2) / delMax
            let delBlue  = (((Max - blue)  / 6) + delMax / 2) / delMax

            if red == Max {
                hue = delBlue - delGreen
            } else if green == Max {
                hue = (1 / 3) + delRed - delBlue
            } else if blue == Max {
                hue = (2 / 3) + delGreen - delRed
            } else {
                hue = 0
            }
        }

        self.init(hue: hue, saturation: saturation, brightness: brightness)
    }

}

extension StemColor.HSBSpace: StemColorSpacePack {

    public var unpack: (hue: Double, saturation: Double, brightness: Double) { (hue, saturation, brightness) }
    public var list: [Double] { [hue, saturation, brightness] }

    public init(_ list: [Double]) {
        self.init(hue: list[0], saturation: list[1], brightness: list[2])
    }

    public init() {
        self.init([0.0, 0.0, 0.0])
    }

}

extension StemColor.HSBSpace: StemColorSpaceRandom {

    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }

}
