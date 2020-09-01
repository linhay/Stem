//
//  StemColorSpace+RYB.swift
//  Pods-macOS
//
//  Created by 林翰 on 2020/9/1.
//

import Foundation

public extension StemColor {

    struct CIELABSpace: StemColorSpace {
        public let l: Double
        public let a: Double
        public let b: Double

        public init(l: Double, a: Double, b: Double) {
            self.l = l
            self.a = a
            self.b = b
        }

    }

}

public extension StemColor.CIELABSpace {

    func l(with value: Double) -> Self { .init(l: value, a: a, b: b) }
    func a(with value: Double) -> Self { .init(l: l, a: value, b: b) }
    func b(with value: Double) -> Self { .init(l: l, a: a, b: value) }

}

extension StemColor.CIELABSpace: StemColorSpacePack {

    public var unpack: (l: Double, a: Double, b: Double) { (l, a, b) }
    public var list: [Double] { [l, a, b] }

    public init(_ list: [Double]) {
        self.init(l: list[0], a: list[1], b: list[2])
    }

    public init() {
        self.init([0.0, 0.0, 0.0])
    }

}

extension StemColor.CIELABSpace: StemColorSpaceRandom {

    public static var random: Self { .init([Double.random(in: 0...1),
                                            Double.random(in: 0...1),
                                            Double.random(in: 0...1)]) }

}
