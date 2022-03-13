//
//  File.swift
//  
//
//  Created by linhey on 2022/3/13.
//

import Foundation

@dynamicMemberLookup
public protocol WrapperReferenceProtocol {
    
    associatedtype ReferenceValue
    var referenceValue: ReferenceValue { get }

}

public extension WrapperReferenceProtocol {
    
    subscript<T>(dynamicMember keyPath: KeyPath<ReferenceValue, T>) -> T {
        referenceValue[keyPath: keyPath]
    }
    
}

@dynamicMemberLookup
public protocol WrapperWritableReferenceProtocol: WrapperReferenceProtocol {
    
    associatedtype ReferenceValue
    var referenceValue: ReferenceValue { get set }

}

public extension WrapperWritableReferenceProtocol {
    
    subscript<T>(dynamicMember keyPath: WritableKeyPath<ReferenceValue, T>) -> T {
        get { referenceValue[keyPath: keyPath] }
        set { referenceValue[keyPath: keyPath] = newValue }
    }
    
}
