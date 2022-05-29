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
    
}
#endif
