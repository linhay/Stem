import XCTest
import Stem

class StemColorRGBTests: XCTestCase {
    
    private let blackHex = "#000000"
    private let whiteHex = "#FFFFFF"
    private let redHex = "#FF0000"
    private let darkGreen = "#32A852"

    // Init
    
    func testInitBlack() {
        let color = StemColor(hex: blackHex)
        let space = color.rgbSpace
        XCTAssertEqual(space.red, 0)
        XCTAssertEqual(space.green, 0)
        XCTAssertEqual(space.blue, 0)
        XCTAssertEqual(color.alpha, 1)
    }
    
    func testInitWhite() {
        let color = StemColor(hex: whiteHex)
        let space = color.rgbSpace
        XCTAssertEqual(space.red, 1)
        XCTAssertEqual(space.green, 1)
        XCTAssertEqual(space.blue, 1)
        XCTAssertEqual(color.alpha, 1)
    }
    
    func testInitRed() {
        let color = StemColor(hex: redHex)
        let space = color.rgbSpace
        XCTAssertEqual(space.red, 255.0 / 255.0)
        XCTAssertEqual(space.green, 0.0 / 255.0)
        XCTAssertEqual(space.blue, 0.0 / 255.0)
        XCTAssertEqual(color.alpha, 1)
    }
    
    func testInitDarkGreen() {
        let color = StemColor(hex: darkGreen)
        let space = color.rgbSpace
        XCTAssertEqual(space.red, 50.0 / 255.0)
        XCTAssertEqual(space.green, 168.0 / 255.0)
        XCTAssertEqual(space.blue, 82.0 / 255.0)
        XCTAssertEqual(color.alpha, 1)
    }
    
    // hex
    
    func testHexBlack() {
        let color = StemColor(STWrapperColor.black)
        XCTAssertEqual(color.hexString(), blackHex)
    }
    
    func testHexWhite() {
        let color = StemColor(STWrapperColor.white)
        XCTAssertEqual(color.hexString(), whiteHex)
    }
    
    func testHexRed() {
        let color = StemColor(STWrapperColor.red)
        XCTAssertEqual(color.hexString(), redHex)
    }
    
    func testHexDarkGreen() {
        let color = StemColor(rgb: .init(red: 50.0 / 255.0, green: 168.0 / 255.0, blue: 82.0 / 255.0))
        XCTAssertEqual(color.hexString(), darkGreen)
    }
    
}
