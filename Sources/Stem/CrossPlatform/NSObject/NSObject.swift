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

extension NSObject: StemCompatible { }

public extension Stem where Base: NSObject {

    #if !os(macOS)
    var className: String {
        return type(of: self).className
    }
    #endif

    static var className: String {
        return String(describing: self)
    }

    /// 内存地址
    var memoryAddress: String {
        String(describing: Unmanaged<NSObject>.passUnretained(base).toOpaque())
    }

}

public extension Stem where Base: NSObject {

    func value<T>(for key: String, as kind: T.Type = T.self) -> T? {
        guard let ivar = class_getInstanceVariable(type(of: base), key) else { return nil }
        return object_getIvar(base, ivar) as? T
    }

    func setValue(_ value: Any?, for key: String) {
        base.setValue(value, forKey: key)
    }

    func setAssociated<T>(value: T, for key: String, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        setAssociated(value: value, for: UnsafeRawPointer(bitPattern: key.hashValue)!, policy: policy)
    }

    func setAssociated<T>(value: T, for key: UnsafeRawPointer, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(base, key, value, policy)
    }

    func getAssociated<T>(for key: String) -> T? {
        return getAssociated(for: UnsafeRawPointer(bitPattern: key.hashValue)!)
    }

    func getAssociated<T>(for key: UnsafeRawPointer) -> T? {
        let value = objc_getAssociatedObject(base, key) as? T
        return value
    }

}
