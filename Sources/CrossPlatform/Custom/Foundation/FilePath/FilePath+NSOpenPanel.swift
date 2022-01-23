//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

#if canImport(AppKit)
import Foundation
import AppKit

public extension FilePath {
    
    static func selectBySystem(base: URL? = nil,
                               canChooseFiles: Bool = true,
                               canChooseDirectories: Bool = true,
                               allowsMultipleSelection: Bool = true) -> [FilePath] {
        
        let panel = NSOpenPanel()
        panel.canChooseFiles = canChooseFiles
        panel.canChooseDirectories = canChooseDirectories
        panel.allowsMultipleSelection = allowsMultipleSelection
        panel.directoryURL = base
        
        if panel.runModal() == .OK {
            return panel.urls.compactMap({ try? .init(url: $0) })
        }
        
        return []
    }
    
}

public extension FilePath.Folder {
    
    static func selectBySystem(base: URL? = nil, allowsMultipleSelection: Bool = false) -> [FilePath.Folder] {
        return FilePath.selectBySystem(base: base,
                                       canChooseFiles: false,
                                       canChooseDirectories: true,
                                       allowsMultipleSelection: allowsMultipleSelection).compactMap({ $0.asFolder() })
    }
    
}

public extension FilePath.File {
    
    static func selectBySystem(base: URL? = nil, allowsMultipleSelection: Bool = false) -> [FilePath.File] {
        return FilePath.selectBySystem(base: base,
                                       canChooseFiles: true,
                                       canChooseDirectories: false,
                                       allowsMultipleSelection: allowsMultipleSelection).compactMap({ $0.asFile() })
    }
    
}

#endif
