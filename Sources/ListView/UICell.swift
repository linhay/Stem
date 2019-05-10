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

public protocol STCellProtocol: class {
    static var id: String { get }
    static  var nib: UINib? { get }
}

public extension STCellProtocol {
    static var id: String { return String(describing: Self.self) }
    static  var nib: UINib? { return nil }
}

public protocol STNibProtocol: STCellProtocol { }

public extension STNibProtocol {
    static  var nib: UINib? {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}

// MARK: - UITableView
public extension Stem where Base: UITableView{

    func register<T: UITableViewCell>(_ cell: T.Type) where T: STCellProtocol {
        if let nib = T.nib {
            base.register(nib, forCellReuseIdentifier: T.id)
        } else {
            base.register(T.self, forCellReuseIdentifier: T.id)
        }
    }

    func dequeueCell<T: STCellProtocol>(_ indexPath: IndexPath) -> T {
        return base.dequeueReusableCell(withIdentifier: T.id, for: indexPath) as! T
    }

    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: STCellProtocol {
        if let nib = T.nib {
            base.register(nib, forHeaderFooterViewReuseIdentifier: T.id)
        } else {
            base.register(T.self, forHeaderFooterViewReuseIdentifier: T.id)
        }
    }

    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: STCellProtocol {
        return base.dequeueReusableHeaderFooterView(withIdentifier: T.id) as! T
    }
}

public extension Stem where Base: UICollectionView {

    func register<T: UICollectionViewCell>(_ cell: T.Type) where T: STCellProtocol {
        if let nib = T.nib {
            base.register(nib, forCellWithReuseIdentifier: T.id)
        } else {
            base.register(T.self, forCellWithReuseIdentifier: T.id)
        }
    }

    func dequeueCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T where T: STCellProtocol {
        return base.dequeueReusableCell(withReuseIdentifier: T.id, for: indexPath) as! T
    }

    func registerSupplementaryView<T: STCellProtocol>(elementKind: String, _: T.Type) {
        if let nib = T.nib {
            base.register(nib,
                          forSupplementaryViewOfKind: elementKind,
                          withReuseIdentifier: T.id)
        } else {
            base.register(T.self,
                          forSupplementaryViewOfKind: elementKind,
                          withReuseIdentifier: T.id)
        }
    }

    func dequeueSupplementaryView<T: UIView>(elementKind: String, indexPath: IndexPath) -> T where T: STCellProtocol {
        return base.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                     withReuseIdentifier: T.id,
                                                     for: indexPath) as! T
    }
}
