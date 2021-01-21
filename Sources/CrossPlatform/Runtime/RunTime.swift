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

public typealias Runtime = RunTime

public class RunTime {
    
    /// 获取已注册类列表
    ///
    /// - Returns: 已注册类列表
    public static func classList() -> [AnyClass] {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        let list = (0..<typeCount).compactMap { (index) -> AnyClass? in
            return types[index]
        }
        
        types.deinitialize(count: typeCount)
        types.deallocate()
        return list
    }
    
}

public extension RunTime {
    
    /// 获取类型元类
    ///
    /// - Parameter classType: 类型
    /// - Returns: 元类
    static func metaclass(from classType: AnyClass) -> AnyClass? {
        return objc_getMetaClass(String(cString: class_getName(classType))) as? AnyClass
    }
    
    /// 获取该类的实例变量大小
    ///
    /// - Parameter classType: 类型
    /// - Returns: 实例变量大小
    static func instanceSize(from classType: AnyClass) -> Int {
        return class_getInstanceSize(classType)
    }
    
    /// 获取方法列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 方法列表
    static func methods(from classType: AnyClass) -> [Method] {
        return get_list(close: { class_copyMethodList(classType, &$0) }, format: { $0 })
    }
    
    /// 获取属性列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 属性列表
    static func properties(from classType: AnyClass) -> [objc_property_t] {
        return get_list(close: { class_copyPropertyList(classType, &$0) }, format: { $0 })
    }
    
    /// 获取协议列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 协议列表
    static func protocols(from classType: AnyClass) -> [Protocol] {
        return get_list(close: { class_copyProtocolList(classType, &$0) }, format: { $0 })
    }
    
    /// 成员变量列表
    ///
    /// - Parameter classType: 类型
    /// - Returns: 成员变量
    static func ivars(from classType: AnyClass) -> [Ivar] {
        return get_list(close: { class_copyIvarList(classType, &$0) }, format: { $0 })
    }
    
}

private extension RunTime {
    
    static func get_list<T, U>(close: ( _ outcount: inout UInt32) -> AutoreleasingUnsafeMutablePointer<T>?, format: (T) -> U) -> [U] {
        var outcount: UInt32 = 0
        var list = [U]()
        guard let methods = close(&outcount) else { return [] }
        for index in 0..<Int(outcount) {
            list.append(format(methods[index]))
        }
        return list
    }
    
    static func get_list<T, U>(close: ( _ outcount: inout UInt32) -> UnsafeMutablePointer<T>?, format: (T) -> U) -> [U] {
        var outcount: UInt32 = 0
        var list = [U]()
        guard let methods = close(&outcount) else { return [] }
        for index in 0..<numericCast(outcount) {
            list.append(format(methods[index]))
        }
        free(methods)
        return list
    }
    
}
