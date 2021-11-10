//
//  LabTests.swift
//  ColorKitTests
//
//  Created by Boris Emorine on 2/26/20.
//  Copyright © 2020 BorisEmorine. All rights reserved.
//

import XCTest
import Stem

class LabTests: XCTestCase {

    func testGreen() {
        let color = UIColor.green
        let space = StemColor(color).labSpace
        
        XCTAssertEqual(space.l, 87.74, accuracy: 0.01)
        XCTAssertEqual(space.a, -86.18, accuracy: 0.01)
        XCTAssertEqual(space.b, 83.18, accuracy: 0.01)
    }
    
    func testWhite() {
        let space = StemColor(.init(red: 1, green: 1, blue: 1)).labSpace

        XCTAssertEqual(space.l, 100.0, accuracy: 0.01)
        XCTAssertEqual(space.a, 0.01, accuracy: 0.01)
        XCTAssertEqual(space.b, -0.01, accuracy: 0.01)
    }
    
    func testArbitrary() {
        let space = StemColor(rgb: .init(red: 129.0 / 255.0, green: 200.0 / 255.0, blue: 10.0 / 255.0)).labSpace

        XCTAssertEqual(space.l, 73.55, accuracy: 0.01)
        XCTAssertEqual(space.a, -46.45, accuracy: 0.01)
        XCTAssertEqual(space.b, 72.04, accuracy: 0.01)
    }
    
}
