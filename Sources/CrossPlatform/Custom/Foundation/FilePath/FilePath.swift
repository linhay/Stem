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

public struct FilePath {
    
    public enum ItemType {
        case file(FilePath.File)
        case folder(FilePath.Folder)
    }
    
    var manager: FileManager { FileManager.default }
    static var manager: FileManager { FileManager.default }

    public let type: ItemType
    
    /// 生成 FilePath
    /// - Parameters:
    ///   - url: 文件路径
    ///   - type: 指定文件类型
    /// - Throws: FilePathError - 目标路径不是文件路径 | 目标路径不存在
    public init(type: ItemType) {
        self.type = type
    }
    
    public init(url: URL) throws {
        if try FilePath.isFolder(url) {
            self.type = .folder(.init(url: url))
        } else {
            self.type = .file(.init(url: url))
        }
    }
    
    public init(path: String) throws {
        if try FilePath.isFolder(path) {
            self.type = .folder(.init(url: .init(fileURLWithPath: path, isDirectory: true)))
        } else {
            self.type = .file(.init(url: .init(fileURLWithPath: path, isDirectory: false)))
        }
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
