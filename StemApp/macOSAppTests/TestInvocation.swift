//
//  TestInvocation.swift
//  macOSTests
//
//  Created by 林翰 on 2021/1/22.
//  Copyright © 2021 linhey.ax. All rights reserved.
//

import XCTest
import Stem

fileprivate class TestInvocationObject: NSObject {
    
    @objc func sel_return_void() { print(Self.self, "--", #function) }
    
    @objc func sel_return_bool_true() -> Bool  { print(Self.self, "--", #function); return true }
    @objc func sel_return_bool_false() -> Bool { print(Self.self, "--", #function); return false }
    
    @objc func sel_return_int() -> Int         { print(Self.self, "--", #function); return 3 }
    @objc func sel_return_double() -> Double   { print(Self.self, "--", #function); return Double.pi }
    @objc func sel_return_float() -> Float     { print(Self.self, "--", #function); return Float.pi }
    @objc func sel_return_cgfloat() -> CGFloat { print(Self.self, "--", #function); return CGFloat.pi }

}

class TestInvocation: XCTestCase {

    func testVoid() throws {
        let object = TestInvocationObject()
        
        do {
            let invocation = try Invocation(target: object, selector: #selector(TestInvocationObject.sel_return_void))
            invocation.invoke()
        }
        do {
            let invocation = try Invocation(target: object, selector: #selector(TestInvocationObject.sel_return_bool_true))
            invocation.invoke()
            var result: Bool?
            invocation.getReturnValue(result: &result)
            XCTAssert(result == true)
        }
        do {
            let invocation = try Invocation(target: object, selector: #selector(TestInvocationObject.sel_return_bool_false))
            invocation.invoke()
            var result: Bool?
            invocation.getReturnValue(result: &result)
            XCTAssert(result == false)
        }
        
        do {
            let invocation = try Invocation(target: object, selector: #selector(TestInvocationObject.sel_return_int))
            invocation.invoke()
            var result: Int?
            invocation.getReturnValue(result: &result)
            XCTAssert(result == 3)
        }
        do {
            let invocation = try Invocation(target: object, selector: #selector(TestInvocationObject.sel_return_double))
            invocation.invoke()
            var result: Double?
            invocation.getReturnValue(result: &result)
            XCTAssert(result == .pi)
        }
        do {
            let invocation = try Invocation(target: object, selector: #selector(TestInvocationObject.sel_return_float))
            invocation.invoke()
            var result: Float?
            invocation.getReturnValue(result: &result)
            XCTAssert(result == .pi)
        }
        do {
            let invocation = try Invocation(target: object, selector: #selector(TestInvocationObject.sel_return_cgfloat))
            invocation.invoke()
            var result: CGFloat?
            invocation.getReturnValue(result: &result)
            XCTAssert(result == .pi)
        }
        
        
    }

}
