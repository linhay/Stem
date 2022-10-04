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

// MARK: - Type
public struct STFilePathAttributes {
    
    private let url: URL
    
    public init(path: URL) {
        self.url = path
    }
    
}

public extension STFilePathAttributes {
    
    func update(_ value: Any?, for key: FileAttributeKey) throws {
        var attributes = attributes
        attributes[key] = value
        try FileManager.default.setAttributes(attributes, ofItemAtPath: url.path)
    }
    
}

public extension STFilePathAttributes {
    
    struct NameComponents {
        
        public var name: String
        public var `extension`: String?
        public var filename: String { [name, self.extension].compactMap({ $0 }).joined(separator: ".") }
        
        init(_ name: String) {
            let list = name.split(separator: ".")
            guard list.count > 1, let `extension` = list.last else {
                self.name = name
                self.extension = nil
                return
            }
            
            self.name = String(list.dropLast().joined(separator: "."))
            self.`extension` = String(`extension`)
        }
    }
    
    var typeIdentifier: String { (try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier) ?? "" }
    
    /// 返回一个字符串数组，表示给定路径的用户可见组件。
    var componentsToDisplay: [String] { FileManager.default.componentsToDisplay(forPath: url.path) ?? [] }
    /// 文件名
    var name: String { url.lastPathComponent.replacingOccurrences(of: ":", with: "/") }
    
    var nameComponents: NameComponents { .init(name) }
    
    var attributes: [FileAttributeKey: Any] { (try? FileManager.default.attributesOfItem(atPath: url.path)) ?? [:] }
    /// 文件属性字典中的键，其值指示文件是否为只读。
    /// The key in a file attribute dictionary whose value indicates whether the file is read-only.
    var isReadOnly: Bool { attribute(key: .appendOnly, default: false) }
    /// 文件属性字典中的键，其值指示文件是否繁忙。
    /// The key in a file attribute dictionary whose value indicates whether the file is busy.
    var isBusy: Bool { attribute(key: .busy, default: false) }
    /// 文件属性字典中的键，其值表示文件的创建日期。
    /// The key in a file attribute dictionary whose value indicates the file's creation date.
    var creationDate: Date { attribute(key: .creationDate, default: Date()) }
    /// 文件属性字典中的键，其值指示文件所在设备的标识符。
    /// The key in a file attribute dictionary whose value indicates the identifier for the device on which the file resides.
    var deviceIdentifier: Int { attribute(key: .deviceIdentifier, default: 0) }
    /// 文件属性字典中的键，其值指示文件的扩展名是否隐藏。
    /// The key in a file attribute dictionary whose value indicates whether the file’s extension is hidden.
    var extensionHidden: Bool { attribute(key: .extensionHidden, default: false) }
    /// 文件属性字典中的键，其值指示文件的组 ID。
    /// The key in a file attribute dictionary whose value indicates the file’s group ID.
    var groupOwnerAccountID: Int { attribute(key: .groupOwnerAccountID, default: 0) }
    /// 文件属性字典中的键，其值表示文件所有者的组名。
    /// The key in a file attribute dictionary whose value indicates the group name of the file’s owner.
    var groupOwnerAccountName: String { attribute(key: .groupOwnerAccountName, default: "") }
    /// 文件属性字典中的键，其值指示文件的 HFS 创建者代码。
    /// The key in a file attribute dictionary whose value indicates the file’s HFS creator code.
    var hfsCreatorCode: Int { attribute(key: .hfsCreatorCode, default: 0) }
    /// 文件属性字典中的键，其值指示文件的 HFS 类型代码。
    /// The key in a file attribute dictionary whose value indicates the file’s HFS type code.
    var hfsTypeCode: Int { attribute(key: .hfsTypeCode, default: 0) }
    /// 文件属性字典中的键，其值指示文件是否可变。
    /// The key in a file attribute dictionary whose value indicates whether the file is mutable.
    var isImmutable: Bool { attribute(key: .immutable, default: true) }
    /// 文件属性字典中的键，其值指示文件的上次修改日期。
    /// The key in a file attribute dictionary whose value indicates the file’s last modified date.
    var modificationDate: Date { attribute(key: .modificationDate, default: Date()) }
    /// 文件属性字典中的键，其值表示文件所有者的帐户 ID。
    /// The key in a file attribute dictionary whose value indicates the file’s owner's account ID.
    var ownerAccountID: Int { attribute(key: .ownerAccountID, default: 0) }
    /// 文件属性字典中的键，其值表示文件所有者的名称。
    /// The key in a file attribute dictionary whose value indicates the name of the file’s owner.
    var ownerAccountName: String { attribute(key: .ownerAccountName, default: "") }
    /// 文件属性字典中的键，其值指示文件的 Posix 权限。
    /// The key in a file attribute dictionary whose value indicates the file’s Posix permissions.
    var posixPermissions: Int { attribute(key: .posixPermissions, default: 0) }
    /// 文件属性字典中的键，其值标识此文件的保护级别。
    /// The key in a file attribute dictionary whose value identifies the protection level for this file.
    var protectionKey: Int { attribute(key: .protectionKey, default: 0) }
    /// 文件属性字典中的键，其值表示文件的引用计数。
    /// The key in a file attribute dictionary whose value indicates the file’s reference count.
    var referenceCount: Int { attribute(key: .referenceCount, default: 0) }
    /// 文件属性字典中的键，其值指示文件的大小（以字节为单位）。
    /// The key in a file attribute dictionary whose value indicates the file’s size in bytes.
    var size: Int { attribute(key: .size, default: 0) }
    /// 文件属性字典中的键，其值表示文件的文件系统文件号。
    /// The key in a file attribute dictionary whose value indicates the file’s filesystem file number.
    var systemFileNumber: Int { attribute(key: .systemFileNumber, default: 0) }
    /// 文件系统属性字典中的键，其值表示文件系统中的空闲节点数。
    /// The key in a file system attribute dictionary whose value indicates the number of free nodes in the file system.
    var systemFreeNodes: Int { attribute(key: .systemFreeNodes, default: 0) }
    /// 文件系统属性字典中的键，其值指示文件系统上的可用空间量。
    /// The key in a file system attribute dictionary whose value indicates the amount of free space on the file system.
    var systemFreeSize: Int { attribute(key: .systemFreeSize, default: 0) }
    /// 文件系统属性字典中的键，其值表示文件系统中的节点数。
    /// The key in a file system attribute dictionary whose value indicates the number of nodes in the file system.
    var systemNodes: Int { attribute(key: .systemNodes, default: 0) }
    /// 文件系统属性字典中的键，其值表示文件系统的文件系统编号。
    /// The key in a file system attribute dictionary whose value indicates the filesystem number of the file system.
    var systemNumber: Int { attribute(key: .size, default: 0) }
    /// 文件系统属性字典中的键，其值指示文件系统的大小。
    /// The key in a file system attribute dictionary whose value indicates the size of the file system.
    var systemSize: Int { attribute(key: .systemSize, default: 0) }
    /// 文件属性字典中的键，其值指示文件的类型。
    /// The key in a file attribute dictionary whose value indicates the file’s type.
    var type: String { attribute(key: .type, default: "") }
    
    private func attribute<V>(key: FileAttributeKey, default value: @autoclosure () -> V) -> V {
        attributes[key] as? V ?? value()
    }
}
