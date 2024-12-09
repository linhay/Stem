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
import StemColor

class TestImageColor: XCTestCase {
    
    func testPng() throws {
        let colors = StemColor.array(from: Resource.png)
        assert(colors.isEmpty == false)
    }
    
    func testSVG() throws {
        let image = Resource.svg
        let colors = StemColor.array(from: image)
        assert(colors.count == 512 * 512)
    }
    
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
