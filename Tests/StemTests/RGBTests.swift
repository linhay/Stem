import XCTest
import Stem

class RGBTests: XCTestCase {
    
    func testRed() {
        let color = StemColor(UIColor.red).rgbSpace
        XCTAssertEqual(color.red, 1.0)
        XCTAssertEqual(color.green, 0.0)
        XCTAssertEqual(color.blue, 0.0)
    }
    
    func testGreen() {
        let color = StemColor(UIColor.green).rgbSpace
        XCTAssertEqual(color.red, 0.0)
        XCTAssertEqual(color.green, 1.0)
        XCTAssertEqual(color.blue, 0.0)
    }

    func testBlue() {
        let color = StemColor(UIColor.blue).rgbSpace
        XCTAssertEqual(color.red, 0.0)
        XCTAssertEqual(color.green, 0.0)
        XCTAssertEqual(color.blue, 1.0)
    }
    
    func testWhite() {
        let color = StemColor(UIColor.white).rgbSpace
        XCTAssertEqual(color.red, 1.0)
        XCTAssertEqual(color.green, 1.0)
        XCTAssertEqual(color.blue, 1.0)
    }
    
    func testBlack() {
        let color = StemColor(UIColor.black).rgbSpace
        XCTAssertEqual(color.red, 0.0)
        XCTAssertEqual(color.green, 0.0)
        XCTAssertEqual(color.blue, 0.0)
    }
    
    func testGray() {
        let color = StemColor(UIColor.gray).rgbSpace
        XCTAssertEqual(color.red, 0.5)
        XCTAssertEqual(color.green, 0.5)
        XCTAssertEqual(color.blue, 0.5)
    }
    
    func testPurple() {
        let color = StemColor(UIColor.purple).rgbSpace
        XCTAssertEqual(color.red, 0.5)
        XCTAssertEqual(color.green, 0.0)
        XCTAssertEqual(color.blue, 0.5)
    }

}
