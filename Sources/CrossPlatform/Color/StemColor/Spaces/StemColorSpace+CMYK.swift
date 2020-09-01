//
//  StemColorSpace+RYB.swift
//  Pods-macOS
//
//  Created by 林翰 on 2020/9/1.
//

import Foundation

public extension StemColor {

     struct CMYKSpace: StemColorSpace {
        // value: 0 - 1.0
        public let cyan: Double
        // value: 0 - 1.0
        public let magenta: Double
        // value: 0 - 1.0
        public let yellow: Double
        // value: 0 - 1.0
        public let key: Double

        public init(cyan: Double, magenta: Double, yellow: Double, key: Double) {
            self.cyan = cyan
            self.magenta = magenta
            self.yellow = yellow
            self.key = key
        }

    }

}

public extension StemColor.CMYKSpace {

    func cyan(with value: Double)    -> Self { .init(cyan: value, magenta: magenta, yellow: yellow, key: key) }
    func magenta(with value: Double) -> Self { .init(cyan: cyan, magenta: value, yellow: yellow, key: key) }
    func yellow(with value: Double)  -> Self { .init(cyan: cyan, magenta: magenta, yellow: value, key: key) }
    func key(with value: Double)     -> Self { .init(cyan: cyan, magenta: magenta, yellow: yellow, key: value) }

}

extension StemColor.CMYKSpace: StemColorSpacePack {

    public var unpack: (cyan: Double, magenta: Double, yellow: Double, key: Double) { (cyan, magenta, yellow, key) }
    public var list: [Double] { [cyan, magenta, yellow, key] }

    public init(_ list: [Double]) {
        self.init(cyan: list[0], magenta: list[1], yellow: list[2], key: list[3])
    }

    public init() {
        self.init([0.0, 0.0, 0.0, 0.0])
    }

}

extension StemColor.CMYKSpace {

    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }

}
