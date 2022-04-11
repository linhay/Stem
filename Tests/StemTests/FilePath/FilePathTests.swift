//
//  File.swift
//  
//
//  Created by linhey on 2022/2/5.
//

import Foundation
import XCTest
@testable
import Stem

final class FilePathTests: XCTestCase {

    func testInit() async throws {
        print(try FilePath(path: "~/Desktop/Stem/Package.swift"))
        print(try FilePath(path: "~/Desktop/./"))
        print(try FilePath(path: "~/Desktop/.."))
        
        for try await item in try FilePath.Folder(path: "~/Desktop").fileScan() {
            print(item.path)
        }
    }

}
