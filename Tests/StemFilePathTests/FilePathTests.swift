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
    
    func test2() async throws {
        let folder = STFolder("/Users/linhey/Desktop/SectionKit")
        let files = try folder.allSubFilePaths([.skipsHiddenFiles]).filter({
            $0.attributes.nameComponents.extension?.lowercased() == "swift" &&
            $0.attributes.nameComponents.name.uppercased() != "___FILEBASENAME___"
        }).compactMap(\.asFile)
        
        for file in files {
            guard let data = try? file.data(), var text = String(data: data, encoding: .utf8) else {
                continue
            }
            if text.contains("import UIKit") {
                text = text.replacingOccurrences(of: "import UIKit",
                                                 with: "#if canImport(UIKit)\nimport UIKit")
                text = text + "\n#endif"
                try file.overlay(with: text.data(using: .utf8))
            }
        }
    }
    
    func test() async throws {
        var folder = STFolder("~/Desktop")
        try folder.watcher().publisher.sink { _ in
            print("===>")
        }.store(in: &cancellables)
        let file1 = folder.file("test1.txt")
        let file2 = folder.file("test2.txt")
        try? file1.delete()
        try? file2.delete()
        try file1.create()
        try file2.create()
    }
    
    func testInit() async throws {
        let folder = STFolder("~/Desktop")
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
