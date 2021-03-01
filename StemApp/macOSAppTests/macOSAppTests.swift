//
//  macOSAppTests.swift
//  macOSAppTests
//
//  Created by 林翰 on 2021/3/1.
//

import XCTest
import Stem

class macOSAppTests: XCTestCase { 

    func testExample() throws {
        do {
            let s1 = StemColor.RGBSpace([170.0 / 255, 127.0 / 255, 200.0 / 255])
            let s2 = StemColor.RGBSpace([57.0 / 255, 56.0 / 255, 232.0 / 255])
//            let rgb = StemColor(rgb: s1).mix(with: .init(rgb: s2), use: .kubelkaMunk).rgbSpace
//            print(rgb.intUnpack)
        }

        do {
            let s1 = StemColor.RGBSpace([0,0,0])
            let s2 = StemColor.RGBSpace([1,1,1])
//            let rgb = StemColor(rgb: s1).mix(with: .init(rgb: s2), use: .kubelkaMunk).rgbSpace
//            print(rgb.intUnpack)
        }
    }

    func testHexColor() {
        let hex = "0xF1EBFF"
        let color = StemColor(hex: hex)
        print(color.hexString)
    }

    func testColor() {
        NSColor.st.displayMode = .rgb
        let color = StemColor(hex: "0x2748A3")

        let hex       = color.hexString
        let rgbSpace  = color.rgbSpace
        let xyzSpace  = color.xyzSpace
        let labSpace  = color.labSpace
        let hsbSpace  = color.hsbSpace
        let hslSpace  = color.hslSpace
        let cmySpace  = color.cmySpace
        let cmykSpace = color.cmykSpace
        let rybSpace  = color.rybSpace

        if #available(OSX 11.0, *) {
            print(AXNameFromColor(color.convert()))
        } else {
            // Fallback on earlier versions
        }
        print("hex: ", hex)
        print("rgb: ", rgbSpace)
        print("rgb: ", rgbSpace.intUnpack)
        print("ryb: ", rybSpace)
        print("xyz: ", xyzSpace)
        print("lab: ", labSpace)
        print("hsb: ", hsbSpace)
        print("hsl: ", hslSpace)
        print("cmy: ", cmySpace)
        print("cmyk: ", cmykSpace)


        assert(StemColor(xyz: xyzSpace).hexString == hex)
        assert(StemColor(ryb: rybSpace).hexString == hex)
        assert(StemColor(hsb: hsbSpace).hexString == hex)
        assert(StemColor(cmy: cmySpace).hexString == hex)
        assert(StemColor(cmyk: cmykSpace).hexString == hex)
        assert(StemColor(hsl: hslSpace).hexString == hex, "\(StemColor(hsl: hslSpace).rgbSpace)")
        assert(StemColor(lab: labSpace).hexString == hex)
        assert(StemColor(lab: labSpace).rgbSpace.intUnpack == rgbSpace.intUnpack)

    }

}
