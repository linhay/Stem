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

open class SelectableSection<Cell: UICollectionViewCell & STViewProtocol & ConfigurableView>: SingleTypeSection<Cell>, SelectableCollectionProtocol where Cell.Model: SelectableProtocol {

    open var selectables: [Cell.Model] { models }

    /// 是否保证选中在当前序列中是否唯一 | default: true
    private let isUnique: Bool
    /// 是否需要支持反选操作 | default: false
    private let needInvert: Bool

    public init(_ models: [Cell.Model] = [], isUnique: Bool, needInvert: Bool) {
        self.isUnique = isUnique
        self.needInvert = needInvert
        super.init(models)
    }
    
    public override init(_ models: [Cell.Model] = []) {
        self.isUnique = true
        self.needInvert = false
        super.init(models)
    }
    
    open override func didSelectItem(at row: Int) {
        select(at: row, isUnique: isUnique, needInvert: needInvert)
    }

    open func didSelectElement(at index: Int, element: Cell.Model) {
        selectedEvent.call(element)
        selectedRowEvent.call(index)
    }

}
#endif
