//
//  File.swift
//  
//
//  Created by linhey on 2022/5/13.
//

#if canImport(AppKit)
import Foundation
import AppKit

public extension Stem where Base: NSImage {
    
    /// 获取某全部点位像素的颜色
    /// - Parameter points: 点位
    /// - Returns: 颜色集合
    func pixels() -> [[StemColor]] {
        let bmp = base.representations[0] as! NSBitmapImageRep
        var data = bmp.bitmapData!
        var pixels: [[StemColor]] = []
        
        for _ in 0..<bmp.pixelsHigh {
            var rows = [StemColor]()
           for _ in 0..<bmp.pixelsWide {
               let r = data.pointee
               data = data.advanced(by: 1)
               let g = data.pointee
               data = data.advanced(by: 1)
               let b = data.pointee
               data = data.advanced(by: 1)
               let a = data.pointee
               data = data.advanced(by: 1)
               rows.append(.init(rgb: .init([r, g, b].map({ Double($0) / 255 })), alpha: Double(a) / 255))
           }
            pixels.append(rows)
        }
        return pixels
    }
    
}
#endif
