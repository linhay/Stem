import XCTest
import Stem

@objc(objc_class_base) @objcMembers
class objc_class_base: NSObject {

    func base_function() { }
}

@objc(objc_class_a) @objcMembers
class objc_class_a: objc_class_base {

    func function() -> Void { }
    func function_return_nsobject() -> NSObject { return NSObject() }
    func function_return_block() -> ([String: Any]) -> Void { return { _ in } }

    func function_return_int() -> Int { return 1 }
    func function_return_string() -> String { return "str: 2.3.4" }
    func function_return_double() -> Double { return 6.666666666666666666666666666666666 }
    func function_return_float() -> Float { return 6.666666666666666666666666666666666 }
    func function_return_bool() -> Bool { return true }

    func function_return_cgSize() -> CGSize { return .zero }
    func function_return_cgRect() -> CGRect { return .zero }
    func function_return_cgFloat() -> CGFloat { return 0.0 }

    func function_return_some_nsobject() -> NSObject? { return NSObject() }
    /// Method cannot be marked @objc because its result type cannot be represented in Objective-C
    // @objc func function_return_some_int() -> Int? { return 1 }

    func function_args_dict_block_return_void(_ info: [String: Any], success: ([String: Any]) -> Void) -> Void { }
    func function_args_block0_return_void(_ success: ([String: Any]) -> Void) -> Void { }
    func function_args_block1_return_void(_ success: () -> Void) -> Void { }
    func function_args_block0_block0_block0_return_void(_ success: () -> Void, _ fail: () -> Void,  _ comp: () -> Void) -> Void { }
    func function_args_dict_return_void(_ info: [String: Any]) -> Void { }
    func function_args_return_void() -> Void { }

}

class Tests: XCTestCase {

    func test_objc() {

        guard let type = OBJC.Class(name: "objc_class_a")
            , let max_name_count = type.methods.max(by: { $1.selector.description.count > $0.selector.description.count })?.selector.description.count
            else {
                return
        }
        let method = type.methods.sorted(by: { $1.selector.description > $0.selector.description }).forEach({ (item) in
            let spaces = Array(repeating: " ", count: max_name_count - item.selector.description.count).joined()
            print(item.selector, "\(spaces) : " , item.typeEncoding!)
        })
//        let imp = method?.imp
//
//
//        let function = unsafeBitCast(imp!, to: (@convention(c) (AnyObject, Selector, () -> Void) -> NSObject).self)
//        let value = function(type!.new()!.value, method!.selector, {
//            print("convention Closure")
//        })
//        print(value)
    }

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
    
    func test_event() {
        let item = Event<Int>(key: "2")

        _ = item.subscribe(using: { (value) in
            print(value)
        })

        item.value = 1
        item.value = 2
        item.value = 3
        item.value = 4
    }



}
