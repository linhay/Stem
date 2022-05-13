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
    
    func data() -> Data {
        return NSDataAsset(name: "fixture.png", bundle: .module)!.data
    }
    
    func test() throws {
        let image = NSImage(data: data())!
        let colors = image.st.pixels()
            .flatMap({ $0 })
            .kmeansClusterAnalysis(count: 9, difference: .cie76)
        print(colors.count)
    }
    
}
