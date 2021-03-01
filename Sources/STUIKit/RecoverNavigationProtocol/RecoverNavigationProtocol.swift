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

protocol RecoverNavigationProtocol: UIViewController {
    
    /// 修复 UIScrollView 应为 navigationBar 的 isTranslucent 由 true 到 false 引起的位置偏移
    var recoverRecordScrollView: UIScrollView? { get }
    
}

extension RecoverNavigationProtocol {
    
    var recoverManager: RecoverNavigationManager {
        if let recoverManager = recoverNavigationManager {
            return recoverManager
        } else {
            return RecoverNavigationManager.obseve(self)
        }
    }
    
    var recoverRecordScrollView: UIScrollView? { nil }
    
}

fileprivate extension UINavigationController {
    
    private func willPopAction(_ viewControllers: [UIViewController]?) -> [UIViewController]? {
        guard let manager = viewControllers?.first(where: { ($0 as? RecoverNavigationProtocol) != nil })?.recoverNavigationManager else {
            return viewControllers
        }
        manager.store(for: .current)
        manager.recover(for: .last)
        return viewControllers
    }
    
    @objc
    func recover_setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if let first = viewControllers.first {
            if first is RecoverNavigationProtocol {
                RecoverNavigationManager.obseve(first)
            }
            _ = viewControllers.reduce(first) { (result, next) -> UIViewController in
                if next is RecoverNavigationProtocol {
                    RecoverNavigationManager.obseve(next)
                }
                self.setupStyle(result, next: next, completion: {})
                return next
            }
        }
        
        recover_setViewControllers(viewControllers, animated: animated)
    }
    
    @objc
    func recover_popToRootViewController(animated: Bool) -> [UIViewController]? {
        return willPopAction(recover_popToRootViewController(animated: animated))
    }
    
    @objc
    func recover_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        return willPopAction(recover_popToViewController(viewController, animated: animated))
    }
    
    @objc
    func recover_popViewController(animated: Bool) -> UIViewController? {
        let popVC = recover_popViewController(animated: animated)
        guard let resultVC = popVC else {
            return popVC
        }
        return willPopAction([resultVC])?.first
    }
    
    func setupStyle(_ from: UIViewController?, next: UIViewController, completion: () -> Void) {
        let fromManager = (from as? RecoverNavigationProtocol)?.recoverNavigationManager
        let toManager   = (next as? RecoverNavigationProtocol)?.recoverNavigationManager
        fromManager?.canChangeStyle = false
    
        if let to = toManager {
            if let from = fromManager {
                if from.style(for: .current) == nil {
                    from.store(for: .current)
                }
                to.store(style: from.style(for: .current), for: .last, with: self)
            } else {
                to.store(style: to.style(for: self), for: .last, with: self)
            }
            
            if let style = to.style(for: .current) {
                to.recover(style: style, with: self)
            } else {
                to.recover(style: .normal, with: self)
            }

        } else if let from = fromManager {
            next.isFromNavigationManager = true
            from.store(for: .current)
            from.recover(style: .normal, with: self)
        }
        
        completion()
        fromManager?.canChangeStyle = true
    }
    
    @objc
    func recover_pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let topViewController = topViewController as? RecoverNavigationProtocol {
            RecoverNavigationManager.obseve(topViewController)
        }
        
        if viewController is RecoverNavigationProtocol {
            RecoverNavigationManager.obseve(viewController)
        }
        
        setupStyle(topViewController, next: viewController) { [weak self] in
            self?.recover_pushViewController(viewController, animated: animated)
        }
    }
    
}

fileprivate extension UIViewController {
    
    var isFromNavigationManager: Bool {
        set {
            objc_setAssociatedObject(self,
                                     RecoverNavigationManager.AssociatedKey.isFromNavigationManager,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, RecoverNavigationManager.AssociatedKey.isFromNavigationManager) as? Bool ?? false
        }
    }
    
    var recoverNavigationManager: RecoverNavigationManager? {
        set {
            objc_setAssociatedObject(self,
                                     RecoverNavigationManager.AssociatedKey.navigationManager,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, RecoverNavigationManager.AssociatedKey.navigationManager) as? RecoverNavigationManager
        }
    }
    
    var recordScrollOffsetManager: RecoverRecordScrollOffsetManager? {
        set {
            objc_setAssociatedObject(self,
                                     RecoverNavigationManager.AssociatedKey.recordScrollManager,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, RecoverNavigationManager.AssociatedKey.recordScrollManager) as? RecoverRecordScrollOffsetManager
        }
    }
    
    @objc
    func recover_viewWillAppear(_ animated: Bool) {
        guard let manager = recoverNavigationManager else {
            if isFromNavigationManager {
                RecoverNavigationManager.recover(style: .normal, with: navigationController)
            }
            recover_viewWillAppear(animated)
            return
        }
        
        manager.recover(for: .current)
        recover_viewWillAppear(animated)
        
        if let manager = recordScrollOffsetManager {
            manager.willAppear()
        } else if let vcProtocol = self as? RecoverNavigationProtocol, let scrollView = vcProtocol.recoverRecordScrollView {
            let recordManager = RecoverRecordScrollOffsetManager(recoverManager: manager, scrollView: scrollView)
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

private class RecoverRecordScrollOffsetManager {
    
    private var enableRecord: Bool = false
    private var offset: CGFloat
    private var token: NSKeyValueObservation?
    private weak var scrollView: UIScrollView?
    var recoverManager: RecoverNavigationManager
    
    init?(recoverManager: RecoverNavigationManager, scrollView: UIScrollView?) {
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

class RecoverNavigationManager {
    
    fileprivate enum AssociatedKey {
        static let navigationManager       = UnsafeRawPointer(bitPattern: "recover.key.navigationManager".hashValue)!
        static let recordScrollManager     = UnsafeRawPointer(bitPattern: "recover.key.recordScrollManager".hashValue)!
        static let isFromNavigationManager = UnsafeRawPointer(bitPattern: "recover.key.isFromNavigationManager".hashValue)!
    }
    
    private var titleLabel: UILabel!
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
        var titleTextAttributes: [NSAttributedString.Key: Any]?
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

extension RecoverNavigationManager {
    
    private static let swizzing: Void = {
        let maker1 = RunTime.ExchangeMaker(class: UIViewController.self)
        let maker2 = RunTime.ExchangeMaker(class: UINavigationController.self)
        [
            [
                maker1.create(selector: #selector(UIViewController.recover_viewWillAppear(_:))),
                maker1.create(selector: #selector(UIViewController.viewWillAppear(_:))),
            ],
            [
                maker1.create(selector: #selector(UIViewController.recover_viewLayoutMarginsDidChange)),
                maker1.create(selector: #selector(UIViewController.viewLayoutMarginsDidChange)),
            ],
            [
                maker1.create(selector: #selector(UIViewController.recover_viewWillDisappear(_:))),
                maker1.create(selector: #selector(UIViewController.viewWillDisappear(_:))),
            ],
            [
                maker2.create(selector: #selector(UINavigationController.recover_setViewControllers(_:animated:))),
                maker2.create(selector: #selector(UINavigationController.setViewControllers(_:animated:))),
            ],
            [
                maker2.create(selector: #selector(UINavigationController.recover_pushViewController(_:animated:))),
                maker2.create(selector: #selector(UINavigationController.pushViewController(_:animated:))),
            ],
            [
                maker2.create(selector: #selector(UINavigationController.recover_popViewController(animated:))),
                maker2.create(selector: #selector(UINavigationController.popViewController(animated:))),
            ],
            [
                maker2.create(selector: #selector(UINavigationController.recover_popToViewController(_:animated:))),
                maker2.create(selector: #selector(UINavigationController.popToViewController(_:animated:))),
            ],
            [
                maker2.create(selector: #selector(UINavigationController.recover_popToRootViewController(animated:))),
                maker2.create(selector: #selector(UINavigationController.popToRootViewController(animated:))),
            ],
        ]
        .forEach({ RunTime.exchange(new: $0.first!, with: $0.last!) })
    }()
    
    static func begin() {
        _ = swizzing
    }
    
    @discardableResult
    static func obseve(_ viewController: UIViewController) -> RecoverNavigationManager {
        if let manager = viewController.recoverNavigationManager {
            return manager
        }
        _ = Self.swizzing
        let manager = RecoverNavigationManager(viewController: viewController)
        viewController.recoverNavigationManager = manager
        return manager
    }
    
}

extension RecoverNavigationManager {
    
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
