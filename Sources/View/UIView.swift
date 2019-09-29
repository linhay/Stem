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

// MARK: - UIView 属性扩展
public extension Stem where Base: UIView {
    
    /** 返回视图所在的视图控制器
     
     示例:
     
     ```
     let vc = UIView().st.viewController
     ```
     
     */
    var viewController: UIViewController? {
        var next: UIView? = base
        repeat {
            if let vc = next?.next as? UIViewController { return vc }
            next = next?.superview
        } while next != nil
        return nil
    }
    /// 惰性查询父视图
    ///
    /// - Parameter where: 条件
    /// - Returns: 父视图
    func first(superview `where`: (_: UIView) -> Bool) -> UIView? {
        var view: UIView = base
        while let superview = view.superview {
            if `where`(superview) { return superview }
            view = superview
        }
        return nil
    }
    
    /** 视图中层级关系描述
     
     示例:
     
     ```
     <UIView; frame = (15 74; 345 201); autoresize = RM+BM; layer = <CALayer>>
     | <UIView; frame = (8 8; 185 185); autoresize = RM+BM; layer = <CALayer>>
     |    | <UIView; frame = (8 8; 169 76.5); autoresize = RM+BM; layer = <CALayer>>
     |    |    | <UIButton; frame = (8 8; 153 30); opaque = NO; autoresize = RM+BM; layer = <CALayer>>
     |    | <UIView; frame = (8 100.5; 169 76.5); autoresize = RM+BM; layer = <CALayer>>
     | <UIView; frame = (201 8; 136 185); autoresize = RM+BM; layer = <CALayer>>
     |    | <UILabel; frame = (8 8; 120 21); text = 'Label'; opaque = NO; autoresize = RM+BM; userInteractionEnabled = NO; layer = <_UILabelLayer>
     ```
     
     */
    var description: String {
        let recursiveDescription = base
            .perform(Selector(("recursiveDescription")))?
            .takeUnretainedValue() as! String
        return recursiveDescription.replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)",
                                                         with: "$1",
                                                         options: .regularExpression)
    }
    
    /** 获取视图显示内容
     
     示例:
     
     ```
     UIImageView(image: UIView().st.snapshot)
     ```
     */
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        base.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

// MARK: - UIView 函数扩展
public extension Stem where Base: UIView {
    
    func snapshotImage(afterUpdates: Bool) -> UIImage? {
        return base.snapshotView(afterScreenUpdates: afterUpdates)?.st.snapshot
    }
    
    @available(iOS 9.0, *) @discardableResult
    func addLayoutGuides(_ layoutGuides: UILayoutGuide...) -> Stem<Base> {
        layoutGuides.forEach { base.addLayoutGuide($0) }
        return self
    }
    
    @available(iOS 9.0, *) @discardableResult
    func addLayoutGuides(_ layoutGuides: [UILayoutGuide]) -> Stem<Base> {
        layoutGuides.forEach { base.addLayoutGuide($0) }
        return self
    }
    
    /** 添加子控件
     
     示例:
     
     ```
     let aView = UIView()
     let bView = UIView()
     UIView().st.addSubviews(aView,bView)
     ```
     
     - Parameter subviews: 子控件数组
     */
    @discardableResult
    func addSubviews(_ subviews: UIView...) -> Stem<Base> {
        subviews.forEach { base.addSubview($0) }
        return self
    }
    
    @discardableResult
    func addSubviews(_ subviews: [UIView]) -> Stem<Base> {
        subviews.forEach { base.addSubview($0) }
        return self
    }
    
    /// 移除全部子控件
    @discardableResult
    func removeSubviews() -> Stem<Base> {
        base.subviews.forEach { $0.removeFromSuperview() }
        return self
    }
    
    /** 添加子控件
     
     示例:
     
     ```
     let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent(_:)))
     let pan = UIPanGestureRecognizer(target: self, action: #selector(tapEvent(_:)))
     UIView().addGestureRecognizers(tap,pan)
     ```
     
     - Parameter subviews: 手势对象数组
     */
    @discardableResult
    func addGestureRecognizers(_ gestureRecognizers: UIGestureRecognizer...) -> Stem<Base> {
        gestureRecognizers.forEach { base.addGestureRecognizer($0) }
        return self
    }
    
    /// 移除全部手势
    @discardableResult
    func removeGestureRecognizers() -> Stem<Base> {
        base.gestureRecognizers?.forEach { base.removeGestureRecognizer($0) }
        return self
    }
    
}

extension UIView {
    
    fileprivate struct ActionKey {
        static var tap = UnsafeRawPointer(bitPattern: "view.stem.tap".hashValue)!
        static var tapGestureRecognizer = UnsafeRawPointer(bitPattern: "view.stem.tapGestureRecognizer".hashValue)!
        static var pan = UnsafeRawPointer(bitPattern: "view.stem.pan".hashValue)!
        static var panGestureRecognizer = UnsafeRawPointer(bitPattern: "view.stem.panGestureRecognizer".hashValue)!
    }
    
    @objc fileprivate func stem_view_tapGesture_event(ges: UITapGestureRecognizer) {
        self.st.tap?(ges)
    }
    
    @objc fileprivate func stem_view_panGesture_event(ges: UIPanGestureRecognizer) {
        self.st.pan?(ges)
    }
}

// MARK: - UIView: UITapGestureRecognizer
public extension Stem where Base: UIView {
    
    var tapGestureRecognizer: UITapGestureRecognizer? {
        get { return self.getAssociated(associatedKey: UIView.ActionKey.tapGestureRecognizer) }
        set { self.setAssociated(value: newValue, associatedKey: UIView.ActionKey.tapGestureRecognizer) }
    }
    
    fileprivate var tap: ((UITapGestureRecognizer) -> Void)? {
        get { return objc_getAssociatedObject(base, UIView.ActionKey.tap) as? (UITapGestureRecognizer) -> Void }
        set {
            if newValue != nil, tapGestureRecognizer == nil {
                tapGestureRecognizer = UITapGestureRecognizer(target: base, action: #selector(UIView.stem_view_tapGesture_event(ges:)))
                base.addGestureRecognizer(tapGestureRecognizer!)
            }
            
            if newValue == nil, let ges = tapGestureRecognizer {
                base.removeGestureRecognizer(ges)
                tapGestureRecognizer = nil
            }
            
            objc_setAssociatedObject(base, UIView.ActionKey.tap, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    func set(tap: ((UITapGestureRecognizer) -> Void)?) -> Stem<Base> {
        self.tap = tap
        return self
    }
    
}

// MARK: - UIView: UIPanGestureRecognizer
public extension Stem where Base: UIView {
    
    var panGestureRecognizer: UIPanGestureRecognizer? {
        get { return self.getAssociated(associatedKey: UIView.ActionKey.panGestureRecognizer) }
        set { self.setAssociated(value: newValue, associatedKey: UIView.ActionKey.panGestureRecognizer) }
    }
    
    fileprivate var pan: ((UIPanGestureRecognizer) -> Void)? {
        get { return objc_getAssociatedObject(base, UIView.ActionKey.pan) as? (UIPanGestureRecognizer) -> Void }
        set {
            if newValue != nil, panGestureRecognizer == nil {
                panGestureRecognizer = UIPanGestureRecognizer(target: base, action: #selector(UIView.stem_view_panGesture_event(ges:)))
                base.addGestureRecognizer(panGestureRecognizer!)
            }
            
            if newValue == nil, let ges = panGestureRecognizer {
                base.removeGestureRecognizer(ges)
                panGestureRecognizer = nil
            }
            
            objc_setAssociatedObject(base, UIView.ActionKey.pan, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    func set(pan: ((UIPanGestureRecognizer) -> Void)?) -> Stem<Base> {
        self.pan = pan
        return self
    }
    
}
