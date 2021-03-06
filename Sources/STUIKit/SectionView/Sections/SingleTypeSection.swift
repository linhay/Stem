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

open class SingleTypeSection<Cell: UICollectionViewCell & ConfigurableView & STViewProtocol>: SectionCollectionProtocol {
    
    open internal(set) var models: [Cell.Model]
    
    public let selectedEvent = Delegate<Cell.Model, Void>()
    public let selectedRowEvent = Delegate<Int, Void>()
    public let willDisplayEvent = Delegate<Int, Void>()
    /// cell 样式配置
    public let configCellStyleEvent = Delegate<(row: Int, cell: Cell), Void>()
    
    open var minimumLineSpacing: CGFloat = 0
    open var minimumInteritemSpacing: CGFloat = 0
    open var sectionInset: UIEdgeInsets = .zero
    
    open var hiddenHeaderWhenNoItem: Bool = true
    open var hiddenFooterWhenNoItem: Bool = true
    
    public let headerViewProvider = Delegate<SingleTypeSection, UICollectionReusableView>()
    public let headerSizeProvider = Delegate<UICollectionView, CGSize>()
    
    public let footerViewProvider = Delegate<SingleTypeSection, UICollectionReusableView>()
    public let footerSizeProvider = Delegate<UICollectionView, CGSize>()
    
    open var core: SectionCore?
    open var itemCount: Int { models.count }
    
    public init(_ models: [Cell.Model] = []) {
        self.models = models
    }
    
    open func config(models: [Cell.Model]) {
        self.models = models
        reload()
    }
    
    open func append(models: [Cell.Model]) {
        self.models.append(contentsOf: models)
        reload()
    }
    
    public func append(models: Cell.Model...) {
        append(models: models)
    }
    
    open func didSelectItem(at row: Int) {
        selectedEvent.call(models[row])
        selectedRowEvent.call(row)
    }
    
    open func config(sectionView: UICollectionView) {
        sectionView.st.register(Cell.self)
    }
    
    open func itemSize(at row: Int) -> CGSize {
        return Cell.preferredSize(limit: itemSafeSize(), model: models[row])
    }
    
    open func item(at row: Int) -> UICollectionViewCell {
        let cell = dequeue(at: row) as Cell
        cell.config(models[row])
        configCellStyleEvent.call((row: row, cell: cell))
        return cell
    }
    
    open func willDisplayItem(at row: Int) {
        willDisplayEvent.call(row)
    }
    
    open var headerView: UICollectionReusableView? { headerViewProvider.call(self) }
    open var headerSize: CGSize { headerSizeProvider.call(sectionView) ?? .zero }
    open var footerView: UICollectionReusableView? { footerViewProvider.call(self) }
    open var footerSize: CGSize { footerSizeProvider.call(sectionView) ?? .zero }
}

/// 增删
public extension SingleTypeSection {
    
    func swapAt(_ i: Int, _ j: Int) {
        models.swapAt(i, j)
        sectionView.reloadItems(at: [indexPath(from: i), indexPath(from: j)])
    }
    
    func insert(_ model: Cell.Model, at row: Int) {
        models.insert(model, at: row)
        sectionView.insertItems(at: [indexPath(from: row)])
    }
    
    func delete(at row: Int) {
        models.remove(at: row)
        if itemCount <= 0 {
            reload()
        } else {
            sectionView.deleteItems(at: [indexPath(from: row)])
        }
    }
    
}

public extension SingleTypeSection {
    
    func itemSafeSize() -> CGSize {
        if let flowLayout = sectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            switch flowLayout.scrollDirection {
            case .horizontal:
                return .init(width: sectionView.bounds.width,
                             height: sectionView.bounds.height
                                - sectionView.contentInset.top
                                - sectionView.contentInset.bottom
                                - sectionInset.top
                                - sectionInset.bottom)
            case .vertical:
                return .init(width: sectionView.bounds.width
                                - sectionView.contentInset.left
                                - sectionView.contentInset.right
                                - sectionInset.left
                                - sectionInset.right,
                             height: sectionView.bounds.height)
            @unknown default:
                return sectionView.bounds.size
            }
        } else {
            return sectionView.bounds.size
        }
    }
    
}
#endif
