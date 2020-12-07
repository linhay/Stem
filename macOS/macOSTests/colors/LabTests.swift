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
        XCTAssertEqual((space.l * 100).rounded(), 8773)
        XCTAssertEqual((space.a * 100).rounded(), -8618)
        XCTAssertEqual((space.b * 100).rounded(), 8318)
    }
    
    func testWhite() {
        let color = StemColor(NSColor.white)
        let space = color.labSpace
        XCTAssertEqual((space.l * 100).rounded(), 10000)
        XCTAssertEqual((space.a * 100).rounded(), 0)
        XCTAssertEqual((space.b * 100).rounded(), 0)
    }
    
    func testArbitrary() {
        let color = StemColor(NSColor(red: 129.0, green: 200.0, blue: 10.0, alpha: 1))
        let space = color.labSpace
        XCTAssertEqual((space.l * 100).rounded(), 7354)
        XCTAssertEqual((space.a * 100).rounded(), -4643)
        XCTAssertEqual((space.b * 100).rounded(), 7205)
    }
    
}
