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
import Foundation
import UIKit
#if canImport(Combine)
import Combine
#endif

open class SingleTypeDriveSection<Cell: UICollectionViewCell & LoadViewProtocol & ConfigurableModelProtocol>: SingleTypeDriveSectionProtocol {

    public typealias Publishers = SingleTypeDriveSectionPublishers<Cell.Model>
    public private(set) var models: [Cell.Model]
    public let publishers = Publishers()
        
    public let selectedEvent = Delegate<Cell.Model, Void>()
    public let selectedRowEvent = Delegate<Int, Void>()
    public let willDisplayEvent = Delegate<Int, Void>()
    public let willDisplaySupplementaryViewEvent      = Delegate<Publishers.SupplementaryResult, Void>()
    public let didEndDisplayingSupplementaryViewEvent = Delegate<Publishers.SupplementaryResult, Void>()
    /// cell 样式配置
    public let cellStyleProvider  = Delegate<(row: Int, cell: Cell), Void>()
    
    open var core: SectionCore?
    open var itemCount: Int { models.count }
    
    private var cancellables = Set<AnyCancellable>()

    public init(_ models: [Cell.Model] = []) {
        self.models = models
    }
    
    @MainActor
    open func config(models: [Cell.Model]) {
        self.models = validate(models)
        reload()
    }
    
    /// 过滤无效数据
    open func validate(_ models: [Cell.Model]) -> [Cell.Model] {
        models.filter({ Cell.validate($0) })
    }
    
    open func didSelectItem(at row: Int) {
        publishers.cell._selected.send(.init(row: row, model: models[row]))
        selectedEvent.call(models[row])
        selectedRowEvent.call(row)
    }
    
    open func config(sectionView: UICollectionView) {
        sectionView.st.register(Cell.self)
    }
    
    open func item(at row: Int) -> UICollectionViewCell {
        let cell = dequeue(at: row) as Cell
        cell.config(models[row])
        cellStyleProvider.call((row: row, cell: cell))
        return cell
    }
    
    open func willDisplayItem(at row: Int) {
        willDisplayEvent.call(row)
    }
    
    open func willDisplaySupplementaryView(view: UICollectionReusableView, forElementKind elementKind: String, at row: Int) {
        let result = Publishers.SupplementaryResult(view: view, elementKind: elementKind, row: row)
        willDisplaySupplementaryViewEvent.call(result)
        publishers.supplementary._willDisplay.send(result)
    }
    
    open func didEndDisplayingSupplementaryView(view: UICollectionReusableView, forElementKind elementKind: String, at row: Int) {
        let result = Publishers.SupplementaryResult(view: view, elementKind: elementKind, row: row)
        didEndDisplayingSupplementaryViewEvent.call(result)
        publishers.supplementary._didEndDisplaying.send(result)
    }
    
}

/// 增删
extension SingleTypeDriveSection {
    
    public func swapAt(_ i: Int, _ j: Int) {
        models.swapAt(i, j)
        sectionView.reloadItems(at: [indexPath(from: i), indexPath(from: j)])
    }
    
    public func insert(_ model: Cell.Model, at row: Int) {
        models.insert(model, at: row)
        sectionView.insertItems(at: [indexPath(from: row)])
    }
    
    public func delete(at row: Int) {
        models.remove(at: row)
        if itemCount <= 0 {
            reload()
        } else {
            sectionView.deleteItems(at: [indexPath(from: row)])
        }
    }
    
}
#endif
