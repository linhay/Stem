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
import Combine

final class FilePathTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test() async throws {
        var folder = try STFolder("~/Desktop")
        try folder.watcher().publisher.sink { _ in
            print("===>")
        }.store(in: &cancellables)
        let file1 = folder.file(name: "test1.txt")
        let file2 = folder.file(name: "test2.txt")
        try? file1.delete()
        try? file2.delete()
        try file1.create()
        try file2.create()
    }
    
    func testInit() async throws {
        let folder = try STFolder("~/Desktop")
        let paths = try folder.subFilePaths()
        var old = [String]()
        var new = [String]()
        try Gcd.duration { finished in
            print("==== old ====")
            old = paths
                .map({ item in
                    return FileManager.default.displayName(atPath: item.path)
                })
            
            print("old \(paths.count) => ", try finished())
            print("==== old end ====")
        }
        try Gcd.duration { finished in
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
