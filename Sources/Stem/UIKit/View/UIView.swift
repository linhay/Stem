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

// MARK: - UIView 属性扩展
public extension Stem where Base: UIView {
    
    /**
     查找 UIView 所在的 UIViewController

     - Authors: linhey
     - Date: 2019/11/20

     - Example:

        ```
        guard let vc = CustomView().dxy.viewController else {
            return
        }

        vc.present(CustomViewController(), animated: true, completion: nil)

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

    /**
     输出视图中层级关系描述

     - Authors: linhey
     - Date: 2019/11/20

     - Example:

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
        return (base.perform(Selector(("recursiveDescription")))?
            .takeUnretainedValue() as! String)
            .replacingOccurrences(of: #":?\s*0x[\da-f]+(\s*)"#, with: "$1", options: .regularExpression)
    }
    
    /**
     生成 UIView 截图

     - Authors: linhey
     - Date: 2019/11/20

     - Example:

        ```
        guard let image = CustomView().dxy.snapshot else {
            return
        }

        let imageView = UIImageView()

        imageView.image = image

        ```

     - Important:

        - # imageSize: 取值于 self.bounds.size

        - # 是否透明: 取决于 self.isOpaque

            * (isOpaque == true) == 完全不透明

            * UIView.isOpaque 默认为 true
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
    
    @available(iOS 9.0, *)
    func addLayoutGuides(_ layoutGuides: UILayoutGuide...) {
        layoutGuides.forEach { base.addLayoutGuide($0) }
    }
    
    @available(iOS 9.0, *)
    func addLayoutGuides(_ layoutGuides: [UILayoutGuide]) {
        layoutGuides.forEach { base.addLayoutGuide($0) }
    }

    /**
     添加 subviews

     - Authors: linhey
     - Date: 2019/11/20

     - Parameter subviews: 子控件数组

     - Example:

     ```

     let aView = UIView()
     let bView = UIView()
     UIView().st.addSubviews(aView,bView)

     ```
     */
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { base.addSubview($0) }
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { base.addSubview($0) }
    }
    
    /// 移除全部子控件
    func removeSubviews() {
        base.subviews.forEach { $0.removeFromSuperview() }
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
    func addGestureRecognizers(_ gestureRecognizers: UIGestureRecognizer...) {
        gestureRecognizers.forEach { base.addGestureRecognizer($0) }
    }
    
    /// 移除全部手势
    func removeGestureRecognizers() {
        base.gestureRecognizers?.forEach { base.removeGestureRecognizer($0) }
    }
    
}

fileprivate extension UIView {
    
    struct ActionKey {
        static var onTapGesture = UnsafeRawPointer(bitPattern: "view.stem.tap".hashValue)!
        static var tapGestureRecognizer = UnsafeRawPointer(bitPattern: "view.stem.tapGestureRecognizer".hashValue)!
        static var pan = UnsafeRawPointer(bitPattern: "view.stem.pan".hashValue)!
        static var panGestureRecognizer = UnsafeRawPointer(bitPattern: "view.stem.panGestureRecognizer".hashValue)!
    }
    
    @objc func stem_view_tapGesture_event(ges: UITapGestureRecognizer) {
        self.st.tapAction?(ges)
    }
    
    @objc func stem_view_panGesture_event(ges: UIPanGestureRecognizer) {
        self.st.pan?(ges)
    }
}

// MARK: - UIView: UITapGestureRecognizer
public extension Stem where Base: UIView {
    
    var tapGestureRecognizer: UITapGestureRecognizer? {
        get { return self.getAssociated(for: UIView.ActionKey.tapGestureRecognizer) }
        set { self.setAssociated(value: newValue, for: UIView.ActionKey.tapGestureRecognizer) }
    }
    
    fileprivate var tapAction: ((UITapGestureRecognizer) -> Void)? {
        get { return self.getAssociated(for: UIView.ActionKey.onTapGesture) }
        set {
            if newValue != nil, tapGestureRecognizer == nil {
                tapGestureRecognizer = UITapGestureRecognizer(target: base, action: #selector(UIView.stem_view_tapGesture_event(ges:)))
                base.addGestureRecognizer(tapGestureRecognizer!)
            }
            
            if newValue == nil, let ges = tapGestureRecognizer {
                base.removeGestureRecognizer(ges)
                tapGestureRecognizer = nil
            }

            self.setAssociated(value: newValue, for: UIView.ActionKey.onTapGesture)
        }
    }
    
    func onTapGesture(_ value: Void?) {
        self.tapAction = nil
    }
    
    func onTapGesture(_ ges: @escaping ((UITapGestureRecognizer) -> Void)) {
        self.tapAction = ges
        base.isUserInteractionEnabled = true
    }

    func onTapGesture(_ ges: @escaping (() -> Void)) {
        self.onTapGesture { _ in ges() }
    }
    
}

// MARK: - UIView: UIPanGestureRecognizer
public extension Stem where Base: UIView {
    
    var panGestureRecognizer: UIPanGestureRecognizer? {
        get { return self.getAssociated(for: UIView.ActionKey.panGestureRecognizer) }
        set { self.setAssociated(value: newValue, for: UIView.ActionKey.panGestureRecognizer) }
    }
    
    fileprivate var pan: ((UIPanGestureRecognizer) -> Void)? {
        get { return self.getAssociated(for: UIView.ActionKey.pan) }
        set {
            if newValue != nil, panGestureRecognizer == nil {
                panGestureRecognizer = UIPanGestureRecognizer(target: base, action: #selector(UIView.stem_view_panGesture_event(ges:)))
                base.addGestureRecognizer(panGestureRecognizer!)
            }
            
            if newValue == nil, let ges = panGestureRecognizer {
                base.removeGestureRecognizer(ges)
                panGestureRecognizer = nil
            }

            self.setAssociated(value: newValue, for: UIView.ActionKey.pan)
        }
    }
    
    func onPanGesture(_ value: Void?) {
        self.tapAction = nil
    }
    
    func onPanGesture(_ ges: @escaping ((UIPanGestureRecognizer) -> Void)) {
        self.pan = ges
        base.isUserInteractionEnabled = true
    }

    func onPanGesture(_ ges: @escaping (() -> Void)) {
        self.onTapGesture { _ in ges() }
    }

}
#endif
