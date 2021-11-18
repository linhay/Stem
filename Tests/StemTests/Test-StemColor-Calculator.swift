//
//  CMYKTests.swift
//  ColorKitTests
//
//  Created by linhey on 2021/11/18.
//

import XCTest
import Stem

class CMYKTests: XCTestCase {

    func testRed() {
        let color = StemColor.red
        assertEqual(color.hslSpace.list,  [0, 1, 0.5])
        assertEqual(color.hsvSpace.list,  [0, 1, 1])
        assertEqual(color.cmySpace.list,  [0, 1, 1])
        assertEqual(color.cmykSpace.list, [0, 1, 1, 0])
        assertEqual(color.labSpace.list,  [53.241, 80.092, 67.203])
        assertEqual(color.xyzSpace.list.map({ $0 * 100 }), [41.246, 21.267, 1.933])
    }
    
    func testGreen() {
        let color = StemColor.green
        assertEqual(color.hslSpace.list,  [0.33333, 1.00000, 0.50000])
        assertEqual(color.hsvSpace.list,  [0.33333, 1.00000, 1.00000])
        assertEqual(color.cmySpace.list,  [1.00000, 0.00000, 1.00000])
        assertEqual(color.cmykSpace.list, [1.00000, 0.00000, 1.00000, 0.00000])
        assertEqual(color.labSpace.list,  [87.735,-86.183,83.179])
        assertEqual(color.xyzSpace.list.map({ $0 * 100 }), [35.758,71.515,11.919])
    }
    
    func testBlue() {
        let color = StemColor.blue
        assertEqual(color.hslSpace.list,  [0.66667, 1.00000, 0.50000])
        assertEqual(color.hsvSpace.list,  [0.66667, 1.00000, 1.00000])
        assertEqual(color.cmySpace.list,  [1.00000, 1.00000, 0.00000])
        assertEqual(color.cmykSpace.list, [1.00000, 1.00000, 0.00000, 0.00000])
        assertEqual(color.labSpace.list,  [32.297, 79.188, -107.860])
        assertEqual(color.xyzSpace.list.map({ $0 * 100 }), [18.044, 7.217, 95.030])
    }
    
    func testWhite() {
        let color = StemColor.white
        assertEqual(color.hslSpace.list,  [0.00000, 0.00000, 1.00000])
        assertEqual(color.hsvSpace.list,  [0.00000, 0.00000, 1.00000])
        assertEqual(color.cmySpace.list,  [0.00000, 0.00000, 0.00000])
        assertEqual(color.cmykSpace.list, [0.00000, 0.00000, 0.00000, 0.00000])
        assertEqual(color.labSpace.list,  [100.000,   0.000,  -0.000])
        assertEqual(color.xyzSpace.list.map({ $0 * 100 }), [95.047, 100.000, 108.883])
    }
    
    func testBlack() {
        let color = StemColor.black
        assertEqual(color.hslSpace.list,  [0.00000, 0.00000, 0.00000])
        assertEqual(color.hsvSpace.list,  [0.00000, 0.00000, 0.00000])
        assertEqual(color.cmySpace.list,  [1.00000, 1.00000, 1.00000])
        assertEqual(color.cmykSpace.list, [0.00000, 0.00000, 0.00000, 1.00000])
        assertEqual(color.labSpace.list,  [0.000,   0.000,   0.000])
        assertEqual(color.xyzSpace.list.map({ $0 * 100 }), [0.000,   0.000,   0.000])
    }
    
    func testPurple() {
        let color = StemColor.purple
        assertEqual(color.hslSpace.list,  [0.72263, 0.62558, 0.57059])
        assertEqual(color.hsvSpace.list,  [0.72263, 0.64019, 0.83922])
        assertEqual(color.cmySpace.list,  [0.51765, 0.69804, 0.16078])
        assertEqual(color.cmykSpace.list, [0.42524, 0.64019, 0.00000, 0.16078])
        assertEqual(color.labSpace.list,  [44.763, 49.471, -63.785])
        assertEqual(color.xyzSpace.list.map({ $0 * 100 }), [22.957, 14.373, 65.171])
    }
    
    func testHex() {
        let color = StemColor.purple
        XCTAssertEqual(color.hexString(), "#7B4DD6")
        XCTAssertEqual(color.hexString(.digits6, prefix: .bits), "0x7B4DD6")
        XCTAssertEqual(color.hexString(.digits6, prefix: .hashKey), "#7B4DD6")
        XCTAssertEqual(color.hexString(.digits6, prefix: .none), "7B4DD6")
        
        XCTAssertEqual(color.hexString(.digits8, prefix: .bits), "0xFF7B4DD6")
        XCTAssertEqual(color.hexString(.digits8, prefix: .hashKey), "#FF7B4DD6")
        XCTAssertEqual(color.hexString(.digits8, prefix: .none), "FF7B4DD6")
    }
    
    func assertEqual(_ lhs: [Double], _ rhs: [Double], accuracy: Double = 0.001) {
        zip(lhs, rhs).forEach {
            XCTAssertEqual($0,  $1, accuracy: accuracy)
        }
    }
    
}
