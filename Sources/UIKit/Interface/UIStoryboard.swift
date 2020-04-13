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

import UIKit

// MARK: - convenience init
public extension UIStoryboard {
    
    convenience init(name: String, in bundle: Bundle? = nil) {
        self.init(name: name, bundle: bundle)
    }

    convenience init<T: UIViewController>(vc: T.Type, in bundle: Bundle? = nil) {
        let name = String(describing: T.self)
        self.init(name: name, in: bundle)
    }

}
public extension Stem where Base: UIViewController {

    static var storyboard: UIViewController? {
        let storyboard = UIStoryboard(name: String(describing: Base.self), in: Bundle(for: Base.self))
        let vc = storyboard.instantiateInitialViewController() as? Base
        return vc
    }

}

// MARK: - static Apis
public extension Stem where Base: UIStoryboard {

    static var main: UIStoryboard? {
        guard let name = Bundle.main.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else { return nil }
        return UIStoryboard(name: name, bundle: Bundle.main)
    }

}

// MARK: - ivar Apis
public extension Stem where Base: UIStoryboard {

    var bundle: Bundle? {
        // set{ base.setValue(newValue, forKey: "bundle") }
        return value(for: "bundle")
    }

    var name: String {
        // set{ base.setValue(newValue, forKey: "storyboardFileName") }
        return value(for: "storyboardFileName") as String? ?? ""
    }

    /// 尝试使用 AnyClass 初始化视图控制器
    ///
    /// - Parameter with: 视图控制器类型
    /// - Returns: 视图控制器 | nil
    static func viewController<T: UIViewController>(with: T.Type) -> T? {
        let vcName = String(describing: T.self)
        return UIStoryboard(name: vcName, bundle: nil).st.viewController(with: with)
    }

    /// 尝试使用 AnyClass 初始化视图控制器
    ///
    /// - Parameter with: 视图控制器类型
    /// - Returns: 视图控制器 | nil
    func viewController<T: UIViewController>(with: T.Type) -> T? {
        let vcName = String(describing: T.self)
        if let vc = base.instantiateInitialViewController() as? T { return vc }
        if let vc = base.instantiateViewController(withIdentifier: vcName) as? T { return vc }
        assertionFailure("""
            can't find vc: [\(vcName)]
            in storyboard: [\(base.st.name)]
            in     bundle: [\(base.st.bundle.debugDescription)]
            """)
        return nil
    }

}
