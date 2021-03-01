//
//  TestFilePath.swift
//  macOSTests
//
//  Created by 林翰 on 2020/8/27.
//  Copyright © 2020 linhey.ax. All rights reserved.
//

import XCTest
import Stem

class TestFilePath: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURL() {
        let str = "/Users/linhey/Desktop/linhey/../linhey/pod_template_stem/Sources/Custom/Foundation/Delegate.swift"
        let url = URL(fileURLWithPath: str)
        print(url.description)
        print(url.standardized)
        print(url.hasDirectoryPath)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
