import XCTest
import Stem

class XYZTests: XCTestCase {

    func testGreen() {
        let color = StemColor(STWrapperColor.green).xyzSpace
        XCTAssertEqual(color.x.st.roundedDecimal(scale: 4), 0.3576, accuracy: 0.0001)
        XCTAssertEqual(color.y.st.roundedDecimal(scale: 4), 0.7152, accuracy: 0.0001)
        XCTAssertEqual(color.z.st.roundedDecimal(scale: 4), 0.1192, accuracy: 0.0001)
    }
    
    func testWhite() {
        let color = StemColor(rgb: .init(red: 1, green: 1, blue: 1)).xyzSpace
        XCTAssertEqual(color.x.st.roundedDecimal(scale: 4), 0.9505, accuracy: 0.0001)
        XCTAssertEqual(color.y.st.roundedDecimal(scale: 4), 1.0000, accuracy: 0.0001)
        XCTAssertEqual(color.z.st.roundedDecimal(scale: 4), 1.0888, accuracy: 0.0001)
    }
    
    func testArbitrary() {
        let color = StemColor(rgb: .init(red: 129.0 / 255.0, green: 200.0 / 255.0, blue: 10.0 / 255.0)).xyzSpace
        
        XCTAssertEqual(color.x.st.roundedDecimal(scale: 4), 0.2976, accuracy: 0.0001)
        XCTAssertEqual(color.y.st.roundedDecimal(scale: 4), 0.4600, accuracy: 0.0001)
        XCTAssertEqual(color.z.st.roundedDecimal(scale: 4), 0.0760, accuracy: 0.0001)
    }
    
}
