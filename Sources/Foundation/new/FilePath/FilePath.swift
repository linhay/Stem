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
    ///   - path: 文件路径
    ///   - type: 指定文件类型, nil: 自动检测
    /// - Throws: FilePathError - path解析错误 | 目标路径不是文件路径 | 目标路径不存在
    public convenience init(path: String, type: Type? = nil) throws {
        guard let url = URLComponents(url: URL(fileURLWithPath: path), resolvingAgainstBaseURL: true)?.url else {
            throw FilePathError(message: "path解析错误: \(path)")
        }
        try self.init(url: url, type: type)
    }
    
    /// 生成 FilePath
    /// - Parameters:
    ///   - url: 文件路径
    ///   - type: 指定文件类型, nil: 自动检测
    /// - Throws: FilePathError - 目标路径不是文件路径 | 目标路径不存在
    public init(url: URL, type: Type? = nil) throws {
        guard url.isFileURL else {
            throw FilePathError(message: "目标路径不是文件路径")
        }
        
        self.url = url
        if let type = type {
            self.type = type
        } else {
            self.type = try FilePath.checkType(url: url)
        }
        
        attributes = Attributes(path: url)
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
    var isExist: Bool {
        return manager.fileExists(atPath: url.path)
    }
    
}

// MARK: - create
public extension FilePath {
    
    /// 根据当前[FilePath]创建文件/文件夹
    /// - Throws: FilePathError - 文件/文件夹 存在, 无法创建
    func create() throws {
        if isExist {
            throw FilePathError(message: "文件/文件夹 存在, 无法创建")
        }
        
        switch type {
        case .file:
            manager.createFile(atPath: url.path, contents: nil, attributes: nil)
        case .folder:
            try manager.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        }
        
    }
    
    /// 在当前路径下创建文件夹
    /// - Parameter name: 文件夹名
    /// - Throws: FileManager error
    /// - Returns: 创建文件夹的 FilePath
    @discardableResult
    func create(folder name: String) throws -> FilePath {
        let folder = url.appendingPathComponent(name, isDirectory: true)
        let exist = manager.fileExists(atPath: folder.path)
        
        guard exist == false else {
            return try FilePath(url: folder, type: .folder)
        }
        
        try manager.createDirectory(at: folder,
                                    withIntermediateDirectories: true,
                                    attributes: nil)
        return try FilePath(url: folder, type: .folder)
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
            throw FilePathError(message: "无法 [文件夹 -> 文件] 转移")
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
        case (.file, .file), (.folder, .folder):
            if path.isExist {
                throw FilePathError(message: "文件重复: \n\(self.url.absoluteString)\n\(path.url.absoluteString)")
            }
            try manager.copyItem(at: url, to: path.url)
        case (.file, .folder):
            let path = try FilePath(url: path.url.appendingPathComponent(attributes.name), type: type)
            if path.isExist {
                throw FilePathError(message: "文件重复: \n\(self.url.absoluteString)\n\(path.url.absoluteString)")
            }
            try manager.copyItem(at: url, to: path.url)
        case (.folder, .file):
            throw FilePathError(message: "无法 [文件夹 -> 文件] 拷贝")
        }
    }
    
}

// MARK: - get subFilePaths
public extension FilePath {
    
    /// 递归获取文件夹中所有文件/文件夹
    /// - Throws: FilePathError - "目标路径不是文件夹类型"
    /// - Returns: [FilePath]
    func allSubFilePaths() throws -> [FilePath] {
        guard self.type == .folder else {
            throw FilePathError(message: "目标路径不是文件夹类型")
        }
        guard let enumerator = manager.enumerator(atPath: url.path) else {
            return []
        }
        var list = [FilePath]()
        for case let path as String in enumerator {
            guard path.hasPrefix(".") == false else {
                continue
            }
            guard let fullPath = enumerator.value(forKey: "path") as? String else {
                continue
            }
            guard let item = try? FilePath(url: URL(fileURLWithPath: fullPath + path)) else {
                continue
            }
            guard item.attributes.name.hasPrefix(".") == false else {
                continue
            }
            list.append(item)
        }
        return list
    }
    
    /// 获取文件夹中文件/文件夹
    /// - Throws: FilePathError - "目标路径不是文件夹类型"
    /// - Returns: [FilePath]
    func subFilePaths() throws -> [FilePath] {
        guard self.type == .folder else {
            throw FilePathError(message: "目标路径不是文件夹类型")
        }
        
        return try manager
            .contentsOfDirectory(at: url,
                                 includingPropertiesForKeys: nil,
                                 options: .skipsHiddenFiles)
            .compactMap({ try? FilePath(url: $0) })
    }
    
}

public extension FilePath {
    
    /// 文件/文件夹类型
    /// - Parameter url: 文件路径
    /// - Throws: FilePathError - "目标路径文件不存在: url"
    /// - Returns: 类型
    static func checkType(url: URL) throws -> Type {
        var isDir: ObjCBool = false
        if manager.fileExists(atPath: url.path, isDirectory: &isDir) {
            if isDir.boolValue {
                return .folder
            } else {
                return .file
            }
        } else {
            throw FilePathError(message: "目标路径文件不存在: \(url.description)")
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
    
    struct FilePathError: Error {
        
        public let message: String
        public let code: Int
        
        @discardableResult
        public init(message: String, code: Int = 0) {
            self.message = message
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
