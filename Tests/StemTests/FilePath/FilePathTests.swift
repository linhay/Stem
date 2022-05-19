//
//  File.swift
//  
//
//  Created by linhey on 2022/2/5.
//

import Foundation
import XCTest
import Stem
import FilePath

final class FilePathTests: XCTestCase {

    func testInit() async throws {
        print(try FilePath("~/Desktop/Stem/Package.swift"))
        print(try FilePath("~/Desktop/./"))
        print(try FilePath("~/Desktop/.."))
        
        for try await _ in try Folder("~/Desktop").fileScan() {

        }
    }
    
}
