//
//  PopGesture+nav.swift
//  Pods-PopGesture_Example
//
//  Created by linhey on 2018/1/17.
//

import UIKit

extension Stem where Base: UINavigationController {
    
    
    var popGesture: UIPanGestureRecognizer {
        get {
            if let value = self.getAssociated(associatedKey: UINavigationController.PopGesKey.popGesture) as UIPanGestureRecognizer? { return value }
            let pan = UIPanGestureRecognizer()
            pan.maximumNumberOfTouches = 1
            self.popGesture = pan
            return pan
        }
        set {
            self.setAssociated(value: newValue, associatedKey: UINavigationController.PopGesKey.popGesture)
        }
    }
    
    var popGestureDelegate: PopGestureRecognizerDelegate {
        get {
            if let value = self.getAssociated(associatedKey: UINavigationController.PopGesKey.popGestureDelegate) as PopGestureRecognizerDelegate? { return value }
            let delegate = PopGestureRecognizerDelegate()
            delegate.navigationController = base
            self.popGestureDelegate = delegate
            return delegate
        }
        set {
            self.setAssociated(value: newValue, associatedKey: UINavigationController.PopGesKey.popGestureDelegate)
        }
    }
    
    var appearanceEnabled: Bool {
        get {
            if let value =  self.getAssociated(associatedKey: UINavigationController.PopGesKey.appearanceEnabled) as Bool? { return value }
            self.appearanceEnabled = true
            return true
        }
        set {
            self.setAssociated(value: newValue, associatedKey: UINavigationController.PopGesKey.appearanceEnabled)
        }
    }
    
    
}

extension UINavigationController {
    
    fileprivate struct PopGesKey {
        static let popGesture         = UnsafeRawPointer(bitPattern:"stem.popGesture.navigationController.popGesture".hashValue)!
        static let popGestureDelegate = UnsafeRawPointer(bitPattern:"stem.popGesture.navigationController.popGestureDelegate".hashValue)!
        static let appearanceEnabled  = UnsafeRawPointer(bitPattern:"stem.popGesture.navigationController.appearanceEnabled".hashValue)!
    }
    
    
    @objc open func stem_popGesture_pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let gestureRecognizers = interactivePopGestureRecognizer?.view?.gestureRecognizers else {
            saveVCNavState(vc: viewController)
            stem_popGesture_pushViewController(viewController,animated: animated)
            return
        }
        
        if !gestureRecognizers.contains(st.popGesture) {
            self.interactivePopGestureRecognizer?.view?.addGestureRecognizer(st.popGesture)
            let targets = interactivePopGestureRecognizer?.value(forKey: "targets") as! [NSObject]
            let target = targets.first?.value(forKey: "target") as! NSObject
            let action = NSSelectorFromString("handleNavigationTransition:")
            st.popGesture.delegate = st.popGestureDelegate
            st.popGesture.addTarget(target, action: action)
            interactivePopGestureRecognizer?.isEnabled = false
        }
        
        saveVCNavState(vc: viewController)
        if !viewControllers.contains(viewController) {
            stem_popGesture_pushViewController(viewController, animated: animated)
        }
    }
    
    
    func saveVCNavState(vc: UIViewController) {
        if !st.appearanceEnabled { return }
        
        let closure: ((_ vc: UIViewController,_ animated: Bool) -> ()) = {[weak self]  (_ vc: UIViewController, _ animated: Bool) in
            guard let base = self else { return }
            base.setNavigationBarHidden(vc.st.isSetNavHidden, animated: animated)
        }
        vc.st.popGestureClosure = closure
        guard let disappearingViewController = viewControllers.last,
            disappearingViewController.st.popGestureClosure == nil else { return }
        disappearingViewController.st.popGestureClosure = closure
    }
    
}
