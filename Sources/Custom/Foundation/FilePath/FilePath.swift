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

public class FilePath: Equatable {
    
    private let manager = FilePath.manager
    private static let manager = FileManager.default
    public let attributes: Attributes
    
    /// 当前路径
    public var url: URL
    /// 当前路径
    public var path: String { url.path }
    /// 文件类型
    public var type: Type
    
    /// 生成 FilePath
    /// - Parameters:
    ///   - url: 文件路径
    ///   - type: 指定文件类型
    /// - Throws: FilePathError - 目标路径不是文件路径 | 目标路径不存在
    public init(url: URL, type: Type) throws {
        guard url.isFileURL else {
            throw Error(message: "目标路径不是文件路径")
        }
        
        self.url = url.standardized
        self.type = type
        attributes = Attributes(path: url)
    }
    
    /// 生成 FilePath
    /// - Parameters:
    ///   - path: 文件路径
    ///   - type: 指定文件类型
    /// - Throws: FilePathError - path解析错误 | 目标路径不是文件路径 | 目标路径不存在
    public convenience init(path: String, type: Type) throws {
        guard let url = URLComponents(url: URL(fileURLWithPath: path), resolvingAgainstBaseURL: true)?.url else {
            throw Error(message: "path解析错误: \(path)")
        }
        try self.init(url: url, type: type)
    }
    
    public convenience init(path: String) throws {
        try self.init(path: path, type: try FilePath.checkType(path))
    }
    
    public convenience init(url: URL) throws {
        try self.init(url: url, type: try FilePath.checkType(url))
    }
    
}

public extension FilePath {
    
    /// 文件数据
    /// - Throws: Data error
    /// - Returns: data
    func data() throws -> Data {
        return try Data(contentsOf: url)
    }
    
}

public extension FilePath {
    
    /// 当前路径是否存在
    var isExist: Bool { manager.fileExists(atPath: url.path) }
    
}

// MARK: - create
public extension FilePath {
    
    /// 根据当前[FilePath]创建文件/文件夹
    /// - Throws: FilePathError - 文件/文件夹 存在, 无法创建
    func create(with data: Data? = nil) throws {
        
        if isExist {
            switch type {
            case .file:
                throw Error(message: "文件存在, 无法创建: \(url.path)")
            case .folder:
                break
            }
        }
        
        switch type {
        case .file:
            try manager.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            manager.createFile(atPath: url.path, contents: data, attributes: nil)
        case .folder:
            try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    @discardableResult
    func create(file name: String, data: Data? = nil) throws -> FilePath {
        let folder = url.appendingPathComponent(name, isDirectory: false)
        let filePath = try FilePath(url: folder, type: .file)
        try filePath.create(with: data)
        return filePath
    }
    
    /// 在当前路径下创建文件夹
    /// - Parameter name: 文件夹名
    /// - Throws: FileManager error
    /// - Returns: 创建文件夹的 FilePath
    @discardableResult
    func create(folder name: String) throws -> FilePath {
        let folder = url.appendingPathComponent(name, isDirectory: true)
        let filePath = try FilePath(url: folder, type: .folder)
        try filePath.create()
        return filePath
    }
    
}

public extension FilePath {
    
    /// 移动至目标路径
    /// - Parameter path: 目标路径
    /// - Throws: FileManagerError - 
    func move(to path: FilePath) throws {
        switch (type, path.type) {
        case (.file, .file), (.folder, .folder):
            try manager.moveItem(at: url, to: path.url)
        case (.file, .folder):
            let fileURL = path.url.appendingPathComponent(attributes.name)
            try manager.moveItem(at: url, to: fileURL)
        case (.folder, .file):
            throw Error(message: "无法 [文件夹 -> 文件] 转移")
        }
    }
    
    /// 删除
    /// - Throws: FileManager error
    func delete() throws {
        guard isExist else {
            return
        }
        try manager.removeItem(at: url)
    }
    
    /// 拷贝至目标路径
    /// - Parameter path: 目标路径
    /// - Throws: FilePathError - 文件重复 | 无法 [文件夹 -> 文件] 拷贝
    func copy(to path: FilePath) throws {
        switch (type, path.type) {
        case (.file, .file):
            if path.isExist {
                throw Error(message: "文件重复: \n\(self.url.path)\n\(path.url.path)")
            }
            try manager.copyItem(at: url, to: path.url)
        case (.folder, .folder):
            let files = try subFilePaths()
            let fromPrefix = self.url.standardizedFileURL.absoluteString
            try files.forEach { filePath in
                let type = filePath.type
                var toURL = filePath.url

                if filePath.url.standardizedFileURL.absoluteString.hasPrefix(fromPrefix) {
                    let toPath = filePath.url.absoluteString.st.deleting(prefix: fromPrefix)
                    toURL = path.url.appendingPathComponent(toPath)
                }

                let toFilePath = try FilePath(url: toURL, type: type)
                try? toFilePath.parentFolder()?.create()
                try filePath.copy(to: toFilePath)
            }
        case (.file, .folder):
            let path = try FilePath(url: path.url.appendingPathComponent(attributes.name), type: type)
            if path.isExist {
                throw Error(message: "文件重复: \n\(self.url.absoluteString)\n\(path.url.absoluteString)")
            }
            try manager.copyItem(at: url, to: path.url)
        case (.folder, .file):
            throw Error(message: "无法 [文件夹 -> 文件] 拷贝")
        }

    }
    
}

// MARK: - get subFilePaths
public extension FilePath {
    
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

extension Array where Element == FilePath.SearchPredicate {

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


public extension FilePath {

    /// 获取所在文件夹
    /// - Returns: 所在文件夹
    func parentFolder() -> FilePath? {
        let parent = url.deletingLastPathComponent()
        guard parent != url else {
            return nil
        }
        return try? FilePath(url: parent, type: .folder)
    }
    
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
        guard self.type == .folder else {
            throw Error(message: "目标路径不是文件夹类型")
        }
        
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
            guard let resourceValues = try? fileURL.resourceValues(forKeys: Set(resourceValues))
                , let isDirectory = resourceValues.isDirectory
                else {
                    continue
            }
            
            let item = try FilePath(url: fileURL, type: isDirectory ? .folder : .file)
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
        guard self.type == .folder else {
            throw Error(message: "目标路径不是文件夹类型")
        }

        let (systemPredicates, customPredicates) = predicates.split()

        return try manager
            .contentsOfDirectory(at: url,
                                 includingPropertiesForKeys: nil,
                                 options: systemPredicates)
            .compactMap({ try? FilePath(url: $0) })
            .filter({ item -> Bool in
                try customPredicates.contains(where: { try $0(item) == false }) == false
            })
    }
    
}

public extension FilePath {
    
    /// 文件/文件夹类型
    /// - Parameter url: 文件路径
    /// - Throws: FilePathError - "目标路径文件不存在: url"
    /// - Returns: 类型
    static func checkType(_ url: URL) throws -> Type {
        return try checkType(url.path)
    }
    
    static func checkType(_ path: String) throws -> Type {
        var isDir: ObjCBool = false
        if manager.fileExists(atPath: path, isDirectory: &isDir) {
            if isDir.boolValue {
                return .folder
            } else {
                return .file
            }
        } else {
            throw Error(message: "目标路径文件不存在: \(path)")
        }
    }
    
}

public extension FilePath {
    
    static func == (lhs: FilePath, rhs: FilePath) -> Bool {
        return lhs.url == rhs.url && rhs.type == lhs.type
    }
    
}

// MARK: - Error
public extension FilePath {
    
    struct Error: LocalizedError {
        
        public let message: String
        public let code: Int
        public var errorDescription: String?
        
        @discardableResult
        public init(message: String, code: Int = 0) {
            self.message = message
            self.errorDescription = message
            self.code = code
        }
    }
    
}

// MARK: - Type
public extension FilePath {
    
    enum `Type` {
        /// 文件夹
        case folder
        /// 文件
        case file
    }
    
}
// MARK: - Type
public extension FilePath {
    
    struct Attributes {
        
        private let url: URL
        private let manager = FilePath.manager
        private var attributesOfItem: [FileAttributeKey: Any] {
            return (try? manager.attributesOfItem(atPath: url.path)) ?? [:]
        }
        
        /// 文件名
        public var name: String {
            return url.lastPathComponent
        }
        
        /// 创建时间
        public var creationDate: Date? {
            return attributesOfItem[.creationDate] as? Date
        }
        
        /// 创建时间
        public var size: Int? {
            return attributesOfItem[.size] as? Int
        }
        
        init(path: URL) {
            self.url = path
        }
        
    }
    
}
