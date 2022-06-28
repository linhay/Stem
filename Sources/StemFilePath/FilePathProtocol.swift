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

public protocol FilePathProtocol: Identifiable, Hashable {
    
    var type: FilePathItemType { get }
    var url: URL { get }
    var id: URL {get }
    
    init(_ url: URL) throws
    
}

extension FilePathProtocol {
    
    public var path: String { url.path }
    public var id: URL { url }
    
}

extension FilePathProtocol {
    var manager: FileManager { FileManager.default }
}


extension FilePathProtocol {
    
   public static func standardizedPath(_ path: String) throws -> URL {
        if path == "~" {
            return try STFolder.SanboxRootPath.home.url()
        } else if path.hasPrefix("~/") {
            var components = path.split(separator: "/").map({ $0.description })
            components = Array(components.dropFirst())
            let home = STFolder.SanboxRootPath.home.path?.split(separator: "/").map({ $0.description }) ?? []
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

public extension FilePathProtocol {
    
    var eraseToFilePath: STPath {
        get throws {
            return try .init(url)
        }
    }
    
    var attributes: FilePathAttributes { .init(path: url) }
    
    /// 文件权限
    var permission: FilePathPermission { .init(url: url) }
    
    /// 当前路径是否存在
    var isExist: Bool { manager.fileExists(atPath: url.path) }
    
    /// 删除
    /// - Throws: FileManager error
    func delete() throws {
        guard isExist else { return }
        try manager.removeItem(at: url)
    }
    
    /// 移动至目标路径
    /// - Parameter path: 目标路径
    /// - Throws: FileManagerError -
    @discardableResult
    func move(into folder: STFolder) throws -> Self {
        let fileURL = folder.url.appendingPathComponent(attributes.name)
        try manager.moveItem(at: url, to: fileURL)
        return try .init(fileURL)
    }
    
    /// 复制至目标文件夹
    /// - Parameter path: 目标文件夹
    /// - Throws: FileManagerError -
    @discardableResult
    func copy(into folder: STFolder) throws -> Self {
        let desURL = folder.url.appendingPathComponent(url.lastPathComponent)
        try manager.copyItem(at: url, to: desURL)
        return try .init(desURL)
    }
    
    /// 替换至目标路径
    /// - Parameter path: 目标路径
    /// - Throws: FileManagerError
    @discardableResult
    func replace<Path: FilePathProtocol>(_ path: Path) throws -> Self where Path.ID == URL {
        try? path.delete()
        try manager.copyItem(at: url, to: path.url)
        return try .init(path.url)
    }
    
    /// 替换至目标路径
    /// - Parameter path: 目标路径
    /// - Throws: FileManagerError
    @discardableResult
    func replace(into folder: STFolder) throws -> Self {
        let desURL = folder.url.appendingPathComponent(url.lastPathComponent)
        return try replace(STPath(desURL, as: type))
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
