import XCTest
import Stone
import Stem

class Tests: XCTestCase {

    func test_rect() {
        let rect = CGRect(x: 100, y: 100, width: 100, height: 100)
        assert(rect.st.changed(x: 50) == CGRect(x: 50, y: 100, width: 100, height: 100))
        assert(rect.st.changed(y: 50) == CGRect(x: 100, y: 50, width: 100, height: 100))
        assert(rect.st.changed(width: 50)  == CGRect(x: 100, y: 100, width: 50, height: 100))
        assert(rect.st.changed(height: 50) == CGRect(x: 100, y: 100, width: 100, height: 50))
    }

    func test_point() {
        assert(CGPoint(x: 0, y: 0).st.distance(to: CGPoint(x: 30, y: 40)) == 50)
    }
    
    func test_color() {
        UIColor.st.isDisplayP3Enabled = false
        assert(UIColor(0x2D6395).st.rgb == (red: 45.0, green: 99.0, blue: 149.0, alpha: 1.0), "UIColor get RGBA value")
        assert(UIColor(r: 45.0, g: 99.0, b: 149.0).st.hexString == "#2D6395", "UIColor get Hex String")
        assert(UIColor.st.random != UIColor.st.random, "UIColor.st.random")
    }


    func test_STGestureRecognizer() {
    }
    
    func test_string() {

    }

    func testUIApplication() {
        RunTime.print.ivars(from: UISearchBar.self)
        RunTime.print.properties(from: UISearchBar.self)
    }

}
