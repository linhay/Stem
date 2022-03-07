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

#if canImport(UIKit)
import UIKit

// MARK: - UITableView
public extension Stem where Base: UITableView {
    
    /// 注册 `LoadViewProtocol` 类型的 UITableViewCell
    ///
    /// - Parameter cell: UITableViewCell
    func registers(_ views: LoadViewProtocol.Type...) {
        views.forEach { (item) in
            if let nib = item.nib {
                switch item {
                case is UITableViewCell.Type:
                    base.register(nib, forCellReuseIdentifier: item.identifier)
                case is UITableViewHeaderFooterView.Type:
                    base.register(nib, forHeaderFooterViewReuseIdentifier: item.identifier)
                default:
                    break
                }
            } else {
                switch item {
                case is UITableViewCell.Type:
                    base.register(item, forCellReuseIdentifier: item.identifier)
                case is UITableViewHeaderFooterView.Type:
                    base.register(item, forHeaderFooterViewReuseIdentifier: item.identifier)
                default:
                    break
                }
            }
        }
    }
    
    /// 注册 `LoadViewProtocol` 类型的 UITableViewCell
    ///
    /// - Parameter cell: UITableViewCell
    func register<T: UITableViewCell>(_ cell: T.Type) where T: LoadViewProtocol {
        if let nib = T.nib {
            base.register(nib, forCellReuseIdentifier: T.identifier)
        } else {
            base.register(T.self, forCellReuseIdentifier: T.identifier)
        }
    }

    /// 注册 `LoadViewProtocol` 类型的 UITableViewHeaderFooterView
    ///
    /// - Parameter _: UITableViewHeaderFooterView
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: LoadViewProtocol {
        if let nib = T.nib {
            base.register(nib, forHeaderFooterViewReuseIdentifier: T.identifier)
        } else {
            base.register(T.self, forHeaderFooterViewReuseIdentifier: T.identifier)
        }
    }
    
    /// 从缓存池取出 Cell
    ///
    /// - Parameter indexPath: IndexPath
    /// - Returns: 具体类型的 `UITableViewCell`
    func dequeue<T: LoadViewProtocol>(at indexPath: IndexPath) -> T {
        if let cell = base.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T {
            return cell
        }
        assertionFailure(String(describing: T.self))
        return base.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
    /// 从缓存池取出 UITableViewHeaderFooterView
    ///
    /// - Returns: 具体类型的 `UITableViewCell`
    func dequeue<T: UITableViewHeaderFooterView>() -> T where T: LoadViewProtocol {
        return base.dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as! T
    }
}

public extension Stem where Base: UICollectionView {
    
    /// 注册 `LoadViewProtocol` 类型的 UICollectionViewCell
    ///
    /// - Parameter cell: UICollectionViewCell
    func register<T: UICollectionViewCell>(_ cell: T.Type) where T: LoadViewProtocol {
        if let nib = T.nib {
            base.register(nib, forCellWithReuseIdentifier: T.identifier)
        } else {
            base.register(T.self, forCellWithReuseIdentifier: T.identifier)
        }
    }

    func register<T: UICollectionReusableView>(_ view: T.Type, for kind: SupplementaryViewKindType) where T: LoadViewProtocol {
        if let nib = T.nib {
            base.register(nib, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: T.identifier)
        } else {
            base.register(T.self, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: T.identifier)
        }
    }
    
    /// 从缓存池取出 Cell
    ///
    /// - Parameter indexPath: IndexPath
    /// - Returns: 具体类型的 `UICollectionViewCell`
    func dequeue<T: UICollectionViewCell>(at indexPath: IndexPath) -> T where T: LoadViewProtocol {
        return base.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func dequeue<T: UICollectionReusableView>(at indexPath: IndexPath, kind: SupplementaryViewKindType) -> T where T: LoadViewProtocol {
        return base.dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
}

public extension Stem where Base: UICollectionViewLayout {
    
    func register(_ view: (UICollectionReusableView & LoadViewProtocol).Type) {
        if let nib = view.nib {
            base.register(nib, forDecorationViewOfKind: view.identifier)
        } else {
            base.register(view.self, forDecorationViewOfKind: view.identifier)
        }
    }
    
     func layoutAttributesForSupplementaryView(ofKind kind: SupplementaryViewKindType, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        base.layoutAttributesForSupplementaryView(ofKind: kind.rawValue, at: indexPath)
    }

     func layoutAttributesForDecorationView(ofKind kind: (UICollectionReusableView & LoadViewProtocol).Type, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        base.layoutAttributesForDecorationView(ofKind: kind.identifier, at: indexPath)
    }
    
}

#endif
