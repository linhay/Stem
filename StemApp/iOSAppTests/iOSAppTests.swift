//
//  iOSAppTests.swift
//  iOSAppTests
//
//  Created by 林翰 on 2021/3/25.
//

import XCTest
import Stem
import AVKit

class iOSAppTests: XCTestCase {

    func testMMAP() throws {
        let filePath = try FilePath.Folder(sanbox: .cache).file(name: "mmap5.json")
        try? filePath.delete()
        try? filePath.create()
        
        let system = filePath.system
        let result = try system.mmap(size: 1)
        try result.write(data: "1234567".data(using: .utf8)!)
        try result.append(data: "abcdefg".data(using: .utf8)!)
        print(String(data: result.read(), encoding: .utf8)!)
    }
    
}
