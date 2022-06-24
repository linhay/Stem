//
//  File.swift
//  
//
//  Created by linhey on 2022/2/5.
//

import Foundation
import XCTest
import StemFilePath
import Stem

final class FilePathTests: XCTestCase {
    
    func testInit() async throws {
        let folder = try STFolder("~/Desktop")
        let paths = try folder.subFilePaths()
        var old = [String]()
        var new = [String]()
        try await Gcd.duration { finished in
            print("==== old ====")
            old = paths
                .map({ item in
                    return FileManager.default.displayName(atPath: item.path)
                })
            
            print("old \(paths.count) => ", try finished())
            print("==== old end ====")
        }
        try await Gcd.duration { finished in
            print("==== new ====")
            new = paths.map(\.attributes.name)
            print("new \(paths.count) => ", try finished())
            print("==== new end ====")
        }
        
        zip(old, new)
            .filter({ $0 != $1 })
            .prefix(20)
            .forEach({ print("\($0) -- \($1)") })
        
        assert(old == new)
    }
    
}
