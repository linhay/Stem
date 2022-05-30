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

    func test() {
        let colors = StemColor.array(from: Resource.jpg, filter: [.white])
            .mmcq(maxCount: 5, quality: 20)
        print(colors.map({ $0.hexString() }))
    }

}
