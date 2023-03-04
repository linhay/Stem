//
//  File.swift
//  
//
//  Created by linhey on 2023/3/4.
//

import Stem
import XCTest

class CGFloatExtensionTests: XCTestCase {
    
    func testAbs() {
        let value: CGFloat = -10
        XCTAssertEqual(value.st.abs, 10)
    }
    
    func testCeil() {
        let value: CGFloat = 10.5
        XCTAssertEqual(value.st.ceil, 11)
    }
    
    func testFloor() {
        let value: CGFloat = 10.5
        XCTAssertEqual(value.st.floor, 10)
    }
    
    func testString() {
        let value: CGFloat = 10.5
        XCTAssertEqual(value.st.string, "10.5")
    }
    
    func testInt() {
        let value: CGFloat = 10.5
        XCTAssertEqual(value.st.int, 10)
    }
    
    func testFloat() {
        let value: CGFloat = 10.5
        XCTAssertEqual(value.st.float, 10.5)
    }
    
    func testMax() {
        XCTAssertEqual(CGFloat.st.max, CGFloat.greatestFiniteMagnitude)
    }
}
