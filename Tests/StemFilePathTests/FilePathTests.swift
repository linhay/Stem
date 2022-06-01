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
        print(try STPath("~/Desktop/Stem/Package.swift"))
        print(try STPath("~/Desktop/./"))
        print(try STPath("~/Desktop/.."))
        for try await _ in try STFolder("~/Desktop").fileScan() {

        }
    }
    
}
