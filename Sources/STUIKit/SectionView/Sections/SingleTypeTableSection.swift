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

open class SingleTypeTableSection<Cell: UITableViewCell>: SectionTableProtocol where Cell: ConfigurableView & STViewProtocol {

    public private(set) var models: [Cell.Model]

    public let selectedEvent = Delegate<Cell.Model, Void>()
    public let selectedRowEvent = Delegate<Int, Void>()
    public let willDisplayEvent = Delegate<Int, Void>()
    /// cell 样式配置
    public let configCellStyleEvent = Delegate<(row: Int, cell: Cell), Void>()

    public let headerViewProvider = Delegate<SingleTypeTableSection, UITableViewHeaderFooterView>()
    public let headerSizeProvider = Delegate<UITableView, CGSize>()

    public let footerViewProvider = Delegate<SingleTypeTableSection, UITableViewHeaderFooterView>()
    public let footerSizeProvider = Delegate<UITableView, CGSize>()

    open var headerView: UITableViewHeaderFooterView? { headerViewProvider.call(self) }
    open var footerView: UITableViewHeaderFooterView? { footerViewProvider.call(self) }

    open var headerHeight: CGFloat { headerSizeProvider.call(sectionView)?.height ?? 0 }
    open var footerHeight: CGFloat { footerSizeProvider.call(sectionView)?.height ?? 0 }

    public var core: SectionCore?

    open var itemCount: Int { models.count }

    public init(_ models: [Cell.Model] = []) {
        self.models = models
    }

    open func config(models: [Cell.Model]) {
        self.models = models
        reload()
    }

    open func didSelectItem(at row: Int) {
        selectedEvent.call(models[row])
        selectedRowEvent.call(row)
    }

    open func itemHeight(at row: Int) -> CGFloat {
        let width = sectionView.bounds.width
        return Cell.preferredSize(limit: .init(width: width,
                                               height: sectionView.bounds.height),
            model: models.value(at: row)).height
    }

    open func config(sectionView: UITableView) {
        sectionView.st.register(Cell.self)
    }

    open func item(at row: Int) -> UITableViewCell {
        let cell = dequeue(at: row) as Cell
        cell.config(models[row])
        configCellStyleEvent.call((row: row, cell: cell))
        return cell
    }

    open func willDisplayItem(at row: Int) {
        willDisplayEvent.call(row)
    }

}
