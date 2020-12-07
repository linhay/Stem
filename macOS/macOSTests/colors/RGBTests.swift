//
//  RGBTests.swift
//  macOSTests
//
//  Created by 林翰 on 2020/12/7.
//  Copyright © 2020 linhey.ax. All rights reserved.
//

import XCTest
@testable import Stem

class RGBTests: XCTestCase {
    
    func testRed() {
        let color = StemColor(NSColor.red)
        let space = color.rgbSpace
        XCTAssertEqual(space.red, 1.0)
        XCTAssertEqual(space.green, 0.0)
        XCTAssertEqual(space.blue, 0.0)
        XCTAssertEqual(color.alpha, 1.0)
    }
    
    func testGreen() {
        let color = StemColor(NSColor.green)
        let space = color.rgbSpace
        XCTAssertEqual(space.red, 0.0)
        XCTAssertEqual(space.green, 1.0)
        XCTAssertEqual(space.blue, 0.0)
        XCTAssertEqual(color.alpha, 1.0)
    }

    func testBlue() {
        let color = StemColor(NSColor.blue)
        let space = color.rgbSpace

        XCTAssertEqual(space.red, 0.0)
        XCTAssertEqual(space.green, 0.0)
        XCTAssertEqual(space.blue, 1.0)
        XCTAssertEqual(color.alpha, 1.0)
    }
    
    func testWhite() {
        let color = StemColor(NSColor.white)
        let space = color.rgbSpace

        XCTAssertEqual(space.red, 1.0)
        XCTAssertEqual(space.green, 1.0)
        XCTAssertEqual(space.blue, 1.0)
        XCTAssertEqual(color.alpha, 1.0)
    }
    
    func testBlack() {
        let color = StemColor(NSColor.black)
        let space = color.rgbSpace

        XCTAssertEqual(space.red, 0.0)
        XCTAssertEqual(space.green, 0.0)
        XCTAssertEqual(space.blue, 0.0)
        XCTAssertEqual(color.alpha, 1.0)
    }
    
    func testGray() {
        let color = StemColor(NSColor.gray)
        let space = color.rgbSpace

        XCTAssertEqual(space.red, 0.5)
        XCTAssertEqual(space.green, 0.5)
        XCTAssertEqual(space.blue, 0.5)
        XCTAssertEqual(color.alpha, 1.0)
    }
    
    func testPurple() {
        let color = StemColor(NSColor.purple)
        let space = color.rgbSpace

        XCTAssertEqual(space.red, 0.5)
        XCTAssertEqual(space.green, 0.0)
        XCTAssertEqual(space.blue, 0.5)
        XCTAssertEqual(color.alpha, 1.0)
    }

}
