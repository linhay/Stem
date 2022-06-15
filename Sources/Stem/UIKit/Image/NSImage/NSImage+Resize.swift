//
//  File.swift
//  
//
//  Created by linhey on 2022/5/13.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import Foundation
import AppKit

public extension Stem where Base: NSImage {
    
    func scale(size: CGSize, opaque: Bool = false) -> NSImage? {
        guard base.isValid,
              let representation = base.bestRepresentation(for: .init(origin: .zero, size: size), context: nil, hints: nil) else {
            return nil
        }
        return NSImage(size: size, flipped: false) { rect in
            representation.draw(in: rect)
        }
    }
    
    /// 缩放至指定高度
    ///
    /// - Parameters:
    ///   - toWidth: 高度
    ///   - opaque: 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储
    /// - Returns: 新的图片
    func scale(toHeight: CGFloat, opaque: Bool = false) -> NSImage? {
        let newWidth = base.size.width / base.size.height * toHeight
        return scale(size: CGSize(width: newWidth, height: toHeight), opaque: opaque)
    }
    
    /// 缩放至指定宽度
    ///
    /// - Parameters:
    ///   - toWidth: 宽度
    ///   - opaque: 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储
    /// - Returns: 新的图片
    func scale(toWidth: CGFloat, opaque: Bool = false) -> NSImage? {
        let newHeight = base.size.height / base.size.width * toWidth
        return scale(size: CGSize(width: toWidth, height: newHeight), opaque: opaque)
    }
    
}
#endif
