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

public protocol STPathProtocol: Identifiable, Hashable {
    
    var type: STFilePathItemType { get }
    var url: URL { get }
    var id: URL {get }
    
    init(_ url: URL) throws
    
}

extension STPathProtocol {
    
    public var path: String { url.path }
    public var id: URL { url }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.url == rhs.url
    }
    
}

extension STPathProtocol {
    var manager: FileManager { FileManager.default }
}


public extension STPathProtocol {

    func relativePath(from base: STFile) -> String {
        relativePath(from: base.parentFolder()!)
    }
    
    func relativePath(from base: STFolder) -> String {
        let destComponents = url.standardized.pathComponents
        let baseComponents = base.url.standardized.pathComponents
        // Find number of common path components:
        var i = 0
        while i < destComponents.count && i < baseComponents.count
            && destComponents[i] == baseComponents[i] {
                i += 1
        }
        // Build relative path:
        var relComponents = Array(repeating: "..", count: baseComponents.count - i)
        relComponents.append(contentsOf: destComponents[i...])
        return relComponents.joined(separator: "/")
    }
    
    static func standardizedPath(_ path: String) -> URL {
        if path == "~" {
            return STFolder.Sanbox.home.url
        } else if path.hasPrefix("~/") {
            var components = path.split(separator: "/").map({ $0.description })
            components = Array(components.dropFirst())
            let home = STFolder.Sanbox.home.url.path.split(separator: "/").map({ $0.description })
            components.insert(contentsOf: home, at: 0)
            return URL(fileURLWithPath: Self.standardizedPath(components))
        } else {
            return URL(fileURLWithPath: path)
        }
    }
    
    private static func standardizedPath<S>(_ components: [S]) -> String where S: StringProtocol {
        var result = [S]()
        for component in components {
            switch component {
            case "..":
                result = result.dropLast()
            case ".":
                break
            default:
                result.append(component)
            }
        }
        return "/" + result.joined(separator: "/")
    }
    
}

public extension STPathProtocol {
    
    var eraseToFilePath: STPath { return .init(url) }
    
    var attributes: STFilePathAttributes { .init(path: url) }
    
    /// 文件权限
    var permission: STFilePathPermission { .init(url: url) }
    
    /// 当前路径是否存在
    var isExist: Bool { manager.fileExists(atPath: url.path) }
    
    /// 删除
    /// - Throws: FileManager error
    func delete() throws {
        guard isExist else { return }
        try manager.removeItem(at: url)
    }
    

    /// 移动至目标路径
    /// - Parameters:
    ///   - folder: 目标路径
    ///   - isOverlay: 目标目录存在相应文件, 是否覆盖
    /// - Returns: FileManagerError
    @discardableResult
    func move(into folder: STFolder, isOverlay: Bool = false) throws -> Self {
        let fileURL = folder.url.appendingPathComponent(attributes.name)
        if isOverlay {
            let path = STPath(fileURL)
            if path.isExist {
               try path.delete()
            }
        }
        if !folder.isExist {
            try folder.create()
        }
        try manager.moveItem(at: url, to: fileURL)
        return try .init(fileURL)
    }
    
    /// 复制至目标路径
    /// - Parameters:
    ///   - folder: 目标路径
    ///   - isOverlay: 目标目录存在相应文件, 是否覆盖
    /// - Returns: FileManagerError
    @discardableResult
    func copy(into folder: STFolder, isOverlay: Bool = false) throws -> Self {
        let fileURL = folder.url.appendingPathComponent(url.lastPathComponent)
        if isOverlay {
            let path = STPath(fileURL)
            if path.isExist {
               try path.delete()
            }
        }
        if !folder.isExist {
            try folder.create()
        }
        try manager.copyItem(at: url, to: fileURL)
        return try .init(fileURL)
    }
    
    /// 获取所在文件夹
    /// - Returns: 所在文件夹
    func parentFolder() -> STFolder? {
        let parent = url.deletingLastPathComponent()
        guard parent != url else {
            return nil
        }
        return .init(parent)
    }
    
}
