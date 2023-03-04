//
//  File.swift
//  
//
//  Created by linhey on 2023/3/4.
//

import Stem
import XCTest

class StringExtensionTests: XCTestCase {
    
    func testContainEmoji() {
        let string1 = "Hello, world!"
        XCTAssertFalse(string1.st.containEmoji)
        
        let string2 = "Hello, 😊!"
        XCTAssertTrue(string2.st.containEmoji)
    }
    
    func testEmojis() {
        let string1 = "Hello, world!"
        XCTAssertEqual(string1.st.emojis, [])
        
        let string2 = "Hello, 😊!"
        XCTAssertEqual(string2.st.emojis, ["😊"])
        
        let string3 = "👨‍👩‍👧‍👦"
        XCTAssertEqual(string3.st.emojis, ["👨‍👩‍👧‍👦"])
    }
    
    func testUnsafePointer() {
        // Given
        let string = "Test string"
        // When
        let unsafePointer = string.st.unsafePointer
        // Then
        XCTAssertEqual(String(cString: unsafePointer), string)
        unsafePointer.deallocate()
    }
    
    func testUnsafePointerEmptyString() {
        // Given
        let string = ""
        // When
        let unsafePointer = string.st.unsafePointer
        // Then
        XCTAssertEqual(String(cString: unsafePointer), string)
        unsafePointer.deallocate()
    }
    
    func testRandomStringLength() {
        // Given
        let length = 10
        
        // When
        let randomString = StemValue<String>.random(length: length)
        
        // Then
        XCTAssertEqual(randomString.count, length)
    }
    
    func testRandomStringLengthRange() {
        // Given
        let lengthRange = 5...10
        
        // When
        let randomString = StemValue<String>.random(length: lengthRange)
        
        // Then
        XCTAssertTrue(lengthRange.contains(randomString.count))
    }
    
    func testRandomStringCharacterSet() {
        // Given
        let characterSet = "abcd"
        let length = 10
        
        // When
        let randomString = StemValue<String>.random(characters: characterSet, length: length)
        
        // Then
        XCTAssertEqual(randomString.count, length)
        XCTAssertTrue(randomString.allSatisfy { characterSet.contains($0) })
    }
    
    func testRandomStringEmptyCharacterSet() {
        // Given
        let characterSet = ""
        let length = 10
        
        // When
        let randomString = StemValue<String>.random(characters: characterSet, length: length)
        
        // Then
        XCTAssertEqual(randomString.count, 0)
    }
    
    
}
