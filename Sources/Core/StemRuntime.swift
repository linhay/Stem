//
//  Stem
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
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

import UIKit

public final class StemRuntime {

    /// 交换方法
    ///
    /// - Parameters:
    ///   - selector: 被交换的方法
    ///   - by: 用于交换的方法
    ///   - classType: 所属类型
    public static func exchange(selector: Selector, by newSelector: Selector, class classType: AnyClass) {
        guard let method = class_getInstanceMethod(classType, selector) else {
            assertionFailure("Runtime: 在类: \(classType) 中无法取得对应方法: \(selector.description)")
            return
        }

        guard let newMethod = class_getInstanceMethod(classType, newSelector) else {
            assertionFailure("Runtime: 在类: \(classType) 中无法取得对应方法: \(newSelector.description)")
            return
        }

        let didAddMethod  = class_addMethod(classType, selector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))
        if didAddMethod {
            class_replaceMethod(classType, newSelector, method_getImplementation(method), method_getTypeEncoding(method))
        } else {
            method_exchangeImplementations(method, newMethod)
        }
    }

}

public extension Stem where Base: NSObject {

    func ivar<T>(for key: String) -> T? {
        guard let ivar = class_getInstanceVariable(type(of: base), key) else { return nil }
        return object_getIvar(base, ivar) as? T
    }

    func setAssociated<T>(value: T, associatedKey: UnsafeRawPointer, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(base, associatedKey, value, policy)
    }

    func getAssociated<T>(associatedKey: UnsafeRawPointer) -> T? {
        let value = objc_getAssociatedObject(base, associatedKey) as? T
        return value
    }

}
