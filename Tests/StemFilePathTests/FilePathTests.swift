//
//  File.swift
//  
//
//  Created by linhey on 2022/2/5.
//

import Foundation
import XCTest
import StemFilePath

final class FilePathTests: XCTestCase {

    func testInit() async throws {
        print(try Path("~/Desktop/Stem/Package.swift"))
        print(try Path("~/Desktop/./"))
        print(try Path("~/Desktop/.."))
        for try await _ in try Folder("~/Desktop").fileScan() {

        }
    }
    
}
