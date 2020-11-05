//
//  File.swift
//  
//
//  Created by 林翰 on 2020/11/1.
//

import Foundation

public final class ClassBox<T> {

    public var value: T?

    public init() {}
    
    public init(_ value: T) {
        self.value = value
    }

}
