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

public struct FilePath: FilePathProtocol {
    
    public enum ItemType: Int, Equatable, Codable {
        case file
        case folder
        
        public var isFile: Bool { self == .file }
        public var isFolder: Bool { self == .folder }
    }
    
    private var manager: FileManager { FileManager.default }
    private static var manager: FileManager { FileManager.default }
    
    public let type: ItemType
    public var url: URL
    
    public init(url: URL, type: ItemType) {
        self.url = url.standardized
        self.type = type
    }
    
    public init(url: URL) throws {
        self.init(url: url, type: try FilePath.isFolder(url) ? .folder : .file)
    }
    
    public init(path: String) throws {
        try self.init(url: .init(fileURLWithPath: path))
    }
}

private extension FilePath {
    
    /// 文件/文件夹类型
    /// - Parameter url: 文件路径
    /// - Throws: FilePathError - "目标路径文件不存在: url"
    /// - Returns: 类型
    static func isFolder(_ url: URL) throws -> Bool {
        return try isFolder(url.path)
    }
    
    static func isFolder(_ path: String) throws -> Bool {
        var isDir: ObjCBool = false
        if manager.fileExists(atPath: path, isDirectory: &isDir) {
            if isDir.boolValue {
                return true
            } else {
                return false
            }
        } else {
            throw Error(message: "目标路径文件不存在: \(path)")
        }
    }
    
}
