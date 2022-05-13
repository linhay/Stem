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
    
    fileprivate struct STRGBAPixel {
        let r: UInt8
        let g: UInt8
        let b: UInt8
        let a: UInt8
    }
    
    func test() throws {
        let bitmap = NSBitmapImageRep(data: data())!
        let colors = (0...bitmap.pixelsHigh).map { y in
            (0...bitmap.pixelsWide).compactMap { x in
                bitmap.colorAt(x: x, y: y)
            }
        }
        
        

    }
    
}
