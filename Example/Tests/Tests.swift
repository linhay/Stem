import XCTest
import Stem
import BLFoundation

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
        print(foo.value(forKey: "a")) 
//        let nib = UINib(nibName: "LaunchScreen")
//        print(nib.value(forKey: "storage"))

        //        UIStoryboard(name: "a", bundle: nil).st.viewController(with: TestViewController.self)
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }


    func testCode() {

        // let url = Bundle.main.url(forResource: "CALayer", withExtension: nil)!
        // let url = Bundle.main.url(forResource: "UILabel", withExtension: nil)!
        // let url = Bundle.main.url(forResource: "UIView", withExtension: nil)!
        // let url = Bundle.main.url(forResource: "NSMutableParagraphStyle", withExtension: nil)!
        let url = Bundle.main.url(forResource: "NSShadow", withExtension: nil)!
        let code = try! String(contentsOf: url)

        var new = code.components(separatedBy: "\n").map { (line) -> String in
            if line.contains("{ get }")
                || line.contains("init")
                || line.contains("class ")
                || line.contains(" -> ")
                || line.contains("extension ")
                || line.contains("enum ")
                || line.contains("case ")
            { return "" }

            let line = line.trimmingCharacters(in: .whitespaces).components(separatedBy: "//")
            let remark = line.last!
            let ivar = line.first!.trimmingCharacters(in: .whitespaces)

            if ivar.contains("func") {
                let words = ivar.components(separatedBy: "func ").last!
                return """
                \(remark.isEmpty ? "" : "//\(remark)")
                @discardableResult
                func \(words) -> StemSetChain<Base> {
                base.\(words)
                return self
                }
                """
            }

            if ivar.hasPrefix("open") {
                var words = ivar.replacingOccurrences(of: ":", with: "").components(separatedBy: " ")
                if words.count != 4 { return ivar }
                return """
                \(remark.isEmpty ? "" : "//\(remark)")
                @discardableResult
                func \(words[2])(_ value: \(words[3])) -> StemSetChain<Base> {
                base.\(words[2]) = value
                return self
                }
                """
            }
            return ivar
            }.joined(separator: "\n")

        let output = Bundle.main.url(forResource: "temp", withExtension: nil)!
       try! new.write(to: output, atomically: true, encoding: String.Encoding.utf8)
        print(output)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
