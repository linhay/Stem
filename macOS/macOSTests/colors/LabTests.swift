//
//  LabTests.swift
//  macOSTests
//
//  Created by 林翰 on 2020/12/7.
//  Copyright © 2020 linhey.ax. All rights reserved.
//

import XCTest
@testable import Stem

class LabTests: XCTestCase {

    func testGreen() {
        let color = StemColor(NSColor.green)
        let space = color.labSpace
        XCTAssertEqual(space.l.rounded(precision: 100),  87.73)
        XCTAssertEqual(space.a.rounded(precision: 100), -86.18)
        XCTAssertEqual(space.b.rounded(precision: 100),  83.18)
    }
    
    func testWhite() {
        let color = StemColor(NSColor.white)
        let space = color.labSpace
        XCTAssertEqual(space.l.rounded(precision: 100), 100)
        XCTAssertEqual(space.a.rounded(precision: 100), 0.00)
        XCTAssertEqual(space.b.rounded(precision: 100), 0.00)
    }
    
    func testArbitrary() {
        let color = StemColor(NSColor(red: 129.0, green: 200.0, blue: 10.0, alpha: 1))
        let space = color.labSpace
        XCTAssertEqual(space.l.rounded(precision: 100), 73.54)
        XCTAssertEqual(space.a.rounded(precision: 100), -46.43)
        XCTAssertEqual(space.b.rounded(precision: 100), 72.05)
    }
    
}
