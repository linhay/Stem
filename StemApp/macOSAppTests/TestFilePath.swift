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

    func testURL() {
        let str = "/Users/linhey/Desktop/linhey/../linhey/pod_template_stem/Sources/Custom/Foundation/Delegate.swift"
        let url = URL(fileURLWithPath: str)
        print(url.description)
        print(url.standardized)
        print(url.hasDirectoryPath)
    }

    func testExample() throws {
        let filePath = try FilePath(path: "./mmap5.json", type: .file)
        print(filePath.path)
        let result = try filePath.mmap(prot: [.write, .read],
                                       type: .file,
                                       shareType: .share,
                                       size: 4 * 1024)
        result.write(data: "1234567890".data(using: .utf8)!)
        print(String(data: result.data(), encoding: .utf8)!)
    }

}
