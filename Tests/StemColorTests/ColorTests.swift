//
//  File.swift
//  
//
//  Created by linhey on 2023/3/4.
//

import XCTest
import StemColor


class ColorTests: XCTestCase {
    
    func test1() {
        //1.测试初始化
        let pixel = StemColorPixel(red: 255, green: 0, blue: 0, alpha: 255)
        XCTAssertEqual(pixel.red, 255)
        XCTAssertEqual(pixel.green, 0)
        XCTAssertEqual(pixel.blue, 0)
        XCTAssertEqual(pixel.alpha, 255)
        
    }
    
    func test2() {
        
        //2.测试数组转换
        
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        pointer.initialize(to: 255)
        let pixels = StemColorPixel.array(from: pointer, width: 1, height: 1)
        XCTAssertEqual(pixels.count, 1)
        XCTAssertEqual(pixels[0].red, 255)
        XCTAssertEqual(pixels[0].green, 255)
        XCTAssertEqual(pixels[0].blue, 255)
        XCTAssertEqual(pixels[0].alpha, 255)
        
    }
    
    func testBytes() {
        // Test case 1: Empty input
        let emptyPointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: 0)
        let emptyBytes = StemColorPixel.bytes(from: emptyPointer, width: 0, height: 0)
        XCTAssert(emptyBytes.isEmpty)
        
        // Test case 2: Non-empty input
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        pointer.initialize(from: [255, 0, 0, 255], count: 4)
        let bytes = StemColorPixel.bytes(from: pointer, width: 1, height: 1)
        XCTAssertEqual(bytes, [255, 0, 0, 255])
        
        // Test case 3: Larger input
        let largerPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 12)
        largerPointer.initialize(from: [255, 0, 0, 255, 0, 255, 0, 255, 255, 255, 255, 0], count: 12)
        let largerBytes = StemColorPixel.bytes(from: largerPointer, width: 3, height: 1)
        XCTAssertEqual(largerBytes, [255, 0, 0, 255, 0, 255, 0, 255, 255, 255, 255, 0])
        
        // Test case 4: Zero width and height
        let zeroPointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: 0)
        let zeroBytes = StemColorPixel.bytes(from: zeroPointer, width: 0, height: 0)
        XCTAssert(zeroBytes.isEmpty)
    }
    
    func test4() {
        //4.测试SIMD4数组转换
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        pointer.initialize(to: 255)
        let simd4s = StemColorPixel.simd4s(from: pointer, width: 1, height: 1)
        XCTAssertEqual(simd4s.count, 1)
        XCTAssertEqual(simd4s[0].x, 255)
        XCTAssertEqual(simd4s[0].y, 255)
        XCTAssertEqual(simd4s[0].z, 255)
        XCTAssertEqual(simd4s[0].w, 255)
    }
    
    func testArrayFromRGBAs() {
        let pixels: [UInt8] = [255, 0, 0, 255,
                               0, 255, 0, 255,
                               0, 0, 255, 255]
        let colors = StemColor.array(fromRGBAs: pixels)
        XCTAssertEqual(colors.count, 3)
        XCTAssertEqual(colors[0].rgbSpace.red, 1.0)
        XCTAssertEqual(colors[0].rgbSpace.green, 0.0)
        XCTAssertEqual(colors[0].rgbSpace.blue, 0.0)
        XCTAssertEqual(colors[0].alpha, 1.0)
        XCTAssertEqual(colors[1].rgbSpace.red, 1.0)
        XCTAssertEqual(colors[1].rgbSpace.green, 0.0)
        XCTAssertEqual(colors[1].rgbSpace.blue, 1.0)
        XCTAssertEqual(colors[1].alpha, 0.0)
    }
    
}
