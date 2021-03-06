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
    
    /// 注册 `STViewProtocol` 类型的 UITableViewCell
    ///
    /// - Parameter cell: UITableViewCell
    func registers(_ views: STViewProtocol.Type...) {
        views.forEach { (item) in
            if let nib = item.nib {
                switch item {
                case is UITableViewCell.Type:
                    base.register(nib, forCellReuseIdentifier: item.id)
                case is UITableViewHeaderFooterView.Type:
                    base.register(nib, forHeaderFooterViewReuseIdentifier: item.id)
                default:
                    break
                }
            } else {
                switch item {
                case is UITableViewCell.Type:
                    base.register(item, forCellReuseIdentifier: item.id)
                case is UITableViewHeaderFooterView.Type:
                    base.register(item, forHeaderFooterViewReuseIdentifier: item.id)
                default:
                    break
                }
            }
        }
    }
    
    /// 注册 `STViewProtocol` 类型的 UITableViewCell
    ///
    /// - Parameter cell: UITableViewCell
    func register<T: UITableViewCell>(_ cell: T.Type) where T: STViewProtocol {
        if let nib = T.nib {
            base.register(nib, forCellReuseIdentifier: T.id)
        } else {
            base.register(T.self, forCellReuseIdentifier: T.id)
        }
    }

    /// 注册 `STViewProtocol` 类型的 UITableViewHeaderFooterView
    ///
    /// - Parameter _: UITableViewHeaderFooterView
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: STViewProtocol {
        if let nib = T.nib {
            base.register(nib, forHeaderFooterViewReuseIdentifier: T.id)
        } else {
            base.register(T.self, forHeaderFooterViewReuseIdentifier: T.id)
        }
    }
    
    /// 从缓存池取出 Cell
    ///
    /// - Parameter indexPath: IndexPath
    /// - Returns: 具体类型的 `UITableViewCell`
    func dequeue<T: STViewProtocol>(at indexPath: IndexPath) -> T {
        if let cell = base.dequeueReusableCell(withIdentifier: T.id, for: indexPath) as? T {
            return cell
        }
        assertionFailure(String(describing: T.self))
        return base.dequeueReusableCell(withIdentifier: T.id, for: indexPath) as! T
    }
    
    /// 从缓存池取出 UITableViewHeaderFooterView
    ///
    /// - Returns: 具体类型的 `UITableViewCell`
    func dequeue<T: UITableViewHeaderFooterView>() -> T where T: STViewProtocol {
        return base.dequeueReusableHeaderFooterView(withIdentifier: T.id) as! T
    }
}

/// SupplementaryView regist type
///
/// - header: header
/// - footer: footer
/// - custom: custom
public enum SupplementaryViewKindType: Equatable {
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

public extension Stem where Base: UICollectionView {
    
    /// 注册 `STViewProtocol` 类型的 UICollectionViewCell
    ///
    /// - Parameter cell: UICollectionViewCell
    func register<T: UICollectionViewCell>(_ cell: T.Type) where T: STViewProtocol {
        if let nib = T.nib {
            base.register(nib, forCellWithReuseIdentifier: T.id)
        } else {
            base.register(T.self, forCellWithReuseIdentifier: T.id)
        }
    }

    func register<T: UICollectionReusableView>(_ view: T.Type, for kind: SupplementaryViewKindType) where T: STViewProtocol {
        if let nib = T.nib {
            base.register(nib, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: T.id)
        } else {
            base.register(T.self, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: T.id)
        }
    }
    
    /// 从缓存池取出 Cell
    ///
    /// - Parameter indexPath: IndexPath
    /// - Returns: 具体类型的 `UICollectionViewCell`
    func dequeue<T: UICollectionViewCell>(at indexPath: IndexPath) -> T where T: STViewProtocol {
        return base.dequeueReusableCell(withReuseIdentifier: T.id, for: indexPath) as! T
    }
    
    func dequeue<T: UICollectionReusableView>(at indexPath: IndexPath, kind: SupplementaryViewKindType) -> T where T: STViewProtocol {
        return base.dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: T.id, for: indexPath) as! T
    }
    
}

public extension Stem where Base: UICollectionViewLayout {
    
    func register(_ view: (UICollectionReusableView & STViewProtocol).Type) {
        if let nib = view.nib {
            base.register(nib, forDecorationViewOfKind: view.id)
        } else {
            base.register(view.self, forDecorationViewOfKind: view.id)
        }
    }
    
     func layoutAttributesForSupplementaryView(ofKind kind: SupplementaryViewKindType, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        base.layoutAttributesForSupplementaryView(ofKind: kind.rawValue, at: indexPath)
    }

     func layoutAttributesForDecorationView(ofKind kind: (UICollectionReusableView & STViewProtocol).Type, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        base.layoutAttributesForDecorationView(ofKind: kind.id, at: indexPath)
    }
    
}

#endif
