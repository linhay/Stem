import XCTest
import BLFoundation
import Stem

class Tests: XCTestCase {
    
    func test_color() {
        UIColor.st.isDisplayP3Enabled = false
        assert(UIColor(0x2D6395).st.rgb == (red: 45.0, green: 99.0, blue: 149.0, alpha: 1.0), "UIColor get RGBA value")
        assert(UIColor(r: 45.0, g: 99.0, b: 149.0).st.hexString == "#2D6395", "UIColor get Hex String")
        assert(UIColor.st.random != UIColor.st.random, "UIColor.st.random")
    }

    func testUIApplication() {
        RunTime.print.ivars(from: UISearchBar.self).forEach({ print($0) })
        RunTime.properties(from: UISearchBar.self).forEach({
            let propertyAttributes = String(cString: property_getAttributes($0)!)
            let splitPropertyAttributes = propertyAttributes.components(separatedBy: "\"")
            var className = ""
            if splitPropertyAttributes.count >= 2 {
                className = splitPropertyAttributes[1]
            }
            print(String(cString: property_getName($0))," : ", className)
        })
    }

}
