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

public struct STFile: STPathProtocol, Codable {
    
    public var type: STFilePathItemType = .file
    public let url: URL
    
    public init(_ url: URL) {
        self.url = url.standardized
    }
    
    public init(_ path: String) {
        self.init(Self.standardizedPath(path))
    }
    
}

public extension STFile {
    
    @discardableResult
    func move(to file: STFile) throws -> STFile {
        try manager.moveItem(at: url, to: file.url)
        return file
    }
    
    /// 替换目标文件夹中指定文件
    /// - Parameter file: 指定文件路径
    /// - Throws: FileManagerError
    func replace(_ file: STFile) throws {
        if file.isExist {
            try file.delete()
        }
        try self.copy(to: file)
    }
    
    /// 复制至目标文件夹
    /// - Parameter file: 指定文件路径
    /// - Throws: FileManagerError
    @discardableResult
    func copy(to file: STFile) throws -> STFile {
        try manager.copyItem(at: url, to: file.url)
        return file
    }
    
}

public extension STFile {
    
    func read(_ options: Data.ReadingOptions = [], encoding: String.Encoding = .utf8) throws -> String {
        String(data: try data(options: options), encoding: encoding) ?? ""
    }
    
    func write(_ data: Data) throws {
        try data.write(to: url)
    }
    
}

public extension STFile {
    
    /// 文件数据
    /// - Throws: Data error
    /// - Returns: data
    func data(options: Data.ReadingOptions = []) throws -> Data {
        try Data(contentsOf: url, options: options)
    }
    
    func createIfNotExists(with data: Data? = nil) throws -> STFile {
        if isExist {
            return self
        } else {
            return try create(with: data)
        }
    }
    
    /// 根据当前[FilePath]创建文件/文件夹
    /// - Throws: FilePathError - 文件/文件夹 存在, 无法创建
    @discardableResult
    func create(with data: Data? = nil) throws -> STFile {
        if isExist {
            throw STPathError(message: "文件存在, 无法创建: \(url.path)")
        }
        try STFolder(url.deletingLastPathComponent()).create()
        manager.createFile(atPath: url.path, contents: data, attributes: nil)
        return self
    }
    
    /// 覆盖文件内容(文件不存在则会创建文件)
    /// - Parameter with: 数据
    @discardableResult
    func overlay(with data: Data?) throws -> Self {
        if !isExist {
            try create(with: data)
            return self
        }
        try delete()
        try create(with: data)
        return self
    }
    
    func overlay(with data: String?, using: String.Encoding = .utf8) throws {
        try overlay(with: data?.data(using: using))
    }
    
    /// 追加数据到文件末尾(文件不存在则会创建文件)
    /// - Parameter data: 数据
    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    func append(data: Data?) throws {
        if !isExist {
            try create(with: data)
            return
        }
        
        guard let data = data,
              let handle = FileHandle(forWritingAtPath: path) else {
            return
        }
        
        try handle.seekToEnd()
        try handle.write(contentsOf: data)
    }
    
}
