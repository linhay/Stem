/// MIT License
///
/// Copyright (c) 2020 linhey
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.

/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import UIKit

private enum AssociatedKey {

    static let setNavigationBarHiddenWhenAppearKey = UnsafeRawPointer(bitPattern: "stem.viewController.setNavigationBarHiddenWhenAppearKey".hashValue)!

}

fileprivate extension UIViewController {

    static let swizzing: Void = {
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
