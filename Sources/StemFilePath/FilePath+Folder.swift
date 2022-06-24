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

public struct STFolder: FilePathProtocol, Identifiable, Equatable {
    
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
        private let folder: STFolder
        
        init(folder: STFolder) {
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
    
    public let type: FilePathItemType = .folder
    public var id: URL { url }
    public let url: URL
    
    public init(_ url: URL) {
        self.url = url.standardized
    }
    
    public init(_ path: String) throws {
        try self.init(Self.standardizedPath(path))
    }
    
}


public extension STFolder {
    
    @discardableResult
    func merge(with folder: STFolder) -> STFolder {
        return folder
    }
    
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func watcher() -> Watcher {
        return .init(folder: self)
    }
    
}

public extension STFolder {
    
    func file(name: String) -> STFile {
        STFile(url.appendingPathComponent(name, isDirectory: false))
    }
    
    func folder(name: String) -> STFolder {
        STFolder(url.appendingPathComponent(name, isDirectory: true))
    }
    
    func open(name: String) throws -> STFile {
        let file = STFile(url.appendingPathComponent(name, isDirectory: false))
        if file.isExist {
            return file
        } else {
            try create(file: name)
        }
        return file
    }
    
}


public extension STFolder {
    
    /// 根据当前[FilePath]文件夹
    /// - Throws: FilePathError - 文件夹 存在, 无法创建
    @discardableResult
    func create() throws -> STFolder {
        try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return self
    }
    
    @discardableResult
    func create(file name: String, data: Data? = nil) throws -> STFile {
        return try STFile(url.appendingPathComponent(name, isDirectory: false)).create(with: data)
    }
    
    /// 在当前路径下创建文件夹
    /// - Parameter name: 文件夹名
    /// - Throws: FileManager error
    /// - Returns: 创建文件夹的 FilePath
    @discardableResult
    func create(folder name: String) throws -> STFolder {
        return try STFolder(url.appendingPathComponent(name, isDirectory: true)).create()
    }
    
}


// MARK: - get subFilePaths
public extension STFolder {
    
    enum SearchPredicate {
        case skipsSubdirectoryDescendants
        case skipsPackageDescendants
        case skipsHiddenFiles
        @available(iOS 13.0, *) @available(macOS 10.15, *) @available(tvOS 13.0, *)
        case includesDirectoriesPostOrder
        @available(iOS 13.0, *) @available(macOS 10.15, *) @available(tvOS 13.0, *)
        case producesRelativePathURLs
        case custom((STPath) throws -> Bool)
    }
    
}

extension Array where Element == STFolder.SearchPredicate {
    
    func split() -> (system: FileManager.DirectoryEnumerationOptions, custom: [(STPath) throws -> Bool]) {
        var systemPredicates: FileManager.DirectoryEnumerationOptions = []
        var customPredicates = [(STPath) throws -> Bool]()
        
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
#elseif os(macOS)
                if #available(macOS 10.15, *) {
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
#elseif os(macOS)
                if #available(macOS 10.15, *) {
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

public extension STFolder {
    
    /// 递归获取文件夹中所有文件/文件夹
    /// - Throws: FilePathError - "目标路径不是文件夹类型"
    /// - Parameter predicates: 查找条件
    /// - Returns: [FilePath]
    func allSubFilePaths(predicates: SearchPredicate...) throws -> [STPath] {
        try allSubFilePaths(predicates: predicates)
    }
    
    /// 递归获取文件夹中所有文件/文件夹
    /// - Throws: FilePathError - "目标路径不是文件夹类型"
    /// - Parameter predicates: 查找条件
    /// - Returns: [FilePath]
    func allSubFilePaths(predicates: [SearchPredicate] = [.skipsHiddenFiles]) throws -> [STPath] {
        let (systemPredicates, customPredicates) = predicates.split()
        
        let resourceValues: [URLResourceKey] = [.isDirectoryKey]
        guard let enumerator = manager.enumerator(at: url,
                                                  includingPropertiesForKeys: [.nameKey, .isDirectoryKey],
                                                  options: systemPredicates,
                                                  errorHandler: nil) else {
            return []
        }
        
        var list = [STPath]()
        for case let fileURL as URL in enumerator {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: Set(resourceValues)),
                  let isDirectory = resourceValues.isDirectory
            else {
                continue
            }
            
            let item = STPath(fileURL, as: isDirectory ? .folder : .file)
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
    func subFilePaths(predicates: SearchPredicate...) throws -> [STPath] {
        try subFilePaths(predicates: predicates)
    }
    
    /// 获取当前文件夹中文件/文件夹
    /// - Throws: FilePathError - "目标路径不是文件夹类型"
    /// - Parameter predicates: 查找条件
    /// - Returns: [FilePath]
    func subFilePaths(predicates: [SearchPredicate] = [.skipsHiddenFiles]) throws -> [STPath] {
        let (systemPredicates, customPredicates) = predicates.split()
        return try manager
            .contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: systemPredicates)
            .compactMap({ try STPath($0) })
            .filter({ item -> Bool in
                try customPredicates.contains(where: { try $0(item) == false }) == false
            })
    }
    
    
    /// 文件扫描
    /// - Parameter scanSubFolder: 是否扫描子文件夹
    /// - Returns: 文件序列
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func fileScan(folderFilter: @escaping ((STFolder) async throws -> Bool) = { _ in true },
                  fileFilter: @escaping ((STFile) async throws -> Bool) = { _ in true }) -> AsyncThrowingStream<STFile, Error> {
        .init { continuation in
            Task {
                do {
                    let urls = try manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
                    for url in urls {
                        do {
                            let filePath = try STPath(url)
                            switch filePath.referenceType {
                            case .file(let file):
                                if try await fileFilter(file) {
                                    continuation.yield(file)
                                }
                            case .folder(let folder):
                                if try await folderFilter(folder) {
                                    for try await item in folder.fileScan(folderFilter: folderFilter) {
                                        continuation.yield(item)
                                    }
                                }
                            }
                        } catch {
                            debugPrint("FilePath Scan: ", error.localizedDescription)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
}
