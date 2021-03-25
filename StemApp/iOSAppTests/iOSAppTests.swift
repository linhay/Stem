//
//  iOSAppTests.swift
//  iOSAppTests
//
//  Created by 林翰 on 2021/3/25.
//

import XCTest
import Stem

class iOSAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let filePath = try FilePath(path: "./mmap5.json", inSanbox: .cache, type: .file)
        try? filePath.create()
        print(filePath.path)
        let result = try filePath.mmap(prot: [.write, .read],
                                       type: .file,
                                       shareType: .share,
                                       size: 4 * 1024)
        result.write(data: "1234567890".data(using: .utf8)!)
        result.write(data: "abcdefg".data(using: .utf8)!, offset: 8)
        print(String(data: result.data(), encoding: .utf8)!)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
