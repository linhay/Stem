//
//  Double.swift
//  macOSTests
//
//  Created by 林翰 on 2020/12/8.
//  Copyright © 2020 linhey.ax. All rights reserved.
//

import Foundation

extension Double {
    
    func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrEven, precision: Int) -> Double {
        return (self * Double(precision)).rounded(rule) / Double(precision)
    }
    
}
