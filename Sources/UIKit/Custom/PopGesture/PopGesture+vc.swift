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

public extension Stem where Base: UIViewController {
    
    var popGestureMaxLeftEdge: CGFloat {
        get { return self.getAssociated(associatedKey: UIViewController.popGestureKey.maxLeftEdge) ?? 0 }
        set {
            UIViewController.once
            self.setAssociated(value: newValue, associatedKey: UIViewController.popGestureKey.maxLeftEdge)
        }
    }
    
    var isSetNavHidden: Bool {
        get { return self.getAssociated(associatedKey: UIViewController.popGestureKey.isSetNavHidden) ?? false }
        set {
            UIViewController.once
            self.setAssociated(value: newValue, associatedKey: UIViewController.popGestureKey.isSetNavHidden)
        }
    }
    
    var popGestureDisabled: Bool {
        get { return self.getAssociated(associatedKey: UIViewController.popGestureKey.disabled) ?? false }
        set {
            UIViewController.once
            self.setAssociated(value: newValue, associatedKey: UIViewController.popGestureKey.disabled)
        }
    }
    
    internal var popGestureClosure: ((_ vc: UIViewController, _ animated: Bool) -> Void)? {
        get { return self.getAssociated(associatedKey: UIViewController.popGestureKey.closure) }
        set {
            UIViewController.once
            self.setAssociated(value: newValue, associatedKey: UIViewController.popGestureKey.closure)
        }
    }
    
}

extension UIViewController {
    
    fileprivate static let once: Void = {
        RunTime.exchange(selector: #selector(UIViewController.viewWillAppear(_:)),
                             by: #selector(UIViewController.stem_gesture_viewWillAppear(_:)),
                             class: UIViewController.self)
        
        RunTime.exchange(selector: #selector(UIViewController.viewWillDisappear(_:)),
                             by: #selector(UIViewController.stem_gesture_viewWillDisappear(_:)),
                             class: UIViewController.self)
        
        RunTime.exchange(selector: #selector(UINavigationController.pushViewController(_:animated:)),
                             by: #selector(UINavigationController.stem_popGesture_pushViewController(_:animated:)),
                             class: UINavigationController.self)
    }()
    
    fileprivate struct popGestureKey {
        static let closure        = UnsafeRawPointer(bitPattern: "stem.popGesture.viewController.closure".hashValue)!
        static let disabled       = UnsafeRawPointer(bitPattern: "stem.popGesture.viewController.disabled".hashValue)!
        static let maxLeftEdge    = UnsafeRawPointer(bitPattern: "stem.popGesture.viewController.maxLeftEdge".hashValue)!
        static let isSetNavHidden = UnsafeRawPointer(bitPattern: "stem.popGesture.viewController.isSetNavHidden".hashValue)!
    }
    
    @objc private func stem_gesture_viewWillAppear(_ animated: Bool) {
        stem_gesture_viewWillAppear(animated)
        st.popGestureClosure?(self, animated)
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
