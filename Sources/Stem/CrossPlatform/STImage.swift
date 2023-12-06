//
//  STImage.swift
//
//
//  Created by linhey on 2023/11/6.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct STImage {
    
#if canImport(UIKit)
    public typealias Kind = UIImage
#elseif canImport(AppKit)
    public typealias Kind = NSImage
#endif
    
    public enum Value {
        case image(Kind)
    }
    
    public let value: Value
    
    public init?(data: Data) {
        guard let image = Kind(data: data) else {
            return nil
        }
        value = .image(image)
    }
    
    public init(_ value: Value) {
        self.value = value
    }
    
}
