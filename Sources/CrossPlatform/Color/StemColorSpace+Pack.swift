//
//  StemColorSpace+darker.swift
//  Stem
//
//  Created by 林翰 on 2020/8/30.
//

import Foundation

public protocol StemColorSpacePack {

    associatedtype UnPack
    var unpack: UnPack { get }
    var list: [Double] { get }
    init(_ list: [Double])
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

}

extension StemColor.HSBSpace: StemColorSpacePack {

    public var unpack: (hue: Double, saturation: Double, brightness: Double) { (hue, saturation, brightness) }
    public var list: [Double] { [hue, saturation, brightness] }

    public init(_ list: [Double]) {
        self.init(hue: list[0], saturation: list[1], brightness: list[2])
    }

}

extension StemColor.HSLSpace: StemColorSpacePack {

    public var unpack: (hue: Double, saturation: Double, lightness: Double) { (hue, saturation, lightness) }
    public var list: [Double] { [hue, saturation, lightness] }

    public init(_ list: [Double]) {
        self.init(hue: list[0], saturation: list[1], lightness: list[2])
    }

}

extension StemColor.XYZSpace: StemColorSpacePack {

    public var unpack: (x: Double, y: Double, z: Double) { (x, y, z) }
    public var list: [Double] { [x, y, z] }

    public init(_ list: [Double]) {
        self.init(x: list[0], y: list[1], z: list[2])
    }

}

extension StemColor.LABSpace: StemColorSpacePack {

    public var unpack: (l: Double, a: Double, b: Double) { (l, a, b) }
    public var list: [Double] { [l, a, b] }

    public init(_ list: [Double]) {
        self.init(l: list[0], a: list[1], b: list[2])
    }

}

extension StemColor.CMYSpace: StemColorSpacePack {

    public var unpack: (cyan: Double, magenta: Double, yellow: Double) { (cyan, magenta, yellow) }
    public var list: [Double] { [cyan, magenta, yellow] }

    public init(_ list: [Double]) {
        self.init(cyan: list[0], magenta: list[1], yellow: list[2])
    }

}

extension StemColor.CMYKSpace: StemColorSpacePack {

    public var unpack: (cyan: Double, magenta: Double, yellow: Double, key: Double) { (cyan, magenta, yellow, key) }
    public var list: [Double] { [cyan, magenta, yellow, key] }

    public init(_ list: [Double]) {
        self.init(cyan: list[0], magenta: list[1], yellow: list[2], key: list[3])
    }

}

