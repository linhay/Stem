//
//  macOSTests.swift
//  macOSTests
//
//  Created by 林翰 on 2020/8/3.
//  Copyright © 2020 linhey.ax. All rights reserved.
//

import XCTest
import Stem

class macOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testHexColor() {
        let hex = "0xF1EBFF"
        let color = StemColor(hex: hex)
        print(color.hexString)
    }

    func testColor() {
        NSColor.st.displayMode = .rgb
        let color = StemColor.random

        let hex       = color.hexString
        let rgbSpace  = color.rgbSpace
        let xyzSpace  = color.xyzSpace
        let labSpace  = color.labSpace
        let hsbSpace  = color.hsbSpace
        let hslSpace  = color.hslSpace
        let cmySpace  = color.cmySpace
        let cmykSpace = color.cmykSpace

        print("hex: ", hex)
        print("rgb: ", rgbSpace)
        print("rgb: ", rgbSpace.red * 255, rgbSpace.green * 255, rgbSpace.blue * 255)
        print("xyz: ", xyzSpace)
        print("lab: ", labSpace)
        print("hsb: ", hsbSpace)
        print("hsl: ", hslSpace)
        print("cmy: ", cmySpace)
        print("cmyk: ", cmykSpace)


        assert(StemColor(lab: labSpace).rgbSpace.intUnpack == rgbSpace.intUnpack)
        assert(StemColor(xyz: xyzSpace).hexString == hex)
        assert(StemColor(lab: labSpace).hexString == hex)
        assert(StemColor(hsb: hsbSpace).hexString == hex)
        assert(StemColor(cmy: cmySpace).hexString == hex)
        assert(StemColor(cmyk: cmykSpace).hexString == hex)
        assert(StemColor(hsl: hslSpace).hexString == hex, "\(StemColor(hsl: hslSpace).rgbSpace)")

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}