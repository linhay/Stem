//
//  Stem
//
//  github: https://github.com/linhay/Stem
//  Copyright (c) 2019 linhay - https://github.com/linhay
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
import ObjectiveC.runtime

public struct OBJC {
    
    public enum Encode: String, Hashable {
        case void             = "v"//void类型   v
        case sel              = ":"//selector  :
        case object           = "@"//对象类型   "@"
        case block            = "@?"
        case double           = "d"//double类型 d
        case int              = "i"//int类型    i
        case bool             = "B"//C++中的bool或者C99中的_Bool B
        case longlong         = "q"//long long类型 q
        case point            = "^"//  ^
        case unknown          = "."
        case char             = "c"//char      c
        case short            = "s"//short     s
        case long             = "l"//long      l
        case float            = "f"//float     f
        case `class`          = "#"//class     #
        case unsignedChar     = "C"//unsigned char    C
        case unsignedInt      = "I"//unsigned int     I
        case unsignedShort    = "S"//unsigned short   S
        case unsignedLong     = "L"//unsigned long    L
        case unsignedLongLong = "Q"//unsigned short   Q
        // case char*            = "*"//char*     *
        //  case array    =     //[array type]
        //  case `struct` =     //{name=type…}
        //  case union    =     //(name=type…)
        //  case bnum     =     //A bit field of num bits
        
        public init(char: UnsafePointer<CChar>) {
            guard let str = String(utf8String: char) else {
                self = .unknown
                return
            }
            self = OBJC.Encode(rawValue: str) ?? .unknown
        }
    }
    
    public struct Protocol2 {
        
    }
    
    public struct Property {
        public let value: objc_property_t
        
        public init(value: objc_property_t) {
            self.value = value
        }
        
    }
    
    public class Method {
        
        public let pointer: OpaquePointer
        
        public lazy var imp: IMP = {
            return method_getImplementation(pointer)
        }()
        
        /// 函数类型编码
        public lazy var typeEncoding: String? = {
            guard let typeEncoding = method_getTypeEncoding(pointer) else {
                return nil
            }
            return String(cString: typeEncoding)
        }()
        
        /// 参数类型
        public lazy var argTypes: [OBJC.Encode] = {
            let arguments = method_getNumberOfArguments(pointer)
            return (0..<arguments).map { (index) -> OBJC.Encode in
                guard let argumentType = method_copyArgumentType(pointer, index) else {
                    return OBJC.Encode.unknown
                }
                let type = OBJC.Encode(char: argumentType)
                free(argumentType)
                return type
            }
        }()
        
        /// 返回值类型
        public lazy var returnType: OBJC.Encode = {
            /// 返回值类型
            let type = method_copyReturnType(pointer)
            defer { free(type) }
            return OBJC.Encode(char: type)
        }()
        
        /// Selector
        public lazy var selector: Selector = {
            return method_getName(pointer)
        }()
        
        public init(value: OpaquePointer) {
            self.pointer = value
            self.argTypes = []
        }
        
    }
    
    /// 实例
    public struct Object {
        /// 实例
        public let value: AnyObject
        /// 类型
        public let type: Class
        
        public init(value: AnyObject, type: Class) {
            self.value = value
            self.type = type
        }
        
    }
    
    /// 类型
    public struct Class {
        
        /// 类型实例
        public var type: AnyClass
        /// 类型名
        public var name: String
        /// 所在 bundle
        public var bundle: Bundle
        
        public init(type: AnyClass) {
            self.type = type
            self.name = String(cString: class_getName(type))
            self.bundle = Bundle(for: type)
        }
        
        public init?(name: String, bundle: Bundle = Bundle.main) {
            self.name = name
            self.bundle = bundle
            
            let namespace = bundle.infoDictionary?["CFBundleExecutable"] as? String ?? ""
            if let type = NSClassFromString(name) {
                self.type = type
            } else if let type = NSClassFromString("\(namespace).\(name)") {
                self.type = type
            } else {
                return nil
            }
        }
        
        public init?(name: UnsafePointer<Int8>, bundle: Bundle = Bundle.main) {
            let name = String(cString: name)
            self.init(name: name, bundle: bundle)
        }
        
    }
    
}

// MARK: - static
public extension OBJC.Class {
    
    /// 加载动态库
    /// - Parameter path: 动态库路径
    @discardableResult
    static func load(_ path: String) -> Bool {
        guard let bundle = Bundle(path: path) else {
            return false
        }
        
        if bundle.isLoaded {
            return true
        }
        
        return bundle.load()
    }
    
}

// MARK: - func
public extension OBJC.Class {
    
    /// 元类
    var metaClass: OBJC.Class? {
        guard let type = objc_getMetaClass(name) as? AnyClass else {
            return nil
        }
        return OBJC.Class(type: type)
    }
    
    /// 初始化实例
    func new() -> OBJC.Object? {
        guard let objc = (type as? NSObject.Type)?.perform(Selector("new"))?.takeRetainedValue() else {
            return nil
        }
        
        return OBJC.Object(value: objc, type: self)
    }
    
}

// MARK: - CustomStringConvertible
extension OBJC.Class: CustomStringConvertible {
    
    public var description: String { return self.name }
    
}

// MARK: - CustomStringConvertible
extension OBJC.Method: CustomStringConvertible {
    
    public var description: String { return method_getName(pointer).description }
    
}

public extension OBJC.Class {
    
    /// 获取方法列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 方法列表
    var methods: [OBJC.Method] {
        return get_list(close: { class_copyMethodList(type, &$0) }, format: { OBJC.Method(value: $0) })
    }
    
    /// 获取属性列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 属性列表
    var properties: [OBJC.Property] {
        return get_list(close: { class_copyPropertyList(type, &$0) }, format: { OBJC.Property(value: $0) })
    }
    
    /// 获取协议列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 协议列表
    var protocols: [Protocol] {
        return get_list(close: { class_copyProtocolList(type, &$0) }, format: { $0 })
    }
    
    /// 成员变量列表
    ///
    /// - Parameter classType: 类型
    /// - Returns: 成员变量
    var ivars: [Ivar] {
        return get_list(close: { class_copyIvarList(type, &$0) }, format: { $0 })
    }
    
}

func get_list<T, U>(close: ( _ outcount: inout UInt32) -> AutoreleasingUnsafeMutablePointer<T>?, format: (T) -> U) -> [U] {
    var outcount: UInt32 = 0
    var list = [U]()
    guard let methods = close(&outcount) else { return [] }
    for index in 0..<Int(outcount) {
        list.append(format(methods[index]))
    }
    return list
}

func get_list<T, U>(close: ( _ outcount: inout UInt32) -> UnsafeMutablePointer<T>?, format: (T) -> U) -> [U] {
    var outcount: UInt32 = 0
    var list = [U]()
    guard let methods = close(&outcount) else { return [] }
    for index in 0..<numericCast(outcount) {
        list.append(format(methods[index]))
    }
    free(methods)
    return list
}
