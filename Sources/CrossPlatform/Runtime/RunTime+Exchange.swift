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

public extension RunTime {
    
    enum MethodKind {
        /// 类方法
        case `class`
        /// 对象方法
        case instance
    }
    
    struct ExchangeMaker {
        /// 所属类型
        let classType: AnyClass
        
        public init(class classType: AnyClass) {
            self.classType = classType
        }
        
        func create(selector: Selector, kind: MethodKind = .instance) -> Exchange {
            return .init(selector: selector, class: classType, kind: kind)
        }
        
    }
    
    struct Exchange {
        
        /// 用于交换的方法
        let selector: Selector
        /// 所属类型
        let classType: AnyClass
        /// 方法类型 | [类方法 | 对象方法]
        let kind: MethodKind
        
        public init(selector: Selector, class classType: AnyClass, kind: MethodKind = .instance) {
            self.selector = selector
            self.classType = classType
            self.kind = kind
        }
        
        var type: AnyClass? {
            switch kind {
            case .instance:
                return classType
            case .class:
                return object_getClass(classType)
            }
        }
        
        var method: Method? {
            switch kind {
            case .instance:
                return class_getInstanceMethod(classType, selector)
            case .class:
                return class_getClassMethod(classType, selector)
            }
}
        
    }
    
    static func exchange(new swizzled: Exchange, with original: Exchange) {
        guard let classType = original.type else {
            assertionFailure("Runtime: 无法查询到类 \(original.classType)")
            return
        }
        
        guard let method = swizzled.method else {
            assertionFailure("Runtime: 在类: \(swizzled.classType) 中无法取得对应方法: \(swizzled.selector.description)")
            return
        }
        
        guard let newMethod = original.method else {
            assertionFailure("Runtime: 在类: \(original.classType) 中无法取得对应方法: \(original.selector.description)")
            return
        }
        
        if class_addMethod(classType, original.selector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) {
            class_replaceMethod(classType, swizzled.selector, method_getImplementation(method), method_getTypeEncoding(method))
        } else {
            method_exchangeImplementations(method, newMethod)
        }
    }
    
}
