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
        guard let data = base.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: data) else {
            return []
        }
        
        return (0...bitmap.pixelsHigh).lazy.map { y in
            (0...bitmap.pixelsWide)
                .lazy
                .compactMap { x in
                    bitmap.colorAt(x: x, y: y)
                }
                .map { color in
                    StemColor.init(color)
                }
        }
    }
    
}
#endif
