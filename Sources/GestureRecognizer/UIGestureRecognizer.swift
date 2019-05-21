//
//  UIGestureRecognizer.swift
//  FBSnapshotTestCase
//
//  Created by linhey on 2019/3/2.
//

import UIKit



fileprivate extension UIGestureRecognizer {

    struct ActionKey {
        static var target = UnsafeRawPointer(bitPattern: "UIGestureRecognizer.target".hashValue)!
    }

    var target: NSObject? {
        get { return objc_getAssociatedObject(self, ActionKey.target) as? NSObject }
        set { objc_setAssociatedObject(self, ActionKey.target, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

}

public extension Stem where Base: UIGestureRecognizer {


    /// 获取当前手势直接作用到的 view
    var targetView: UIView? {
        let location = base.location(in: base.view)
        return base.view?.hitTest(location, with: nil)
    }

    func add(_ action: @escaping ((_: Base) -> Void)) {
        base.target = STGestureTarget<Base>(ges: base, action: action)
    }

}


fileprivate class STGestureTarget<Base: UIGestureRecognizer>: NSObject {

    weak var ges: Base?
    var action: ((_: Base) -> Void)?

    init(ges: Base, action: ((_: Base) -> Void)?) {
        self.ges = ges
        self.action = action
        super.init()
         ges.addTarget(self, action: #selector(event(_:)))
    }

    // MARK: - Action
    @objc func event(_ gestureRecognizer: UIGestureRecognizer) {
        if let ges = ges { action?(ges) }
    }

    deinit {
        print("---")
    }
}
