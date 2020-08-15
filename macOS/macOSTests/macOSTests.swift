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

    func testColor() {
        let hex = "#008080"
        NSColor.st.displayMode = .rgb
        let color = NSColor(hex)
        let stemColor = color.st.stemColor
        assert(stemColor.hexString == hex)


        let rgbSpace  = color.st.stemColor.rgbSpace
        let xyzSpace  = color.st.stemColor.xyzSpace
        let labSpace  = color.st.stemColor.labSpace
        let hsbSpace  = color.st.stemColor.hsbSpace
        let hslSpace  = color.st.stemColor.hslSpace
        let cmySpace  = color.st.stemColor.cmySpace
        let cmykSpace = color.st.stemColor.cmykSpace

        print("rgb: ", rgbSpace)
        print("xyz: ", xyzSpace)
        print("lab: ", labSpace)
        print("hsb: ", hsbSpace)
        print("hsl: ", hslSpace)
        print("cmy: ", cmySpace)
        print("cmyk: ", cmykSpace)


        assert(StemColor(xyz: xyzSpace).hexString == hex)
        assert(StemColor(lab: labSpace).hexString == hex)
        assert(StemColor(hsb: hsbSpace).hexString == hex)
        assert(StemColor(hsl: hslSpace).hexString == hex, "\(StemColor(hsl: hslSpace).rgbSpace)")
        assert(StemColor(cmy: cmySpace).hexString == hex)
        assert(StemColor(cmyk: cmykSpace).hexString == hex)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
