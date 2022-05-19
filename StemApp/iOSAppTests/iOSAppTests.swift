//
//  iOSAppTests.swift
//  iOSAppTests
//
//  Created by 林翰 on 2021/3/25.
//

import XCTest
import Stem
import AVKit

class iOSAppTests: XCTestCase {

    func testMMAP() throws {
        let filePath = try Folder(sanbox: .cache).file(name: "mmap5.json")
        try? filePath.delete()
        try? filePath.create()
        
        let system = filePath.system
        let result = try system.mmap(size: 1)
        try result.write(data: "1234567".data(using: .utf8)!)
        try result.append(data: "abcdefg".data(using: .utf8)!)
        print(String(data: result.read(), encoding: .utf8)!)
    }
    
    func testUINavigationBarAppearance() {
        RunTime.print.properties(from: UINavigationBarAppearance.self)
        RunTime.print.methods(from: UINavigationBarAppearance.self)
        RunTime.print.ivars(from: UINavigationBarAppearance.self)
        RunTime.print.protocols(from: UINavigationBarAppearance.self)
    }
    
    func testIconFont() throws {
        guard let data = NSDataAsset(name: "iconfont", bundle: .main)?.data else {
            return
        }
        try StemFont.register(data: data)
        print(StemFont.availableFontFamilies)
    }
    
    func testIconFontURL() throws {
        guard let url = Bundle.main.url(forResource: "iconfont", withExtension: "ttf") else {
            return
        }
        try StemFont.register(from: url)
        print(StemFont.availableFontFamilies)
    }
    
}
