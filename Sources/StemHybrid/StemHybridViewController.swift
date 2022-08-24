//
//  StemHybridViewController.swift
//  
//
//  Created by linhey on 2022/8/3.
//

#if canImport(UIKit)
import UIKit

open class StemHybridViewController: UIViewController {
    
    public private(set) lazy var webView: StemHybridWebView = {
        let item = createWebView()
        return item
    }()

    private var titleObservation: NSKeyValueObservation?

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    open func createWebView() -> StemHybridWebView {
        return StemHybridWebView(frame: .zero, configuration: StemHybridConfiguration())
    }

}

public extension StemHybridViewController {
    
    /// 监听 webView Title 变化
    func obserseTitle<T>(_ keyPath: ReferenceWritableKeyPath<T, String?>, for object: T, placeholder: String? = nil) {
        obserse(title: { item in
            object[keyPath: keyPath] = item
        }, placeholder: placeholder)
    }
    
    /// 监听 webView Title 变化
    func obserseTitle<T: AnyObject>(_ keyPath: ReferenceWritableKeyPath<T, String?>, for object: T, placeholder: String? = nil) {
        obserse(title: { [weak object] item in
            object?[keyPath: keyPath] = item
        }, placeholder: placeholder)
    }
    
    /// 监听 webView Title 变化
    /// - Parameters:
    ///   - title: Title 变更回调
    ///   - placeholder: Title == nil 时占位文本
    func obserse(title: ((String) -> Void)?, placeholder: String? = nil) {
        titleObservation?.invalidate()
        titleObservation = nil
        guard let title = title else {
            return
        }
        titleObservation = webView.observe(\.title) { webview, _ in
            title(webview.title ?? placeholder ?? "")
        }
        
        title(webView.title ?? placeholder ?? "")
    }
    
}

private extension StemHybridViewController {
    
    func setupUI() {
        view.addSubview(webView)
        let safeArea = view.safeAreaLayoutGuide
        webView.translatesAutoresizingMaskIntoConstraints = false
        layout(anchor1: webView.topAnchor, anchor2: safeArea.topAnchor)
        layout(anchor1: webView.bottomAnchor, anchor2: view.bottomAnchor)
        layout(anchor1: webView.rightAnchor, anchor2: safeArea.rightAnchor)
        layout(anchor1: webView.leftAnchor, anchor2: safeArea.leftAnchor)
    }
    
    func layout(anchor1: NSLayoutYAxisAnchor, anchor2: NSLayoutYAxisAnchor) {
        let constraint = anchor1.constraint(equalTo: anchor2)
        constraint.priority = .defaultLow
        constraint.isActive = true
    }
    
    func layout(anchor1: NSLayoutXAxisAnchor, anchor2: NSLayoutXAxisAnchor) {
        let constraint = anchor1.constraint(equalTo: anchor2)
        constraint.priority = .defaultLow
        constraint.isActive = true
    }
    
}
#endif
