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
    
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<WrappedValue, T?>) -> T? {
        get { wrappedValue?[keyPath: keyPath] }
        set { wrappedValue?[keyPath: keyPath] = newValue }
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<WrappedValue, T?>) -> T? {
         wrappedValue?[keyPath: keyPath]
    }
    
    
}

extension STWeak: Equatable where WrappedValue: Equatable {
    
    public static func == (lhs: STWeak, rhs: STWeak) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
    
}

extension STWeak: Hashable where WrappedValue: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        guard let wrappedValue = wrappedValue else {
            return
        }
        hasher.combine(wrappedValue)
    }

}
