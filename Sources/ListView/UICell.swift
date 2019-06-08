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
    
    /// 注册 `STCellProtocol` 类型的 UITableViewCell
    ///
    /// - Parameter cell: UITableViewCell
    func register<T: UITableViewCell>(_ cell: T.Type) where T: STCellProtocol {
        if let nib = T.nib {
            base.register(nib, forCellReuseIdentifier: T.id)
        } else {
            base.register(T.self, forCellReuseIdentifier: T.id)
        }
    }
    
    /// 从缓存池取出 Cell
    ///
    /// - Parameter indexPath: IndexPath
    /// - Returns: 具体类型的 `UITableViewCell`
    func dequeueCell<T: STCellProtocol>(_ indexPath: IndexPath) -> T {
        return base.dequeueReusableCell(withIdentifier: T.id, for: indexPath) as! T
    }
    
    /// 注册 `STCellProtocol` 类型的 UITableViewHeaderFooterView
    ///
    /// - Parameter _: UITableViewHeaderFooterView
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: STCellProtocol {
        if let nib = T.nib {
            base.register(nib, forHeaderFooterViewReuseIdentifier: T.id)
        } else {
            base.register(T.self, forHeaderFooterViewReuseIdentifier: T.id)
        }
    }
    
    /// 从缓存池取出 UITableViewHeaderFooterView
    ///
    /// - Returns: 具体类型的 `UITableViewCell`
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: STCellProtocol {
        return base.dequeueReusableHeaderFooterView(withIdentifier: T.id) as! T
    }
}

public extension UICollectionView {
    
    /// SupplementaryView regist type
    ///
    /// - header: header
    /// - footer: footer
    /// - custom: custom
    enum KindType: Equatable {
        
        case header
        case footer
        case custom(_ value: String)
        
        public var rawValue: String {
            switch self {
            case .header: return UICollectionView.elementKindSectionHeader
            case .footer: return UICollectionView.elementKindSectionFooter
            case .custom(let value): return value
            }
        }
    }
    
}

public extension Stem where Base: UICollectionView {
    
    /// 注册 `STCellProtocol` 类型的 UICollectionViewCell
    ///
    /// - Parameter cell: UICollectionViewCell
    func register<T: UICollectionViewCell>(_ cell: T.Type) where T: STCellProtocol {
        if let nib = T.nib {
            base.register(nib, forCellWithReuseIdentifier: T.id)
        } else {
            base.register(T.self, forCellWithReuseIdentifier: T.id)
        }
    }
    
    /// 从缓存池取出 Cell
    ///
    /// - Parameter indexPath: IndexPath
    /// - Returns: 具体类型的 `UICollectionViewCell`
    func dequeueCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T where T: STCellProtocol {
        return base.dequeueReusableCell(withReuseIdentifier: T.id, for: indexPath) as! T
    }
    
    func registerSupplementaryView<T: STCellProtocol>(kind: UICollectionView.KindType, _ view: T.Type) {
        registerSupplementaryView(elementKind: kind.rawValue, view)
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
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(kind: UICollectionView.KindType, indexPath: IndexPath) -> T where T: STCellProtocol {
        return dequeueSupplementaryView(elementKind: kind.rawValue, indexPath: indexPath)
    }
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(elementKind: String, indexPath: IndexPath) -> T where T: STCellProtocol {
        return base.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                     withReuseIdentifier: T.id,
                                                     for: indexPath) as! T
    }
}
