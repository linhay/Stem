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

public protocol SectionCollectionProtocol: SectionProtocol {
    var minimumLineSpacing: CGFloat { get }
    var minimumInteritemSpacing: CGFloat { get }
    
    var sectionInset: UIEdgeInsets { get  }
    var sectionView: UICollectionView { get }
    
    var headerView: UICollectionReusableView? { get }
    var footerView: UICollectionReusableView? { get }
    
    var headerSize: CGSize { get }
    var footerSize: CGSize { get }
    
    func config(sectionView: UICollectionView)
    func itemSize(at row: Int) -> CGSize
    func item(at row: Int) -> UICollectionViewCell
}

public extension SectionCollectionProtocol {

    var headerView: UICollectionReusableView? { nil }
    var footerView: UICollectionReusableView? { nil }
    var headerSize: CGSize { .zero }
    var footerSize: CGSize { .zero }
    var sectionView: UICollectionView {
        guard let core = core else {
            assertionFailure("can't find sectionView, before `SectionCollectionProtocol` into `Manager`")
            return UICollectionView()
        }
        return core.sectionView as! UICollectionView
    }
    
}

public extension SectionCollectionProtocol {
    var minimumLineSpacing: CGFloat { 0 }
    var minimumInteritemSpacing: CGFloat { 0 }
    var sectionInset: UIEdgeInsets { .zero }
}

public extension SectionCollectionProtocol {

    func dequeue<T: UICollectionViewCell>(at row: Int, identifier: String = String(describing: T.self)) -> T {
        return sectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath(from: row)) as! T
    }

    func dequeue<T: UICollectionReusableView>(kind: SectionCollectionViewKind, identifier: String = String(describing: T.self)) -> T {
        return sectionView.dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: identifier, for: IndexPath(row: 0, section: index)) as! T
    }

}

public extension SectionCollectionProtocol {

    func deselect(at row: Int, animated: Bool) {
        sectionView.deselectItem(at: indexPath(from: row), animated: animated)
    }

    func cell(at row: Int) -> UICollectionViewCell? {
        return sectionView.cellForItem(at: indexPath(from: row))
    }

    func row(for cell: UICollectionViewCell) -> Int? {
        guard let indexPath = sectionView.indexPath(for: cell), indexPath.section == core?.index else {
            return nil
        }
        return indexPath.row
    }

    func pick(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        sectionView.performBatchUpdates(updates, completion: completion)
    }

}

public extension SectionCollectionProtocol {

    func reload() {
        core?.reloadDataEvent?()
    }

    func reload(at row: Int) {
        reload(at: [row])
    }

    func reload(at rows: [Int]) {
        sectionView.reloadItems(at: rows.map({ self.indexPath(from: $0) }))
    }

}

public extension SectionCollectionProtocol {

    func insert(at row: Int, willUpdate: (() -> Void)? = nil) {
        insert(at: [row])
    }

    func insert(at rows: [Int], willUpdate: (() -> Void)? = nil) {
        guard rows.isEmpty == false else {
            return
        }
        willUpdate?()
        if let max = rows.max(), sectionView.numberOfItems(inSection: index) <= max {
            core?.reloadDataEvent?()
        } else {
            sectionView.insertItems(at: indexPaths(from: rows))
        }
    }

}

public extension SectionCollectionProtocol {

    func delete(at row: Int, willUpdate: (() -> Void)? = nil) {
        delete(at: [row], willUpdate: willUpdate)
    }

    func delete(at rows: [Int], willUpdate: (() -> Void)? = nil) {
        guard rows.isEmpty == false else {
            return
        }
        willUpdate?()
        if itemCount <= 0 {
            core?.reloadDataEvent?()
        } else {
            sectionView.deleteItems(at: indexPaths(from: rows))
        }
    }

}

public extension SectionCollectionProtocol {

    func scroll(to row: Int, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        sectionView.scrollToItem(at: indexPath(from: row), at: scrollPosition, animated: animated)
    }

    func select(at row: Int?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        sectionView.selectItem(at: indexPath(from: row), animated: animated, scrollPosition: scrollPosition)
    }

}
