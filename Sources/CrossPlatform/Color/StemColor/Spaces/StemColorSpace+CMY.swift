//
//  StemColorSpace+RYB.swift
//  Pods-macOS
//
//  Created by 林翰 on 2020/9/1.
//

import Foundation

public extension StemColor {

    struct CMYSpace: StemColorSpace {
        // value: 0 - 1.0
        public let cyan: Double
        // value: 0 - 1.0
        public let magenta: Double
        // value: 0 - 1.0
        public let yellow: Double

        public init(cyan: Double, magenta: Double, yellow: Double) {
            self.cyan = cyan
            self.magenta = magenta
            self.yellow = yellow
        }
    }

}

extension StemColor.CMYSpace: StemColorCMYKSpaceConversion {

    public var convertToCMYK: (cyan: Double, magenta: Double, yellow: Double, key: Double) {
        var (cyan, magenta, yellow) = unpack
        let key = min(cyan, magenta, yellow)
        if key == 1 {
            cyan = 0
            magenta = 0
            yellow = 0
        } else {
            cyan    = (cyan - key)    / (1 - key)
            magenta = (magenta - key) / (1 - key)
            yellow  = (yellow - key)  / (1 - key)
        }

        return (cyan, magenta, yellow, key)
    }

    public init(cyan: Double, magenta: Double, yellow: Double, key: Double) {
        let cyan    = cyan    * (1 - key) + key
        let magenta = magenta * (1 - key) + key
        let yellow  = yellow  * (1 - key) + key
        self.init(cyan: cyan, magenta: magenta, yellow: yellow)
    }

}

public extension StemColor.CMYSpace {

    func cyan(with value: Double)    -> Self { .init(cyan: value, magenta: magenta, yellow: yellow) }
    func magenta(with value: Double) -> Self { .init(cyan: cyan, magenta: value, yellow: yellow) }
    func yellow(with value: Double)  -> Self { .init(cyan: cyan, magenta: magenta, yellow: value) }

}

extension StemColor.CMYSpace: StemColorRGBSpaceConversion {

    public var convertToRGB: (red: Double, green: Double, blue: Double) {
        return (1 - cyan, 1 - magenta, 1 - yellow)
    }

    public init(red: Double, green: Double, blue: Double) {
        let cyan    = 1 - red
        let magenta = 1 - green
        let yellow  = 1 - blue
        self.init(cyan: cyan, magenta: magenta, yellow: yellow)
    }

}

extension StemColor.CMYSpace: StemColorSpacePack {

    public var unpack: (cyan: Double, magenta: Double, yellow: Double) { (cyan, magenta, yellow) }
    public var list: [Double] { [cyan, magenta, yellow] }

    public init(_ list: [Double]) {
        self.init(cyan: list[0], magenta: list[1], yellow: list[2])
    }

    public init() {
        self.init([0.0, 0.0, 0.0])
    }

}

extension StemColor.CMYSpace: StemColorSpaceRandom {

    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }

}
