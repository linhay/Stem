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
    
    var metrics: [XCTMetric] { [XCTClockMetric(), XCTMemoryMetric(), XCTStorageMetric(), XCTCPUMetric()] }
    
    func testBaselineForReadImage() {
        let alpha = 125.0 / 255
        let value = 250.0 / 255
        measure(metrics: metrics) {
           _ = StemColor.array(from: Resource.jpg) { color in
                return color.alpha >= alpha && !(color.rgbSpace.unpack.min() > value)
            }
        }
    }
    
    func testBaseline() {
        var colors: [StemColor.RGBSpace.Unpack<UInt8>] = []
        measure(metrics: metrics) {
            colors = StemColor.RGBSpace.Unpack<UInt8>.array(fromRGBAs: StemColor.pixels(from: Resource.jpg), filter: { rgb, alpha in
                return alpha >= 125 && !(rgb.min() > 250)
            })
            .mmcq(maxCount: 5, quality: 1)
        }
        
        let hexs = colors.map({ StemColor(rgb: StemColor.RGBSpace($0), alpha: 1).hexString() })
        assert(hexs == ["#FC223A", "#FC7148", "#FCF9F5", "#FC6DA3", "#FCE7A0"])
    }
    
}
