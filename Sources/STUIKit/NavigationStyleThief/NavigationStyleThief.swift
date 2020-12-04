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

protocol NavigationStyleThiefProtocol: UIViewController {
    
    /// 修复 UIScrollView 应为 navigationBar 的 isTranslucent 由 true 到 false 引起的位置偏移
    var recoverRecordScrollView: UIScrollView? { get }
    
}

extension NavigationStyleThiefProtocol {

    var recoverManager: NavigationStyleThiefManager {
        if let recoverManager = recoverNavigationManager {
            return recoverManager
        } else {
            return NavigationStyleThiefManager.obseve(self)
        }
    }
    
    var recoverRecordScrollView: UIScrollView? { nil }

}

fileprivate extension UINavigationController {
    
    @objc
    func recover_popViewController(animated: Bool) -> UIViewController? {
        let currentVC = recover_popViewController(animated: animated)
        let nextVC    = topViewController

        guard let manager = (currentVC as? NavigationStyleThiefProtocol)?.recoverNavigationManager else {
            return nextVC
        }

        manager.store(for: .current)

        if (nextVC is NavigationStyleThiefProtocol) == false {
            manager.recover(for: .last)
        }

        return nextVC
    }

    @objc
    func recover_pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count == 1,
           let topViewController = topViewController as? NavigationStyleThiefProtocol,
           topViewController.recoverNavigationManager == nil {
            NavigationStyleThiefManager.obseve(topViewController)
        }

        if viewController is NavigationStyleThiefProtocol {
            NavigationStyleThiefManager.obseve(viewController)
        }

        let fromManager = (topViewController as? NavigationStyleThiefProtocol)?.recoverNavigationManager
        let toManager   = (viewController as? NavigationStyleThiefProtocol)?.recoverNavigationManager

        fromManager?.canChangeStyle = false
        fromManager?.store(for: .current)
        if let from = fromManager, let to = toManager {
            to.store(style: from.style(for: .current), for: .last, with: self)
            if let style = to.style(for: .current) {
                to.recover(style: style, with: self)
            } else {
                to.recover(style: .normal, with: self)
            }
        } else if fromManager == nil, let to = toManager {
            to.store(style: to.style(for: self), for: .last, with: self)
            if let style = to.style(for: .current) {
                to.recover(style: style, with: self)
            } else {
                to.recover(style: .normal, with: self)
            }
        } else if let from = fromManager, toManager == nil {
            viewController.isFromNavigationManager = true
            from.recover(style: .normal, with: self)
        }

        recover_pushViewController(viewController, animated: animated)
        fromManager?.canChangeStyle = true
    }

}

fileprivate extension UIViewController {

    var isFromNavigationManager: Bool {
        set {
            objc_setAssociatedObject(self,
                                     NavigationStyleThiefManager.AssociatedKey.isFromNavigationManager,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, NavigationStyleThiefManager.AssociatedKey.isFromNavigationManager) as? Bool ?? false
        }
    }

    var recoverNavigationManager: NavigationStyleThiefManager? {
        set {
            objc_setAssociatedObject(self,
                                     NavigationStyleThiefManager.AssociatedKey.navigationManager,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, NavigationStyleThiefManager.AssociatedKey.navigationManager) as? NavigationStyleThiefManager
        }
    }
    
    var recordScrollOffsetManager: NavigationStyleThiefRecordScrollOffsetManager? {
        set {
            objc_setAssociatedObject(self,
                                     NavigationStyleThiefManager.AssociatedKey.recordScrollManager,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, NavigationStyleThiefManager.AssociatedKey.recordScrollManager) as? NavigationStyleThiefRecordScrollOffsetManager
        }
    }
    
    @objc
    func recover_viewWillAppear(_ animated: Bool) {
        guard let manager = recoverNavigationManager else {
            if isFromNavigationManager {
                NavigationStyleThiefManager.recover(style: .normal, with: navigationController)
            }
            recover_viewWillAppear(animated)
            return
        }

        manager.recover(for: .current)
        recover_viewWillAppear(animated)
        
        if let manager = recordScrollOffsetManager {
            manager.willAppear()
        } else if let vcProtocol = self as? NavigationStyleThiefProtocol, let scrollView = vcProtocol.recoverRecordScrollView {
            let recordManager = NavigationStyleThiefRecordScrollOffsetManager(recoverManager: manager, scrollView: scrollView)
            recordManager?.willAppear()
            recordScrollOffsetManager = recordManager
        }
    }
    
    @objc
    func recover_viewWillDisappear(_ animated: Bool) {
        recordScrollOffsetManager?.willDisappear()
        self.recover_viewWillDisappear(animated)
    }
    
    @objc
    func recover_viewLayoutMarginsDidChange() {
        self.recover_viewLayoutMarginsDidChange()
        recordScrollOffsetManager?.layoutMarginsDidChange(view: view)
    }
}

private class NavigationStyleThiefRecordScrollOffsetManager {
    
    private var enableRecord: Bool = false
    private var offset: CGFloat
    private var token: NSKeyValueObservation?
    private weak var scrollView: UIScrollView?
    var recoverManager: NavigationStyleThiefManager

    init?(recoverManager: NavigationStyleThiefManager, scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return nil
        }
        self.scrollView = scrollView
        self.enableRecord = true
        self.offset = scrollView.contentOffset.y
        self.recoverManager = recoverManager
        self.observe(scrollView: scrollView)
    }
    
    private func observe(scrollView: UIScrollView) {
        token?.invalidate()
        token = scrollView.observe(\.contentOffset, options: [.new], changeHandler: { [weak self] (_, result) in
            guard let self = self, self.recoverManager.canChangeStyle, self.enableRecord, let y = result.newValue?.y else {
                return
            }
            self.offset = y
        })
    }
    
    func willAppear() {
        self.enableRecord = true
    }
    
    func willDisappear() {
        enableRecord = false
    }
    
    func layoutMarginsDidChange(view: UIView) {
        let safeTopInset = view.safeAreaInsets.top
        let bestSafeTopInset = UIApplication.shared.statusBarFrame.height + 44
        let different = bestSafeTopInset - safeTopInset + offset
        scrollView?.setContentOffset(.init(x: 0, y: different), animated: false)
    }
    
}

class NavigationStyleThiefManager {
    
    fileprivate enum AssociatedKey {
        static let navigationManager       = UnsafeRawPointer(bitPattern: "recover.key.navigationManager".hashValue)!
        static let recordScrollManager     = UnsafeRawPointer(bitPattern: "recover.key.recordScrollManager".hashValue)!
        static let isFromNavigationManager = UnsafeRawPointer(bitPattern: "recover.key.isFromNavigationManager".hashValue)!
    }
    
    fileprivate(set) var canChangeStyle = true
    private weak var viewController: UIViewController?
    private weak var storedNavigationController: UINavigationController?

    enum StoreType: Int {
        /// 上个界面
        case last
        /// 当前界面
        case current
    }

    class Style {
        var isTranslucent: Bool = false
        var barStyle: UIBarStyle = .default
        var barTintColor: UIColor?
        var tintColor: UIColor?
        var shadowImage: UIImage?
        var backgroundImage: UIImage?
        var isHidden: Bool = false
        var titleTextAttributes: [NSAttributedString.Key : Any]?
        static var normal: Style {
            let style = Style()
            style.isTranslucent   = UINavigationBar.appearance().isTranslucent
            style.barStyle        = UINavigationBar.appearance().barStyle
            style.barTintColor    = UINavigationBar.appearance().barTintColor
            style.tintColor       = UINavigationBar.appearance().tintColor
            style.shadowImage     = UINavigationBar.appearance().shadowImage
            style.backgroundImage = UINavigationBar.appearance().backgroundImage(for: .default)
            style.titleTextAttributes = UINavigationBar.appearance().titleTextAttributes
            return style
        }
    }

    private var styles = [StoreType: Style]()

    private var storeBlock: (() -> Void)?

    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

}

extension NavigationStyleThiefManager {

    private static let swizzing: Void = {
        RunTime.exchange(selector: #selector(UIViewController.viewWillAppear(_:)),
                         by: #selector(UIViewController.recover_viewWillAppear(_:)),
                         class: UIViewController.self)
        RunTime.exchange(selector: #selector(UIViewController.viewLayoutMarginsDidChange),
                         by: #selector(UIViewController.recover_viewLayoutMarginsDidChange),
                         class: UIViewController.self)
        RunTime.exchange(selector: #selector(UIViewController.viewWillDisappear(_:)),
                         by: #selector(UIViewController.recover_viewWillDisappear(_:)),
                         class: UIViewController.self)
        RunTime.exchange(selector: #selector(UINavigationController.pushViewController(_:animated:)),
                         by: #selector(UINavigationController.recover_pushViewController(_:animated:)),
                         class: UINavigationController.self)
        RunTime.exchange(selector: #selector(UINavigationController.popViewController(animated:)),
                         by: #selector(UINavigationController.recover_popViewController(animated:)),
                         class: UINavigationController.self)
    }()

    static func begin() {
        _ = swizzing
    }

    @discardableResult
    static func obseve(_ viewController: UIViewController) -> NavigationStyleThiefManager {
        _ = Self.swizzing
        let manager = NavigationStyleThiefManager(viewController: viewController)
        viewController.recoverNavigationManager = manager
        return manager
    }

}

extension NavigationStyleThiefManager {

    fileprivate func style(for type: StoreType) -> Style? {
        return self.styles[type]
    }

    fileprivate func style(for navigationController: UINavigationController) -> Style {
        let navigationBar = navigationController.navigationBar
        let style = Style()
        style.isHidden        = navigationController.isNavigationBarHidden
        style.isTranslucent   = navigationBar.isTranslucent
        style.barStyle        = navigationBar.barStyle
        style.barTintColor    = navigationBar.barTintColor
        style.tintColor       = navigationBar.tintColor
        style.shadowImage     = navigationBar.shadowImage
        style.backgroundImage = navigationBar.backgroundImage(for: .default)
        style.titleTextAttributes = navigationBar.titleTextAttributes
        return style
    }

    func store(style: Style?, for type: StoreType, with navigationController: UINavigationController) {
        storedNavigationController = navigationController
        self.styles[type] = style
    }

    func store(for type: StoreType) {
        if type == .last, self.styles[.last] != nil {
            return
        }

        guard let navigationController = viewController?.navigationController else {
            return
        }

        store(style: style(for: navigationController), for: type, with: navigationController)
    }

    func recover(style: Style, with navigationController: UINavigationController?) {
        Self.recover(style: style, with: navigationController)
    }

    static func recover(style: Style, with navigationController: UINavigationController?) {
        guard let navigationController = navigationController else {
            return
        }

        let navigationBar = navigationController.navigationBar
        navigationBar.isTranslucent = style.isTranslucent
        navigationBar.barStyle      = style.barStyle
        navigationBar.barTintColor  = style.barTintColor
        navigationBar.tintColor     = style.tintColor
        navigationBar.shadowImage   = style.shadowImage
        navigationBar.titleTextAttributes = style.titleTextAttributes
        navigationController.setNavigationBarHidden(style.isHidden, animated: false)
        navigationBar.setBackgroundImage(style.backgroundImage, for: .default)
    }

    func recover(for type: StoreType) {
        guard let navigationController = storedNavigationController else {
            return
        }

        guard let style = style(for: type) else {
            return
        }

        recover(style: style, with: navigationController)
    }

}

#endif
