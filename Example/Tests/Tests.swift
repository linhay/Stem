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
    
    func testExample() {
        print(RunTime.print.ivars(from: Foo.self))
        let foo = Foo()
        print(foo.value(forKey: "a")!)
        XCTAssert(true, "Pass")
    }

    func testUIApplication() {
        let a = UISearchBar().st.searchField
        print(a)
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
