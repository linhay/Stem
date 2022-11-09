//
//  File.swift
//  
//
//  Created by linhey on 2022/10/11.
//

import Foundation

@propertyWrapper
@dynamicMemberLookup
public final class STWeak<WrappedValue: AnyObject> {
    
    public weak var wrappedValue: WrappedValue?
    
    public init(_ value: WrappedValue?) {
        self.wrappedValue = value
    }
    
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<WrappedValue, T?>) -> T? {
        get { wrappedValue?[keyPath: keyPath] }
        set { wrappedValue?[keyPath: keyPath] = newValue }
    }
    
}

extension STWeak where WrappedValue: Equatable {
    
    static func == (lhs: STWeak, rhs: STWeak) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
    
}
