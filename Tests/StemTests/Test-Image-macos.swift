//
//  File.swift
//  
//
//  Created by linhey on 2022/5/13.
//

import Foundation
import XCTest
import Stem

class TestImageColor: XCTestCase {
    
    var png: Data { NSDataAsset(name: "fixture.png", bundle: .module)!.data }
    var svg: NSImage { Bundle.module.image(forResource: "fixture.svg")! }

    func testPng() throws {
        let image = NSImage(data: png)!
        let colors = image.st.pixels()
        assert(colors.isEmpty == false)
    }
    
    func testSVG() throws {
        let image = svg
        let colors = image.st.pixels()
        assert(colors.isEmpty == false)
    }
    
    
    func testSize() throws {
        let size = CGSize(width: 1024, height: 1024)
       let data = svg
            .st.scale(size: size)?
            .st.data(using: .jpeg, properties: [.compressionFactor: 1])
        let file = try FilePath.File(path: "~/Downloads/test-size.jpg")
        _ = try? file.delete()
        try file.create(with: data)
        assert(file.isExist)
        guard let image = NSImage(data: try file.data()) else {
            assertionFailure()
            return
        }
        assert(image.size == size)
    }
    
}
