//
//  CMYKTests.swift
//  ColorKitTests
//
//  Created by Boris Emorine on 6/20/20.
//  Copyright © 2020 BorisEmorine. All rights reserved.
//

import XCTest
@testable import Stem

class CMYKTests: XCTestCase {

    func testGreen() {
        let color = UIColor.green
        let space = StemColor(color).cmykSpace
        
        XCTAssertEqual(space.cyan, 1.0)
        XCTAssertEqual(space.magenta, 0.0)
        XCTAssertEqual(space.yellow, 1.0)
        XCTAssertEqual(space.key, 0.0)
    }
    
    func testBlue() {
        let color = UIColor.blue
        let space = StemColor(color).cmykSpace

        XCTAssertEqual(space.cyan, 1.0)
        XCTAssertEqual(space.magenta, 1.0)
        XCTAssertEqual(space.yellow, 0.0)
        XCTAssertEqual(space.key, 0.0)
    }
    
    func testWhite() {
        let color = UIColor.white
        let space = StemColor(color).cmykSpace

        XCTAssertEqual(space.cyan, 0.0)
        XCTAssertEqual(space.magenta, 0.0)
        XCTAssertEqual(space.yellow, 0.0)
        XCTAssertEqual(space.key, 0.0)
    }
    
    func testArbitrary() {
        let space = StemColor(rgb: .init(red: 153.0 / 255.0, green: 71.0 / 255.0, blue: 206.0 / 255.0)).cmykSpace

        XCTAssertEqual(space.cyan, 0.26, accuracy: 0.01)
        XCTAssertEqual(space.magenta, 0.66, accuracy: 0.01)
        XCTAssertEqual(space.yellow, 0.0)
        XCTAssertEqual(space.key, 0.19, accuracy: 0.01)
    }
    
}
