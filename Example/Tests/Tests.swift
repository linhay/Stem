import XCTest
import BLFoundation
import Stem

class Foo: NSObject {
    var a: String = "a"
}



class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

     func getIntFromString(_ str: String) -> String {
        let scanner = Scanner(string: str)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        var number :Int = 0
        scanner.scanInt(&number)
        return String(number)
    }

    func test_color() {
        assert(UIColor(0x2D6395).st.rgb == (red: 45.0, green: 99.0, blue: 149.0, alpha: 1.0), "UIColor get RGBA value")
        print(UIColor(r: 45.0, g: 99.0, b: 149.0).st.hex)
        assert(UIColor(r: 45.0, g: 99.0, b: 149.0).st.hex == 0x2D6395, "UIColor get Hex value")
    }

    func testExample() {
        print(RunTime.print.ivars(from: Foo.self))
        let foo = Foo()
        print(foo.value(forKey: "a")!)
        XCTAssert(true, "Pass")
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
