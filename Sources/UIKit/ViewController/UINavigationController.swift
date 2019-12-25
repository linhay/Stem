//
//  UINavigationController.swift
//  Stem-be4603a1
//
//  Created by 林翰 on 2019/12/23.
//

import UIKit

private enum AssociatedKey {

    static let setNavigationBarHiddenWhenAppearKey = UnsafeRawPointer(bitPattern: "stem.viewController.setNavigationBarHiddenWhenAppearKey".hashValue)!

}

fileprivate extension UIViewController {

    static let swizzing = {
        RunTime.exchange(selector: #selector(UIViewController.viewWillAppear(_:)),
                         by: #selector(UIViewController.stem_viewController_viewWillAppear(_:)),
                         class: UIViewController.self)

        RunTime.exchange(selector: #selector(UIViewController.viewWillDisappear(_:)),
                         by: #selector(UIViewController.stem_viewController_viewWillDisappear(_:)),
                         class: UIViewController.self)
    }()

    @objc
    func stem_viewController_viewWillAppear(_ animated: Bool) {
        stem_viewController_viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(st.setNavigationBarHiddenWhenAppear, animated: animated)
    }

    @objc
    func stem_viewController_viewWillDisappear(_ animated: Bool) {
        stem_viewController_viewWillDisappear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) {[weak self] in
            guard let base = self,
                let vc = base.navigationController?.viewControllers.last,
                vc.st.setNavigationBarHiddenWhenAppear == false else { return }
            base.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

}

public extension Stem where Base: UIViewController {

    var setNavigationBarHiddenWhenAppear: Bool {
        get { self.getAssociated(associatedKey: AssociatedKey.setNavigationBarHiddenWhenAppearKey) ?? false }
        set {
            UIViewController.swizzing
            self.setAssociated(value: newValue, associatedKey: AssociatedKey.setNavigationBarHiddenWhenAppearKey)
        }
    }

}
