//
//  Tests.swift
//  
//
//  Created by linhey on 2023/3/4.
//

import XCTest
import Stem

final class Tests: XCTestCase {
    
    func testJsonObject() {
        let json = "{\"name\":\"John\", \"age\":30}"
        let data = json.data(using: .utf8)!
        do {
            let object = try data.st.jsonObject()
            XCTAssertNotNil(object)
            XCTAssertTrue(object is [String: Any])
            if let dict = object as? [String: Any] {
                XCTAssertEqual(dict["name"] as? String, "John")
                XCTAssertEqual(dict["age"] as? Int, 30)
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testBytes() {
        let string = "hello world"
        let data = string.data(using: .utf8)!
        let bytes = data.st.bytes
        XCTAssertEqual(bytes.count, data.count)
        for i in 0..<data.count {
            XCTAssertEqual(bytes[i], data[i])
        }
    }
    
    func testString() {
        let string = "hello world"
        let data = string.data(using: .utf8)!
        XCTAssertEqual(data.st.string(), string)
    }
    
    func testHexString() {
        let string = "hello world"
        let data = string.data(using: .utf8)!
        let hexString = data.st.hexString
        XCTAssertEqual(hexString, "68656c6c6f20776f726c64")
    }
    
    func testSha256() {
        let string = "hello world"
        let data = string.data(using: .utf8)!
        let sha256Data = data.st.sha256()
        let sha256String = sha256Data.map { String(format: "%02hhx", $0) }.joined()
        XCTAssertEqual(sha256String, "b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9")
    }
    
}
