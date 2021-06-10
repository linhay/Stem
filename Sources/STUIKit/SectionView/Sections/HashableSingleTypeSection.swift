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

open class HashableSingleTypeSection<Cell: UICollectionViewCell & ConfigurableView & STViewProtocol>: SingleTypeSection<Cell> where Cell.Model: Hashable {
    
    /// size 是否缓存
    private var useSizeCache: Bool = false
    /// size 缓存
    private var itemSizeCache: [Int: CGSize] = [:]
    
    open override func itemSize(at row: Int) -> CGSize {
        let size  = itemSafeSize()
        let model = models[row]
        guard useSizeCache else {
            return Cell.preferredSize(limit: size, model: model)
        }
        
        if let itemSize = itemSizeCache[model.hashValue] {
            return itemSize
        } else {
            let itemSize = Cell.preferredSize(limit: size, model: model)
            itemSizeCache[model.hashValue] = itemSize
            return itemSize
        }
    }
    
    /// 使用 size 缓存
    open func useSizeCache(_ value: Bool) {
        useSizeCache = value
        if value == false {
            itemSizeCache = [:]
        }
    }
    
    open func config(auto models: [Cell.Model]) {
        if #available(iOS 13, *) {
            config(difference: models)
        } else {
            config(models: models)
        }
    }
    
    @available(iOS 13, *)
    open func config(difference models: [Cell.Model]) {
        let difference = models.difference(from: self.models)
        self.models = models
        pick {
            for change in difference {
                switch change {
                case let .remove(offset, model, _):
                    self.itemSizeCache.removeValue(forKey: model.hashValue)
                    self.delete(at: offset)
                case let .insert(offset, element, _):
                    self.insert(element, at: offset)
                }
            }
        }
    }
    
}

#endif
