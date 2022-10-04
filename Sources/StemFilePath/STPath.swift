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

public struct STPath: STPathProtocol {
    
    public var id: URL { url }
    
    private var manager: FileManager { FileManager.default }
    private static var manager: FileManager { FileManager.default }
    
    public var type: STFilePathItemType {
        if !isExist {
            return .notExist
        }
        let flag = (try? STPath.isFolder(url)) ?? false
        return flag ? .folder : .file
    }
    
    public var referenceType: STFilePathReferenceType? {
        switch type {
        case .file:
            return .file(.init(url))
        case .folder:
            return .folder(.init(url))
        case .notExist:
            return nil
        }
    }
    
    public var url: URL
    
    public init(_ url: URL) {
        self.url = url.standardized
    }
    
    public init(_ path: String) {
        self.init(Self.standardizedPath(path))
    }
}

public extension STPath {
    
    var asFile: STFile? {
        type == .file ? .init(url) : nil
    }
    
    var asFolder: STFolder? {
        type == .folder ? .init(url) : nil
    }
    
}

private extension STPath {
    
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
