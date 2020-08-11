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
        let color = NSColor("#666666")
        NSColor.st.displayMode = .rgb
        print(color.st.stemColor.rgbSpace)
        print(color.st.stemColor.xyzSpace)
        print(color.st.stemColor.labSpace)
        print(color.st.stemColor.cmySpace)
        print(color.st.stemColor.cmykSpace)
        print(StemColor(hsb: color.st.stemColor.hsbSpace).rgbSpace)
        print(StemColor(hsl: color.st.stemColor.hslSpace).rgbSpace)
        print(StemColor(xyz: color.st.stemColor.xyzSpace).rgbSpace)
        print(StemColor(xyz: color.st.stemColor.xyzSpace).labSpace)

        let lab = StemColor(xyz: color.st.stemColor.xyzSpace).labSpace
        print(StemColor(xyz: StemColor.XYZSpace(from: lab, tristimulus: nil)).rgbSpace)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
