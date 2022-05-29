//
//  File.swift
//  
//
//  Created by linhey on 2022/5/13.
//

import Foundation
import XCTest
import Stem
import Darwin
import ReplayKit
import StemFilePath
import StemColor
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif

class TestImageColor: XCTestCase {
    
    var png: Data { NSDataAsset(name: "fixture.png", bundle: .module)!.data }
    
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
    var svg: NSImage { Bundle.module.image(forResource: "fixture.svg")! }
#endif
#if canImport(UIKit)
    var svg: UIImage { UIImage.init(named: "fixture.svg", in: .module, with: nil)! }
#endif
    
    func testPng() throws {
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
        let image = NSImage(data: png)!
#endif
#if canImport(UIKit)
        let image = UIImage(data: png)!
#endif
        
        let colors = StemColor.array(from: image, filter: StemColor.ImageFilterPixel.allCases)
        assert(colors.isEmpty == false)
    }
    
    func testSVG() throws {
        let image = svg
        let colors = StemColor.array(from: image)
        assert(colors.count == 512 * 512)
    }
    
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
    func testSize() throws {
        let size = CGSize(width: 1024, height: 1024)
        let data = svg
            .st.scale(size: size)?
            .st.data(using: .jpeg, properties: [.compressionFactor: 1])
        let file = try File("~/Downloads/test-size.jpg")
        _ = try? file.delete()
        try file.create(with: data)
        assert(file.isExist)
        guard let image = NSImage(data: try file.data()) else {
            assertionFailure()
            return
        }
        assert(image.size == size)
    }
    
    func testMacIcons() throws {
        try [16,32,64, 128,256,512,1024]
            .map({ CGSize(width: $0, height: $0) })
            .forEach { size in
                let data = svg
                    .st.scale(size: size)?
                    .st.data(using: .png, properties: [.compressionFactor: 1])
                let file = try File("~/Downloads/icons/icon_\(Int(size.width))_\(Int(size.height)).png")
                _ = try? file.delete()
                try file.create(with: data)
            }
    }
#endif
    
    func test() {
        let data = """
        <svg class="heart-loader" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 90 90" version="1.1">
        <g class="heart-loader__group">
        <path class="heart-loader__square" stroke-width="1" fill="none" d="M0,30 0,90 60,90 60,30z"/>
        <path class="heart-loader__circle m--left" stroke-width="1" fill="none" d="M60,60 a30,30 0 0,1 -60,0 a30,30 0 0,1 60,0"/>
        <path class="heart-loader__circle m--right" stroke-width="1" fill="none" d="M60,60 a30,30 0 0,1 -60,0 a30,30 0 0,1 60,0"/>
        <path class="heart-loader__heartPath" stroke-width="2" d="M60,30 a30,30 0 0,1 0,60 L0,90 0,30 a30,30 0 0,1 60,0" />
        </g>
        </svg>
        """.data(using: .utf8)!
        
        let svg = StemSVG(data)!
        assert(svg.size == .init(width: 90, height: 90))
        _ = svg.image()
    }
    
}
