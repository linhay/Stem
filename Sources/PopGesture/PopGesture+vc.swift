//
//  PopGesture+vc.swift
//  Pods-PopGesture_Example
//
//  Created by linhey on 2018/1/17.
//

import UIKit

public extension Stem where Base: UIViewController {

    var popGestureMaxLeftEdge: CGFloat {
        get{ return self.getAssociated(associatedKey: UIViewController.popGestureKey.maxLeftEdge) ?? 0 }
        set{
            UIViewController.once
            self.setAssociated(value: newValue, associatedKey: UIViewController.popGestureKey.maxLeftEdge)
        }
    }

    var isSetNavHidden: Bool {
        get{ return self.getAssociated(associatedKey: UIViewController.popGestureKey.isSetNavHidden) ?? false }
        set{
            UIViewController.once
            self.setAssociated(value: newValue, associatedKey: UIViewController.popGestureKey.isSetNavHidden)
        }
    }

    var popGestureDisabled: Bool {
        get{ return self.getAssociated(associatedKey: UIViewController.popGestureKey.disabled) ?? false }
        set{
            UIViewController.once
            self.setAssociated(value: newValue, associatedKey: UIViewController.popGestureKey.disabled)
        }
    }

    internal var popGestureClosure: ((_ vc: UIViewController,_ animated: Bool) -> ())? {
        get{ return self.getAssociated(associatedKey: UIViewController.popGestureKey.closure) }
        set{
            UIViewController.once
            self.setAssociated(value: newValue, associatedKey: UIViewController.popGestureKey.closure)
        }
    }

}

extension UIViewController {

    fileprivate static let once: Void = {
        StemRuntime.exchangeMethod(selector: #selector(UIViewController.viewWillAppear(_:)),
                                   replace: #selector(UIViewController.stem_gesture_viewWillAppear(_:)),
                                   class: UIViewController.self)

        StemRuntime.exchangeMethod(selector: #selector(UIViewController.viewWillDisappear(_:)),
                                   replace: #selector(UIViewController.stem_gesture_viewWillDisappear(_:)),
                                   class: UIViewController.self)

        StemRuntime.exchangeMethod(selector: #selector(UINavigationController.pushViewController(_:animated:)),
                                   replace: #selector(UINavigationController.stem_popGesture_pushViewController(_:animated:)),
                                   class: UINavigationController.self)
    }()

    fileprivate struct popGestureKey {
        static let closure        = UnsafeRawPointer(bitPattern:"stem.popGesture.viewController.closure".hashValue)!
        static let disabled       = UnsafeRawPointer(bitPattern:"stem.popGesture.viewController.disabled".hashValue)!
        static let maxLeftEdge    = UnsafeRawPointer(bitPattern:"stem.popGesture.viewController.maxLeftEdge".hashValue)!
        static let isSetNavHidden = UnsafeRawPointer(bitPattern:"stem.popGesture.viewController.isSetNavHidden".hashValue)!
    }

    @objc private func stem_gesture_viewWillAppear(_ animated: Bool){
        stem_gesture_viewWillAppear(animated)
        st.popGestureClosure?(self,animated)
    }

    @objc private func stem_gesture_viewWillDisappear(_ animated: Bool) {
        stem_gesture_viewWillDisappear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) {[weak self] in
            guard let base = self,
                let vc = base.navigationController?.viewControllers.last,
                !vc.st.isSetNavHidden else { return }
            base.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

}









