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
    
    func testBaselines() {
        var colors: [StemColor] = []
        let alpha = 125.0 / 255
        let value = 250.0 / 255
        measure(metrics: [XCTClockMetric(), XCTMemoryMetric(), XCTCPUMetric()]) {
            colors = StemColor.array(from: Resource.jpg){ color in
                return color.alpha >= alpha && !(color.rgbSpace.unpack.min() > value)
            }.mmcq(maxCount: 5, quality: 1)
        }
        assert(colors.map({ $0.hexString()}) == ["#FCD4DA", "#FC164C", "#FC6C8B", "#FC7A2C", "#FCBF83"])
    }
    
}
