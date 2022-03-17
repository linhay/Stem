//
//  File.swift
//  
//
//  Created by linhey on 2022/3/17.
//

import Foundation

public struct FilePathPermission: OptionSet {
    
    public static let exists     = FilePathPermission(rawValue: 1 << 0)
    public static let readable   = FilePathPermission(rawValue: 1 << 1)
    public static let writable   = FilePathPermission(rawValue: 1 << 2)
    public static let executable = FilePathPermission(rawValue: 1 << 3)
    public static let deletable  = FilePathPermission(rawValue: 1 << 4)
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public init(path: String) {
        let manager = FileManager.default
        var list = [FilePathPermission]()
        
        guard manager.isExecutableFile(atPath: path) else {
            self.init(list)
            return
        }
        
        list.append(.exists)
        
        if manager.isReadableFile(atPath: path) {
            list.append(.readable)
        }
        
        if manager.isWritableFile(atPath: path) {
            list.append(.writable)
        }
        
        if manager.isDeletableFile(atPath: path) {
            list.append(.deletable)
        }
        
        if manager.isExecutableFile(atPath: path) {
            list.append(.executable)
        }
        
        self.init(list)
    }
    
}
