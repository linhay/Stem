//
//  StemColorSpace+RGB.swift
//  Pods-macOS
//
//  Created by 林翰 on 2020/9/1.
//

import Foundation

public extension StemColor {

    public struct RGBSpace: StemColorSpace {
        // value: 0 - 1.0
        public let red: Double
        // value: 0 - 1.0
        public let green: Double
        // value: 0 - 1.0
        public let blue: Double

        public init(red: Double, green: Double, blue: Double) {
            self.red   = max(min(red,   1), 0)
            self.green = max(min(green, 1), 0)
            self.blue  = max(min(blue,  1), 0)
        }

    }

}

public extension StemColor.RGBSpace {

    func red(with value: Double)   -> Self { .init(red: value, green: green, blue: blue)  }
    func green(with value: Double) -> Self { .init(red: red,   green: value, blue: blue)  }
    func blue(with value: Double)  -> Self { .init(red: red,   green: green, blue: value) }

}

extension StemColor.RGBSpace: StemColorSpacePack {

    public var unpack: (red: Double, green: Double, blue: Double) { (red, green, blue) }
    public var list: [Double] { [red, green, blue] }
    public var intUnpack: (red: Int, green: Int, blue: Int) {
        func map(_ v: Double) -> Int { Int(round(v * 255)) }
        return (map(red), map(green), map(blue))
    }

    public init(_ list: [Double]) {
        self.init(red: list[0], green: list[1], blue: list[2])
    }

    public init() {
        self.init([0.0, 0.0, 0.0])
    }

}

extension StemColor.RGBSpace: StemColorSpaceRandom {

    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }

}
