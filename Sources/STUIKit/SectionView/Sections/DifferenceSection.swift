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

public final class SectionSizeCache {

    public var kv: [Int: CGSize]
    
    public init(kv: [Int: CGSize] = [:]) {
        self.kv = kv
    }
    
    public subscript(_ key: AnyHashable) -> CGSize? {
        set {
            kv[key.hashValue] = newValue
        }
        get {
            kv[key.hashValue]
        }
    }
    
}

open class DifferenceSection<Cell: UICollectionViewCell & ConfigurableView & STViewProtocol>: SingleTypeSection<Cell> where Cell.Model: Hashable {
    
    /// 是否是共享 size 缓存
    public let isShareSizeCache: Bool
    /// size 缓存
    public let sizeCache: SectionSizeCache
    
    private var viewSize = CGSize.zero
    
    /// init
    /// - Parameters:
    ///   - models: 数据
    ///   - shareSizeCache: 与其他 section 共享缓存
    public init(_ models: [Cell.Model] = [], shareSizeCache: SectionSizeCache? = nil) {
        self.isShareSizeCache = shareSizeCache != nil
        self.sizeCache = shareSizeCache ?? .init()
        super.init(models)
    }
    
    open override func itemSize(at row: Int) -> CGSize {
        
        let size = safeSize.size(self)
        let model = models[row]
        
        if viewSize != size {
            sizeCache.kv.removeAll()
        }
        
        if let itemSize = sizeCache[model] {
            return itemSize
        } else {
            let itemSize = Cell.preferredSize(limit: size, model: model)
            sizeCache[model] = itemSize
            return itemSize
        }
    }
    
    open override func config(models: [Cell.Model]) {
        let models = validate(models)
        if models.isEmpty {
            super.config(models: models)
        } else if #available(iOS 13, *), isLoaded {
            config(difference: models)
        } else {
            super.config(models: models)
        }
    }
    
}

private extension DifferenceSection {
    
    @available(iOS 13, *)
    func config(difference models: [Cell.Model]) {
        let difference = models.difference(from: self.models)
        pick {
            for change in difference {
                switch change {
                case let .remove(offset, model, _):
                    if isShareSizeCache == false {
                        self.sizeCache[model] = nil
                    }
                    self.delete(at: offset)
                case let .insert(offset, element, _):
                    self.insert(element, at: offset)
                }
            }
        }
    }
    
}
#endif
