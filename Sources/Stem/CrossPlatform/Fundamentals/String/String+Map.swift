//
//  File.swift
//  
//
//  Created by linhey on 2022/5/15.
//

import Foundation

public extension StemValue where Base == String {
    // 获取指向字符串C字符串表示形式的UnsafeMutablePointer
    var unsafePointer: UnsafeMutablePointer<Int8> {
        let count = base.utf8.count + 1
        let result = UnsafeMutablePointer<Int8>.allocate(capacity: count)
        base.withCString { (baseAddress) in
            result.initialize(from: baseAddress, count: count)
        }
        return result
    }
    
}
