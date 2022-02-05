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

    func testInit() throws {
        print(try FilePath(path: "~/Desktop/Stem/Package.swift"))
        print(try FilePath(path: "~/Desktop/./"))
        print(try FilePath(path: "~/Desktop/.."))
    }

}
