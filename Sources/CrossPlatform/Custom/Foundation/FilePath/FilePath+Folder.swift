// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import Combine

public extension FilePath {
    
    struct Folder: FilePathProtocol {
        
        @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
        public final class Watcher {
            
            enum State: Int, Equatable {
                case cancel
                case activate
                case suspend
            }
            
            public private(set) lazy var publisher = subject.eraseToAnyPublisher()
            
            private let subject = PassthroughSubject<Void, Never>()
            private let queue = DispatchQueue(label: "stem.folder.watcher.queue")
            private var observer: DispatchSourceFileSystemObject?
            private var state = State.cancel
            private let folder: Folder
            
            init(folder: Folder) {
                self.folder = folder
            }
            
            @discardableResult
            public func cancel() -> Watcher {
                guard state != .cancel else { return self }
                observer?.cancel()
                state = .cancel
                return self
            }
            
            @discardableResult
            public func activate() -> Watcher {
                switch state {
                case .cancel:
                    let descriptor = Darwin.open(folder.url.path, O_EVTONLY)
                    let observer = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor,
                                                                             eventMask: .write,
                                                                             queue: queue)
                    observer.setEventHandler { [weak self] in
                        self?.subject.send(())
                    }
                    
                    observer.setCancelHandler {
                        Darwin.close(descriptor)
                    }
                    self.observer = observer
                case .activate:
                    return self
                case .suspend:
                    break
                }
                state = .activate
                observer?.activate()
                return self
            }
            
            @discardableResult
            public func suspend() -> Watcher {
                guard state == .activate else { return self }
                state = .suspend
                observer?.suspend()
                return self
            }
        }
        
        public let url: URL
        
        public init(url: URL) {
            self.url = url.standardized
        }
        
        public init(path: String) throws {
            self.init(url: .init(fileURLWithPath: path))
        }
        
    }
    
}

public extension FilePath.Folder {
    
    @discardableResult
    func merge(with folder: FilePath.Folder) -> FilePath.Folder {
        return folder
    }
    
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func watcher() -> Watcher {
        return .init(folder: self)
    }
    
}

public extension FilePath.Folder {
    
    func file(name: String) -> FilePath.File {
        FilePath.File(url: url.appendingPathComponent(name, isDirectory: false))
    }
    
    func folder(name: String) -> FilePath.Folder {
        FilePath.Folder(url: url.appendingPathComponent(name, isDirectory: true))
    }
    
    func open(name: String) throws -> FilePath.File {
        let file = FilePath.File(url: url.appendingPathComponent(name, isDirectory: false))
        if file.isExist {
            return file
        } else {
            try create(file: name)
        }
        return file
    }
    
}


public extension FilePath.Folder {
    
    /// 根据当前[FilePath]文件夹
    /// - Throws: FilePathError - 文件夹 存在, 无法创建
    @discardableResult
    func create() throws -> FilePath.Folder {
        try manager.createDirectory(at: url,
                                    withIntermediateDirectories: true,
                                    attributes: nil)
        return self
    }
    
    @discardableResult
    func create(file name: String, data: Data? = nil) throws -> FilePath.File {
        return try FilePath.File(url: url.appendingPathComponent(name, isDirectory: false)).create(with: data)
    }
    
    /// 在当前路径下创建文件夹
    /// - Parameter name: 文件夹名
    /// - Throws: FileManager error
    /// - Returns: 创建文件夹的 FilePath
    @discardableResult
    func create(folder name: String) throws -> FilePath.Folder {
        return try FilePath.Folder(url: url.appendingPathComponent(name, isDirectory: true)).create()
    }
    
}


// MARK: - get subFilePaths
public extension FilePath.Folder {
    
    enum SearchPredicate {
        case skipsSubdirectoryDescendants
        case skipsPackageDescendants
        case skipsHiddenFiles
        @available(iOS 13.0, *) @available(OSX 10.15, *) @available(tvOS 13.0, *)
        case includesDirectoriesPostOrder
        @available(iOS 13.0, *) @available(OSX 10.15, *) @available(tvOS 13.0, *)
        case producesRelativePathURLs
        case custom((FilePath) throws -> Bool)
    }
    
}

extension Array where Element == FilePath.Folder.SearchPredicate {
    
    func split() -> (system: FileManager.DirectoryEnumerationOptions, custom: [(FilePath) throws -> Bool]) {
        var systemPredicates: FileManager.DirectoryEnumerationOptions = []
        var customPredicates = [(FilePath) throws -> Bool]()
        
        self.forEach { item in
            switch item {
            case .skipsSubdirectoryDescendants:
                systemPredicates.insert(.skipsSubdirectoryDescendants)
            case .skipsPackageDescendants:
                systemPredicates.insert(.skipsPackageDescendants)
            case .skipsHiddenFiles:
                systemPredicates.insert(.skipsHiddenFiles)
            case .includesDirectoriesPostOrder:
                #if os(iOS)
                if #available(iOS 13.0, *) {
                    systemPredicates.insert(.includesDirectoriesPostOrder)
                }
                #elseif os(tvOS)
                if #available(tvOS 13.0, *) {
                    systemPredicates.insert(.includesDirectoriesPostOrder)
                }
                #elseif os(OSX)
                if #available(OSX 10.15, *) {
                    systemPredicates.insert(.includesDirectoriesPostOrder)
                }
                #endif
            case .producesRelativePathURLs:
                #if os(iOS)
                if #available(iOS 13.0, *) {
                    systemPredicates.insert(.producesRelativePathURLs)
                }
                #elseif os(tvOS)
                if #available(tvOS 13.0, *) {
                    systemPredicates.insert(.producesRelativePathURLs)
                }
                #elseif os(OSX)
                if #available(OSX 10.15, *) {
                    systemPredicates.insert(.producesRelativePathURLs)
                }
                #endif
            case .custom(let v):
                customPredicates.append(v)
            }
        }
        
        return (systemPredicates, customPredicates)
    }
    
}

public extension FilePath.Folder {
    
    /// 递归获取文件夹中所有文件/文件夹
    /// - Throws: FilePathError - "目标路径不是文件夹类型"
    /// - Parameter predicates: 查找条件
    /// - Returns: [FilePath]
    func allSubFilePaths(predicates: SearchPredicate...) throws -> [FilePath] {
        try allSubFilePaths(predicates: predicates)
    }
    
    /// 递归获取文件夹中所有文件/文件夹
    /// - Throws: FilePathError - "目标路径不是文件夹类型"
    /// - Parameter predicates: 查找条件
    /// - Returns: [FilePath]
    func allSubFilePaths(predicates: [SearchPredicate] = [.skipsHiddenFiles]) throws -> [FilePath] {
        let (systemPredicates, customPredicates) = predicates.split()
        
        let resourceValues: [URLResourceKey] = [.isDirectoryKey]
        guard let enumerator = manager.enumerator(at: url,
                                                  includingPropertiesForKeys: [.nameKey, .isDirectoryKey],
                                                  options: systemPredicates,
                                                  errorHandler: nil) else {
            return []
        }
        
        var list = [FilePath]()
        for case let fileURL as URL in enumerator {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: Set(resourceValues)),
                  let isDirectory = resourceValues.isDirectory
            else {
                continue
            }
            
            let item = FilePath(url: fileURL, type: isDirectory ? .folder : .file)
            if try customPredicates.contains(where: { try $0(item) == false }) {
                continue
            }
            
            list.append(item)
        }
        return list
    }
    
    /// 获取当前文件夹中文件/文件夹
    /// - Throws: FilePathError - "目标路径不是文件夹类型"
    /// - Parameter predicates: 查找条件
    /// - Returns: [FilePath]
    func subFilePaths(predicates: SearchPredicate...) throws -> [FilePath] {
        try subFilePaths(predicates: predicates)
    }
    
    /// 获取当前文件夹中文件/文件夹
    /// - Throws: FilePathError - "目标路径不是文件夹类型"
    /// - Parameter predicates: 查找条件
    /// - Returns: [FilePath]
    func subFilePaths(predicates: [SearchPredicate] = [.skipsHiddenFiles]) throws -> [FilePath] {
        let (systemPredicates, customPredicates) = predicates.split()
        
        return try manager
            .contentsOfDirectory(at: url,
                                 includingPropertiesForKeys: nil,
                                 options: systemPredicates)
            .compactMap({ url in
                return try FilePath(url: url)
            })
            .filter({ item -> Bool in
                try customPredicates.contains(where: { try $0(item) == false }) == false
            })
    }
    
}
