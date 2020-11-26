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

open class CacheableSingleTypeSection<Cell: UICollectionViewCell>: SingleTypeSection<Cell> where Cell: ConfigurableView & STViewProtocol, Cell.Model: Hashable {
    
    private var itemSizeCache = [Int: CGSize]()
    
    open override func config(models: [Cell.Model]) {
        var itemSizeCache = [Int: CGSize]()
        for model in models {
            itemSizeCache[model.hashValue] = self.itemSizeCache[model.hashValue]
        }
        self.itemSizeCache = itemSizeCache
        
        super.config(models: models)
    }
    
    open override func itemSize(at row: Int) -> CGSize {
        guard let hashValue = models.value(at: row)?.hashValue else {
            return super.itemSize(at: row)
        }
        if let size = itemSizeCache[hashValue] {
            return size
        }
        let size = super.itemSize(at: row)
        itemSizeCache[hashValue] = size
        return size
    }
    
}
#endif
