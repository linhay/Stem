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

public extension SectionCollectionDriveProtocol {

    func dequeue<T: UICollectionViewCell & STViewProtocol>(at row: Int) -> T {
        return sectionView.st.dequeue(at: indexPath(from: row))
    }

    func dequeue<T: UICollectionReusableView & STViewProtocol>(kind: SupplementaryViewKindType) -> T {
        return sectionView.st.dequeue(at: indexPath(from: 0), kind: kind)
    }
    
    /// 注册 `LoadViewProtocol` 类型的 UICollectionViewCell
    ///
    /// - Parameter cell: UICollectionViewCell
    func register<T: UICollectionViewCell & STViewProtocol>(_ cell: T.Type) {
        sectionView.st.register(cell)
    }

    func register<T: UICollectionReusableView & STViewProtocol>(_ view: T.Type, for kind: SupplementaryViewKindType) {
        sectionView.st.register(view, for: kind)
    }
    
}

public extension SectionTableProtocol {

    /// 注册 `LoadViewProtocol` 类型的 UICollectionViewCell
    ///
    /// - Parameter cell: UICollectionViewCell
    func register<T: UITableViewCell & STViewProtocol>(_ view: T.Type) {
        sectionView.st.register(view)
    }
    
    /// 从缓存池取出 Cell
    ///
    /// - Parameter indexPath: IndexPath
    /// - Returns: 具体类型的 `UITableViewCell`
    func dequeue<T: STViewProtocol>(at row: Int) -> T {
        sectionView.st.dequeue(at: indexPath(from: row)) as T
    }
    
    /// 从缓存池取出 UITableViewHeaderFooterView
    ///
    /// - Returns: 具体类型的 `UITableViewCell`
    func dequeue<T: UITableViewHeaderFooterView & STViewProtocol>() -> T {
        sectionView.st.dequeue() as T
    }

}
#endif
