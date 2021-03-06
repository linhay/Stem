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

public extension FilePath {
    
    struct File: FilePathProtocol {
        
        public let url: URL
        
        public init(url: URL) {
            self.url = url.standardized
        }
        
        public init(path: String) throws {
            self.init(url: .init(fileURLWithPath: path))
        }
        
    }
    
}

public extension FilePath.File {
    
    /// 文件数据
    /// - Throws: Data error
    /// - Returns: data
    func data(options: Data.ReadingOptions = []) throws -> Data {
        return try Data(contentsOf: url, options: options)
    }
    
    /// 根据当前[FilePath]创建文件/文件夹
    /// - Throws: FilePathError - 文件/文件夹 存在, 无法创建
    @discardableResult
    func create(with data: Data? = nil) throws -> FilePath.File {
        if isExist {
            throw FilePath.Error(message: "文件存在, 无法创建: \(url.path)")
        }
        try FilePath.Folder(url: url.deletingLastPathComponent()).create()
        manager.createFile(atPath: url.path, contents: data, attributes: nil)
        return self
    }
    
}
