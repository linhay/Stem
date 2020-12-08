//
//  XYZTests.swift
//  macOSTests
//
//  Created by 林翰 on 2020/12/7.
//  Copyright © 2020 linhey.ax. All rights reserved.
//

import XCTest
@testable import Stem

class XYZTests: XCTestCase {

    func testGreen() {
        let color = StemColor(NSColor.green)
        let space = color.xyzSpace
        XCTAssertEqual(space.x.rounded(precision: 10000), 0.3576)
        XCTAssertEqual(space.y.rounded(precision: 10000), 0.7152)
        XCTAssertEqual(space.z.rounded(precision: 10000), 0.1192)
    }
    
    func testWhite() {
        let color = StemColor(NSColor.white)
        let space = color.xyzSpace
        XCTAssertEqual(space.x.rounded(precision: 10000), 0.9505)
        XCTAssertEqual(space.y.rounded(precision: 10000), 1)
        XCTAssertEqual(space.z.rounded(precision: 10000), 1.0888)
    }
    
    func testArbitrary() {
        let color = StemColor(NSColor(red: 129.0/255.0, green: 200.0/255.0, blue: 10.0/255.0, alpha: 1.0))
        let space = color.xyzSpace
        XCTAssertEqual(space.x.rounded(precision: 10000), 0.2976)
        XCTAssertEqual(space.y.rounded(precision: 10000), 0.46)
        XCTAssertEqual(space.z.rounded(precision: 10000), 0.076)
    }
    
}
