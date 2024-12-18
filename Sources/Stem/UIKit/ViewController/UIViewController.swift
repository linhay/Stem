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

#if canImport(UIKit)
import UIKit

public extension Stem where Base: UIViewController {
    
    /// 添加子控制器
    ///
    /// - Parameter childs: 子控制器
    @discardableResult
    func addChilds(_ childs: UIViewController...) -> Stem<Base> {
        childs.forEach({base.addChild($0)})
        return self
    }
    
}

// MARK: - navigationController
public extension Stem where Base: UIViewController {
    
    /// 前进至指定控制器
    ///
    /// - Parameters:
    ///   - vc: 指定控制器
    ///   - isRemove: 前进后是否移除当前控制器
    ///   - animated: 是否显示动画
    func push(_ controller: UIViewController?, animated: Bool = true) {
        guard let controller = controller else { return }
        switch base {
        case let item as UINavigationController:
            item.pushViewController(controller, animated: animated)
        case let item as UITabBarController:
            item.selectedViewController?.st.push(controller, animated: animated)
        default:
            base.navigationController?.pushViewController(controller, animated: animated)
        }
    }
    
    /// 后退一层控制器
    ///
    /// - Parameter animated: 是否显示动画
    /// - Returns: vc
    @discardableResult
    func pop(animated: Bool = true) -> UIViewController? {
        switch base {
        case let nav as UINavigationController:
            return nav.popViewController(animated: animated)
        default:
            return base.navigationController?.popViewController(animated: animated)
        }
    }
    
    /// 后退至指定控制器
    ///
    /// - Parameters:
    ///   - vc: 指定控制器
    ///   - animated: 是否显示动画
    /// - Returns: vcs
    @discardableResult
    func pop(_ vc: UIViewController, animated: Bool = true) -> [UIViewController]? {
        switch base {
        case let nav as UINavigationController:
            return nav.popToViewController(vc, animated: animated)
        default:
            return base.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    
    /// 后退至根控制器
    ///
    /// - Parameter animated: 是否显示动画
    /// - Returns: vcs
    @discardableResult
    func pop(toRootVC animated: Bool) -> [UIViewController]? {
        switch base {
        case let nav as UINavigationController:
            return nav.popToRootViewController(animated: animated)
        default:
            return base.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
}

// MARK: - find UIViewController
public extension Stem where Base: UIViewController {
    
    /// 获取当前显示控制器
    static var current: UIViewController? {
        
        guard let rootViewController = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController else {
            return nil
        }
        
        func find(rawVC: UIViewController) -> UIViewController {
            switch rawVC {
            case let vc where vc.presentedViewController != nil:
                return find(rawVC: vc.presentedViewController!)
            case let nav as UINavigationController:
                guard let vc = nav.viewControllers.last else { return rawVC }
                return find(rawVC: vc)
            case let tab as UITabBarController:
                guard let vc = tab.selectedViewController else { return rawVC }
                return find(rawVC: vc)
            default:
                return rawVC
            }
        }
        
        return find(rawVC: rootViewController)
    }
    
}

// MARK: - ivar
public extension Stem where Base: UIViewController {
    
    /// 是否是当前显示控制器
    var isVisible: Bool {
        return base.view.window != nil && base.isViewLoaded && base.presentedViewController == nil
    }
    
}

// MARK: - present
public extension Stem where Base: UIViewController {
    
    /// 能modal的控制器
    static var presented: UIViewController? {
        var vc = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController
        while let temp = vc?.presentedViewController {
            vc = temp
        }
        return vc
    }
    
    /// 当前是控制器是否是被modal出来
    var isByPresented: Bool {
        guard base.presentedViewController == nil else { return false }
        return true
    }
    
    /// modal 指定控制器
    ///
    /// - Parameters:
    ///   - vc: 指定控制器
    ///   - animated: 是否显示动画
    ///   - completion: 完成后事件
    func present(_ vc: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let vc = vc, base.presentedViewController == nil else { return }
        base.present(vc, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
#if targetEnvironment(macCatalyst)
        if let completion = completion {
            base.dismiss(animated: animated, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
                    completion()
                }
            })
        } else {
            base.dismiss(animated: animated, completion: completion)
        }
#else
        base.dismiss(animated: animated, completion: completion)
#endif
    }
    
}
#endif
