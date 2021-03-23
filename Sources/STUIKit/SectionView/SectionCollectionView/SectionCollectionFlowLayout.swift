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

open class SectionCollectionFlowLayout: UICollectionViewFlowLayout {
    
    public typealias DecorationView = UICollectionReusableView & STViewProtocol
    
    /// 布局插件样式
    public enum PluginMode {
        /// 左对齐
        case left
        /// 居中对齐
        case centerX
        /// header & footer 贴合 cell
        case fixSupplementaryViewInset
        case sectionBackgroundView([(view: DecorationView.Type, section: Int)])
        case allSectionBackgroundView(view: DecorationView.Type)

        var priority: Int {
            switch self {
            case .left:    return 100
            case .centerX: return 100
            case .fixSupplementaryViewInset: return 1
            case .sectionBackgroundView: return 20000
            case .allSectionBackgroundView: return 20000
            }
        }
    }
    
    public var pluginModes: [PluginMode] = [] {
        didSet {
            var set = Set<Int>()
            var newPluginModes = [PluginMode]()
            
            /// 优先级冲突去重
            for item in pluginModes {
                if set.insert(item.priority).inserted {
                    newPluginModes.append(item)
                } else {
                    assertionFailure("mode冲突: \(pluginModes.filter({ $0.priority == item.priority }))")
                }
            }
            
            /// mode 重排
            pluginModes = newPluginModes.sorted(by: { $0.priority < $1.priority })
        }
    }
    
    private var oldBounds = CGRect.zero
    private var decorationViewCache = [Int: UICollectionViewLayoutAttributes]()
    
    override public func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        decorationViewCache.removeAll()
        oldBounds = collectionView.bounds
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView,
              var attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        if pluginModes.isEmpty {
            return attributes
        }
        
        attributes = attributes.compactMap({ $0.copy() as? UICollectionViewLayoutAttributes })
        
        for mode in pluginModes {
            switch mode {
            case .centerX:
                attributes = modeCenterX(collectionView, attributes: attributes) ?? []
            case .left:
                attributes = modeLeft(collectionView, attributes: attributes) ?? []
            case .fixSupplementaryViewInset:
                attributes = modeFixSupplementaryViewInset(collectionView, attributes: attributes) ?? []
            case .sectionBackgroundView(let list):
                for (view, section) in list {
                    let sectionAttributes = attributes.filter{ $0.indexPath.section == section }
                    if let attribute = modeSectionBackgroundView(view: view, attributes: sectionAttributes) {
                        attributes.append(attribute)
                    }
                }
            case .allSectionBackgroundView(view: let view):
                let store = attributes.reduce([Int: [UICollectionViewLayoutAttributes]]()) { result, item -> [Int: [UICollectionViewLayoutAttributes]] in
                    var result = result
                    let section = item.indexPath.section
                    if result[section] != nil {
                        result[section]?.append(item)
                    } else {
                        result[section] = [item]
                    }
                    return result
                }
                
                for sectionAttributes in store.values {
                    if let attribute = modeSectionBackgroundView(view: view, attributes: sectionAttributes) {
                        attributes.append(attribute)
                    }
                }
            }
        }
        
        return attributes
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return oldBounds.size != newBounds.size || sectionHeadersPinToVisibleBounds || sectionFootersPinToVisibleBounds
    }
    
}

// MARK: - Mode
private extension SectionCollectionFlowLayout {
    
    func modeSectionBackgroundView(view: DecorationView.Type,
                                   attributes: [UICollectionViewLayoutAttributes]) -> UICollectionViewLayoutAttributes? {
        guard let first = attributes.first else {
            return nil
        }
        
        if let decorationView = decorationViewCache[first.indexPath.section] {
            if first.indexPath.item == 0 {
                return nil
            }
            
            let rects = attributes.reduce(decorationView.frame) { return $0.union($1.frame) }
            decorationView.frame = rects
            return nil
        }
        
        let rects = attributes.dropFirst().reduce(first.frame) { return $0.union($1.frame) }
        
        st.register(view)
        let attribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: view.id, with: first.indexPath)
        attribute.zIndex = -1
        attribute.frame = rects
        decorationViewCache[first.indexPath.section] = attribute
        return attribute
    }
    
    func modeFixSupplementaryViewInset(_ collectionView: UICollectionView, attributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes]? {
        for item in attributes {
            guard item.representedElementCategory == .supplementaryView,
                  let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
                  let inset = delegate.collectionView?(collectionView, layout: self, insetForSectionAt: item.indexPath.section)
            else {
                continue
            }
            if item.representedElementKind == UICollectionView.elementKindSectionFooter {
                item.frame.origin.y -= inset.bottom
            } else if item.representedElementKind == UICollectionView.elementKindSectionHeader {
                item.frame.origin.y += inset.top
            }
        }
        return attributes
    }
    
    func modeCenterX(_ collectionView: UICollectionView, attributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes]? {
        
        func appendLine(_ lineStore: [UICollectionViewLayoutAttributes],
                        _ collectionView: UICollectionView) -> [UICollectionViewLayoutAttributes] {
            guard let firstItem = lineStore.first else {
                return lineStore
            }
            
            var spacing = self.minimumInteritemSpacing
            
            if let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
                spacing = delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: firstItem.indexPath.section) ?? spacing
            }
            
            let allWidth = lineStore.reduce(0, { $0 + $1.frame.width }) + spacing * CGFloat(lineStore.count - 1)
            let offset = (collectionView.bounds.width - allWidth) / 2
            firstItem.frame.origin.x = offset
            _ = lineStore.dropFirst().reduce(firstItem) { (result, item) -> UICollectionViewLayoutAttributes in
                item.frame.origin.x = result.frame.maxX + spacing
                return item
            }
            return lineStore
        }
        
        var lineStore = [UICollectionViewLayoutAttributes]()
        var list = [UICollectionViewLayoutAttributes]()
        
        for item in attributes {
            guard item.representedElementCategory == .cell else {
                list.append(item)
                continue
            }
            
            if lineStore.isEmpty {
                lineStore.append(item)
            } else if let lastItem = lineStore.last,
                      lastItem.indexPath.section == item.indexPath.section,
                      lastItem.frame.minY == item.frame.minY {
                lineStore.append(item)
            } else {
                list.append(contentsOf: appendLine(lineStore, collectionView))
                lineStore = [item]
            }
        }
        
        list.append(contentsOf: appendLine(lineStore, collectionView))
        return list
    }
    
    func modeLeft(_ collectionView: UICollectionView, attributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes]? {
        
        var list = [UICollectionViewLayoutAttributes]()
        var section = [UICollectionViewLayoutAttributes]()
        
        for item in attributes {
            guard item.representedElementCategory == .cell else {
                list.append(item)
                continue
            }
            
            switch item.representedElementCategory {
            case .cell:
                break
            case .decorationView:
                list.append(item)
                continue
            case .supplementaryView:
                section.append(item)
                list.append(item)
                continue
            @unknown default:
                list.append(item)
                continue
            }
            
            var spacing = self.minimumInteritemSpacing
            var insets = self.sectionInset
            
            if let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
                spacing = delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: item.indexPath.section) ?? spacing
                insets = delegate.collectionView?(collectionView, layout: self, insetForSectionAt: item.indexPath.section) ?? insets
            }
            
            switch scrollDirection {
            case .horizontal:
                if let lastItem = section.last {
                    if lastItem.indexPath.section != item.indexPath.section {
                        item.frame.origin.x = lastItem.frame.maxX + insets.left
                    } else {
                        item.frame.origin.x = lastItem.frame.maxX + spacing
                    }
                } else {
                    item.frame.origin.x = insets.left
                }
            case .vertical:
                if section.last?.indexPath.section != item.indexPath.section {
                    section.removeAll()
                }
                
                if let lastItem = section.last, lastItem.frame.maxY == item.frame.maxY {
                    item.frame.origin.x = lastItem.frame.maxX + spacing
                } else {
                    item.frame.origin.x = insets.left
                }
            @unknown default:
                break
            }
            
            section.append(item)
            list.append(item)
        }
        return list
    }
    
}
#endif
