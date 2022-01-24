//
//  File.swift
//  
//
//  Created by linhey on 2022/1/23.
//

#if canImport(AppKit)
import Foundation
import AppKit

public extension FilePathProtocol {
    
    func showInFinder() {
        guard let referenceType = try? FilePath(url: url).referenceType else {
            return
        }
        switch referenceType {
        case .file(let value):
            NSWorkspace.shared.activateFileViewerSelecting([value.url])
        case .folder(let value):
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: value.url.path)
        }
    }
    
    static func selectInFinder(_ folder: URL,
                               support: [FilePathItemType] = [.file, .folder],
                               allowsMultipleSelection: Bool = true) -> [FilePath] {
        let panel = NSOpenPanel()
        panel.canChooseFiles = support.contains(.file)
        panel.canChooseDirectories = support.contains(.folder)
        panel.allowsMultipleSelection = allowsMultipleSelection
        panel.directoryURL = folder
        
        if panel.runModal() == .OK {
            return panel.urls.compactMap({ try? .init(url: $0) })
        }
        
        return []
    }
    
}

public extension FilePath.Folder {
    
    func selectInFinder(support: [FilePathItemType] = [.file, .folder],
                        allowsMultipleSelection: Bool = true) -> [FilePath] {
        return Self.selectInFinder(url,
                                   support: support,
                                   allowsMultipleSelection: allowsMultipleSelection)
    }
    
}

#endif
