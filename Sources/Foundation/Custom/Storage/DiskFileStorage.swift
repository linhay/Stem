//
//  Pods
//
//  Copyright (c) 2019/6/13 linhey - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import Foundation

public class DiskFileStorage {

    let manager = FileManager.default
    let encode = JSONEncoder()
    let decode = JSONDecoder()

    private let folderPath: String

    var path: String { return folderPath }

    lazy var queue: DispatchQueue = DispatchQueue(label: "linhey.stone.diskFileStorage")

    public init(type: PathType = PathType.document(folder: "default")) {
        self.folderPath = type.rawValue
        try? createDirectoryIfNeeded(url: folderPath)
    }
}

public extension DiskFileStorage {
    struct File {
        public let name: String
        public let url: String
        public let modificationDate: Date?
        public let size: UInt64?
    }

    enum PathType {
        case document(folder: String)
        case cache(folder: String)
        case temp(folder: String)
        case custom(url: String)

        var rawValue: String {
            switch self {
            case .document(let name): return NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first! + "/stone/\(name)/"
            case .cache(let name):    return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true).first! + "/stone/\(name)/"
            case .temp(let name):     return NSTemporaryDirectory() + "/stone/\(name)/"
            case .custom(let url):    return url
            }
        }
    }
}

public extension DiskFileStorage {

    func size() throws -> UInt64 {
        var totalSize: UInt64 = 0
        let contents = try manager.contentsOfDirectory(atPath: folderPath)
        try contents.forEach { content in
            let fileUrl = folderPath + content
            let attributes = try manager.attributesOfItem(atPath: fileUrl)
            if let size = attributes[.size] as? UInt64 {
                totalSize += size
            }
        }
        return totalSize
    }

    func files() throws -> [File] {
        let contents = try manager.contentsOfDirectory(atPath: folderPath)
        let files: [File] = try contents.map({ content in
            let fileUrl = folderPath + content
            let attributes = try manager.attributesOfItem(atPath: fileUrl)
            let modificationDate = attributes[.modificationDate] as? Date
            let size = attributes[.size] as? UInt64

            return File(name: content,
                        url: fileUrl,
                        modificationDate: modificationDate,
                        size: size)
        })
        return files
    }

}

// MARK: - subscript
public extension DiskFileStorage {

    subscript<T: Codable>(_ key: String) -> T? {
        set { _ = set(value: newValue, for: key) }
        get { return get(key: key) }
    }

}

// MARK: - set / get with Codable
public extension DiskFileStorage {

    func set<T: Codable>(value: T, for key: String) -> Bool {
        guard let data = try? encode.encode(value) else { return false }
        return set(data: data, for: key)
    }

    func get<T: Codable>(key: String) -> T? {
        guard let data = get(key: key) else { return nil }
        return try? decode.decode(T.self, from: data)
    }

}

// MARK: - set / get with async
public extension DiskFileStorage {

    func set(data: Data?, for key: String, completion: ((Bool) -> Void)? = nil) {
        self.queue.async {
            completion?(self.set(data: data, for: key))
        }
    }

    func get(key: String, completion: ((Data?) -> Void)? = nil) {
        self.queue.async {
            completion?(self.get(key: key))
        }
    }

}

// MARK: - set / get with sync
public extension DiskFileStorage {

    func set(data: Data?, for key: String) -> Bool {
        let path = folderPath + key.md5
        if let data = data {
            return manager.createFile(atPath: path, contents: data, attributes: nil)
        } else {
            do {
                let url = URL(fileURLWithPath: path)
                try manager.removeItem(at: url)
                return true
            } catch {
                return false
            }
        }
    }

    func get(key: String) -> Data? {
        let path = folderPath + key.md5
        return manager.contents(atPath: path)
    }

}

public extension DiskFileStorage {

    private func createDirectoryIfNeeded(url: String) throws {
        guard !manager.fileExists(atPath: url) else { return }
        try manager.createDirectory(atPath: url, withIntermediateDirectories: true, attributes: nil)
    }

    func removeAll() -> Bool {
        let url = URL(fileURLWithPath: folderPath)
        guard (try? manager.removeItem(at: url)) != nil else { return false }
        guard (try? self.createDirectoryIfNeeded(url: folderPath)) != nil else { return false }
        return true
    }

    func remove(key: String) -> Bool {
        let url = URL(fileURLWithPath: self.folderPath + key.md5)
        return (try? self.manager.removeItem(at: url)) == nil
    }

    func remove(expired before: Date) -> Bool {
        guard let files = try? self.files() else { return false }

        files.forEach { (item) in
            guard let modificationDate = item.modificationDate else { return }
            guard modificationDate >= before else { return }
            DispatchQueue.global().async {
                let url = URL(fileURLWithPath: self.folderPath)
                try? self.manager.removeItem(at: url)
            }
        }

        return true
    }

}
