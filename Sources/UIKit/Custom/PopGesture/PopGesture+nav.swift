//
//  Stem
//
//  github: https://github.com/linhay/Stem
//  Copyright (c) 2019 linhay - https://github.com/linhay
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
        static let popGesture         = UnsafeRawPointer(bitPattern: "stem.popGesture.navigationController.popGesture".hashValue)!
        static let popGestureDelegate = UnsafeRawPointer(bitPattern: "stem.popGesture.navigationController.popGestureDelegate".hashValue)!
        static let appearanceEnabled  = UnsafeRawPointer(bitPattern: "stem.popGesture.navigationController.appearanceEnabled".hashValue)!
    }

    @objc open func stem_popGesture_pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let gestureRecognizers = interactivePopGestureRecognizer?.view?.gestureRecognizers else {
            saveVCNavState(vc: viewController)
            stem_popGesture_pushViewController(viewController, animated: animated)
            return
        }
        
        if !gestureRecognizers.contains(st.popGesture) {

            self.interactivePopGestureRecognizer?.view?.addGestureRecognizer(st.popGesture)
            guard let targets: [NSObject] = interactivePopGestureRecognizer?.st.value(for: "targets"),
            let target: NSObject = targets.first?.st.value(for: "target") else {
                return
            }

            let action = Selector("handleNavigationTransition:")
            st.popGesture.delegate = st.popGestureDelegate
            st.popGesture.addTarget(target, action: action)
            interactivePopGestureRecognizer?.isEnabled = false
        }
        
        saveVCNavState(vc: viewController)

        guard !viewControllers.contains(viewController) else { return }
        stem_popGesture_pushViewController(viewController, animated: animated)
    }
    
    func saveVCNavState(vc: UIViewController) {
        if !st.appearanceEnabled { return }
        
        let closure: ((_ vc: UIViewController, _ animated: Bool) -> Void) = {[weak self]  (_ vc: UIViewController, _ animated: Bool) in
            guard let base = self else { return }
            base.setNavigationBarHidden(vc.st.isSetNavHidden, animated: animated)
        }
        vc.st.popGestureClosure = closure
        guard let disappearingViewController = viewControllers.last, disappearingViewController.st.popGestureClosure == nil else { return }
        disappearingViewController.st.popGestureClosure = closure
    }
    
}
