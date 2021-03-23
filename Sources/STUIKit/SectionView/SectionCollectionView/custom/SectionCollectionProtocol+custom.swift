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

public extension SectionCollectionProtocol {

    /// 注册 `STViewProtocol` 类型的 UICollectionViewCell
    ///
    /// - Parameter cell: UICollectionViewCell
    func register<T: UICollectionViewCell>(_ cell: T.Type) where T: STViewProtocol {
        sectionView.st.register(cell)
    }

    func register<T: UICollectionReusableView>(_ view: T.Type, for kind: SupplementaryViewKindType) where T: STViewProtocol {
        sectionView.st.register(view, for: kind)
    }
    
    /// 从缓存池取出 Cell
    ///
    /// - Parameter indexPath: IndexPath
    /// - Returns: 具体类型的 `UICollectionViewCell`
    func dequeue<T: UICollectionViewCell>(at row: Int) -> T where T: STViewProtocol {
        return sectionView.st.dequeue(at: indexPath(from: row)) as T
    }
    
    func dequeue<T: UICollectionReusableView>(at row: Int, kind: SupplementaryViewKindType) -> T where T: STViewProtocol {
        return sectionView.st.dequeue(at: indexPath(from: row), kind: kind) as T
    }

}
#endif
