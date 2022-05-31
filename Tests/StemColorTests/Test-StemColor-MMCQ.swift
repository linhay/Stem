//
//  File.swift
//  
//
//  Created by linhey on 2022/5/30.
//

import Foundation
import XCTest
import StemColor

class StemColorMMCQTests: XCTestCase {
    
    func test1() {
        let alpha = 125.0 / 255
        let value = 250.0 / 255
        measure {
            let colors = StemColor.array(from: Resource.jpg) { color in
                return color.alpha >= alpha && !(color.rgbSpace.unpack.min() > value)
            }.mmcq(maxCount: 5, quality: 20)
            assert(colors.map({ $0.hexString()}) == ["#FCD4DA", "#FC164B", "#FC6C8C", "#FC7B2C", "#FCBF83"])
        }
    }
    
    func test2() {
        var colors: [StemColor] = []
        let alpha = 125.0 / 255
        let value = 250.0 / 255
        measure {
            colors = StemColor.array(from: Resource.jpg){ color in
                return color.alpha >= alpha && !(color.rgbSpace.unpack.min() > value)
            }.mmcq(maxCount: 5, quality: 1)
        }
        assert(colors.map({ $0.hexString()}) == ["#FCD4DA", "#FC164C", "#FC6C8B", "#FC7A2C", "#FCBF83"])
    }
    
}
