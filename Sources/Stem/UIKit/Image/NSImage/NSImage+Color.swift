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
    
    private var cgImage: CGImage? {
        guard let imageData = base.tiffRepresentation else { return nil }
        guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
    }

    /// 获取全部像素的颜色
    /// - Parameter points: 点位
    /// - Returns: 颜色集合
    func colorCountedSet() -> [StemColor: Int] {
        return cgImage?.st.colorCountedSet() ?? [:]
    }

    /// 获取某几个点位像素的颜色
    /// - Parameter points: 点位
    /// - Returns: 颜色集合
    func pixels(at points: [(x: Int, y: Int)]) -> [StemColor] {
        return cgImage?.st.pixels(at: points) ?? []
    }
    
    /// 获取某全部点位像素的颜色
    /// - Parameter points: 点位
    /// - Returns: 颜色集合
    func pixels() -> [[StemColor]] {
        return cgImage?.st.pixels() ?? []
    }
    
}
#endif
