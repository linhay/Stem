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

import UIKit

public protocol STNavigationThiefProtocol: UIViewController { }

public extension STNavigationThiefProtocol {

    var navigationThiefManager: NavigationThiefManager {
        if let manager = storedNavigationThiefManager {
            return manager
        } else {
            let manager = NavigationThiefManager.obseve(self)
            storedNavigationThiefManager = manager
            return manager
        }
    }

}

extension UIViewController {

    fileprivate var storedNavigationThiefManager: NavigationThiefManager? {
        set {
            objc_setAssociatedObject(self, NavigationThiefManager.AssociatedKey.manager, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, NavigationThiefManager.AssociatedKey.manager) as? NavigationThiefManager
        }
    }

    @objc
    fileprivate func navigationThief_viewDidLoad() {
        navigationThief_viewDidLoad()
        if self is STNavigationThiefProtocol {
            storedNavigationThiefManager = .obseve(self)
        }
    }

    @objc
    fileprivate func navigationThief_viewWillAppear(_ animated: Bool) {
        navigationThief_viewWillAppear(animated)
        guard let manager = storedNavigationThiefManager else {
            return
        }

        if manager.isStoreLast {
            manager.recover(for: .current)
        } else {
            manager.store(for: .last)
        }

    }

    @objc
    fileprivate func navigationThief_viewWillDisappear(_ animated: Bool) {
        navigationThief_viewWillDisappear(animated)
        guard let manager = storedNavigationThiefManager, let navigationController = navigationController else {
            return
        }

        if navigationController.viewControllers.contains(self) {
            // push
            manager.store(for: .current)
            manager.recover(for: .last)
        } else {
            // pop
            manager.recover(for: .last)
        }
    }

}

public class NavigationThiefManager {

    fileprivate enum AssociatedKey {
        static let manager = UnsafeRawPointer(bitPattern: "navigationThiefManager.AssociatedKey".hashValue)!
    }

    private var titleLabel: UILabel!

    private unowned var viewController: UIViewController
    private weak var storedNavigationController: UINavigationController?

    public enum StoreType: Int {
        /// 上个界面
        case last
        /// 当前界面
        case current
    }

    private class Style {
         var isTranslucent: Bool = false
         var barStyle: UIBarStyle = .default
         var barTintColor: UIColor?
         var tintColor: UIColor = .white
         var shadowImage: UIImage?
         var backgroundImage: UIImage?
         var isHidden: Bool = false
    }

    private var styles = [StoreType: Style]()

    fileprivate var isStoreLast: Bool { styles[.last] != nil }
    private var storeBlock: (() -> Void)?

    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

}


public extension NavigationThiefManager {

    static func begin() {
        _ = swizzing
    }

    static func obseve(_ viewController: UIViewController) -> NavigationThiefManager {
        _ = Self.swizzing
        let manager = NavigationThiefManager(viewController: viewController)
        viewController.storedNavigationThiefManager = manager
        return manager
    }

}

public extension NavigationThiefManager {

    /// 修改 navigationBar 样式, 会在保存上一个界面样式之后
    func change(navigationBar block: (() -> Void)?) {
        if isStoreLast {
            block?()
            storeBlock = nil
        } else {
            storeBlock = block
        }
    }

}

public extension NavigationThiefManager {

    /// 缓存样式
    /// - Parameter type: 哪个界面
    func store(for type: StoreType) {
        guard let navigationController = viewController.navigationController else {
            return
        }

        storedNavigationController = navigationController

        let navigationBar = navigationController.navigationBar
        let style = Style()
        style.isHidden        = navigationController.isNavigationBarHidden
        style.isTranslucent   = navigationBar.isTranslucent
        style.barStyle        = navigationBar.barStyle
        style.barTintColor    = navigationBar.barTintColor
        style.tintColor       = navigationBar.tintColor
        style.shadowImage     = navigationBar.shadowImage
        style.backgroundImage = navigationBar.backgroundImage(for: .default)

        styles[type] = style
        switch type {
        case .last:
            change(navigationBar: storeBlock)
        case .current:
            break
        }

    }

    /// 释放样式
    /// - Parameter type: 哪个界面
    func recover(for type: StoreType) {
        guard let navigationController = storedNavigationController, let style = styles[type] else {
            return
        }

        let navigationBar = navigationController.navigationBar

        navigationBar.isTranslucent   = style.isTranslucent
        navigationBar.barStyle        = style.barStyle
        navigationBar.barTintColor    = style.barTintColor
        navigationBar.tintColor       = style.tintColor
        navigationBar.shadowImage     = style.shadowImage
        navigationController.setNavigationBarHidden(style.isHidden, animated: false)
        navigationBar.setBackgroundImage(style.backgroundImage, for: .default)
    }

}


fileprivate extension NavigationThiefManager {

     static let swizzing: Void = {
        RunTime.exchange(selector: #selector(UIViewController.viewWillAppear(_:)),
                         by: #selector(UIViewController.navigationThief_viewWillAppear(_:)),
                         class: UIViewController.self)
        RunTime.exchange(selector: #selector(UIViewController.viewWillDisappear(_:)),
                         by: #selector(UIViewController.navigationThief_viewWillDisappear(_:)),
                         class: UIViewController.self)
        RunTime.exchange(selector: #selector(UIViewController.viewDidLoad),
                         by: #selector(UIViewController.navigationThief_viewDidLoad),
                         class: UIViewController.self)
    }()

}
