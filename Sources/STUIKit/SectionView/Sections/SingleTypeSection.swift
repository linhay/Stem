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

open class SingleTypeSection<Cell: UICollectionViewCell>: SectionCollectionProtocol where Cell: ConfigurableCollectionCell & STViewProtocol {

    public private(set) var models: [Cell.Model]

    public let selectedEvent = Delegate<Cell.Model, Void>()
    public let selectedRowEvent = Delegate<Int, Void>()
    public let willDisplayEvent = Delegate<Int, Void>()
    /// cell 样式配置
    public let configCellStyleEvent = Delegate<(row: Int, cell: Cell), Void>()

    public var minimumLineSpacing: CGFloat = 0
    public var minimumInteritemSpacing: CGFloat = 0
    public var sectionInset: UIEdgeInsets = .zero

    public let headerViewProvider = Delegate<SingleTypeSection, UICollectionReusableView>()
    public let headerSizeProvider = Delegate<UICollectionView, CGSize>()

    public let footerViewProvider = Delegate<SingleTypeSection, UICollectionReusableView>()
    public let footerSizeProvider = Delegate<UICollectionView, CGSize>()

    public var core: SectionCore?
    public var itemCount: Int { models.count }

    public init(_ models: [Cell.Model] = []) {
        self.models = models
    }

    open func config(models: [Cell.Model]) {
        self.models = models
        reload()
    }

    open func itemSize(at row: Int) -> CGSize {
        return Cell.preferredSize(collectionView: sectionView, model: models.value(at: row))
    }

    open func didSelectItem(at row: Int) {
        selectedEvent.call(models[row])
        selectedRowEvent.call(row)
    }

}

public extension SingleTypeSection {

    var headerView: UICollectionReusableView? { headerViewProvider.call(self) }
    var headerSize: CGSize { headerSizeProvider.call(sectionView) ?? .zero }
    var footerView: UICollectionReusableView? { footerViewProvider.call(self) }
    var footerSize: CGSize { footerSizeProvider.call(sectionView) ?? .zero }

}

public extension SingleTypeSection {

    func config(sectionView: UICollectionView) {
        sectionView.st.register(Cell.self)
    }

    func item(at row: Int) -> UICollectionViewCell {
        let cell = dequeue(at: row) as Cell
        cell.config(models[row])
        configCellStyleEvent.call((row: row, cell: cell))
        return cell
    }

    func willDisplayItem(at row: Int) {
        willDisplayEvent.call(row)
    }

}