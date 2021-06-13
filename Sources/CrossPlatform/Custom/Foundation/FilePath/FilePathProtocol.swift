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

public protocol FilePathProtocol {
    
    var url: URL { get }
    
    init(url: URL)
    
}

extension FilePathProtocol {
    var manager: FileManager { FileManager.default }
}

public extension FilePathProtocol {
    
    var attributes: FilePathAttributes { .init(path: url) }
    
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
    func move(into folder: FilePath.Folder) throws -> Self {
        let fileURL = folder.url.appendingPathComponent(attributes.name)
        try manager.moveItem(at: url, to: fileURL)
        return .init(url: fileURL)
    }
    
    /// 替换至目标路径
    /// - Parameter path: 目标路径
    /// - Throws: FileManagerError
    @discardableResult
    func replace(_ path: Self) throws -> Self {
        try manager.moveItem(at: url, to: path.url)
        return path
    }
    
    /// 获取所在文件夹
    /// - Returns: 所在文件夹
    func parentFolder() -> FilePath.Folder? {
        let parent = url.deletingLastPathComponent()
        guard parent != url else {
            return nil
        }
        return .init(url: parent)
    }
    
}
