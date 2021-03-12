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
    
    /// 布局插件样式
    public struct PluginMode: OptionSet, Comparable, Hashable {
        
        public static func < (lhs: SectionCollectionFlowLayout.PluginMode, rhs: SectionCollectionFlowLayout.PluginMode) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /// 左对齐
        public static let left = PluginMode(rawValue: 100)
        /// 居中对齐
        public static let centerX = PluginMode(rawValue: 100)
        /// header & footer 贴合 cell
        public static let fixSupplementaryViewInset  = PluginMode(rawValue: 1)
    }
    
    public var pluginModes: [PluginMode] = [] {
        didSet {
            var set = Set<PluginMode>()
            var newPluginModes = [PluginMode]()
            
            /// 优先级冲突去重
            for item in pluginModes {
                if set.contains(item) {
                    assertionFailure("mode冲突: \(pluginModes.filter({ $0 == item }))")
                } else {
                    set.update(with: item)
                    newPluginModes.append(item)
                }
            }
            
            /// mode 重排
            newPluginModes.sort(by: { $0 > $1 })
            if newPluginModes != pluginModes {
                pluginModes = newPluginModes
            }
        }
    }
    
    private var oldBounds = CGRect.zero
    
    override public func prepare() {
        guard let collectionView = collectionView else {
            return
        }
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
            default:
                break
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
                        _ minimumInteritemSpacing: CGFloat,
                        _ collectionView: UICollectionView) -> [UICollectionViewLayoutAttributes] {
            guard let firstItem = lineStore.first else {
                return lineStore
            }
            let allWidth = lineStore.reduce(0, { $0 + $1.frame.width }) + minimumInteritemSpacing * CGFloat(lineStore.count - 1)
            let offset = (collectionView.bounds.width - allWidth) / 2
            firstItem.frame.origin.x = offset
            _ = lineStore.dropFirst().reduce(firstItem) { (result, item) -> UICollectionViewLayoutAttributes in
                item.frame.origin.x = result.frame.maxX + minimumInteritemSpacing
                return item
            }
            
            return lineStore
        }
        
        var lineStore = [UICollectionViewLayoutAttributes]()
        var list = [UICollectionViewLayoutAttributes]()
        
        for item in attributes {
            guard item.representedElementCategory == .cell,
                  let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
                  /// self.minimumInteritemSpacing 获取时与 delegate 中数值不一致
                  let minimumInteritemSpacing = delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: item.indexPath.section) else {
                list.append(item)
                continue
            }
            
            if let lastItem = lineStore.last, lastItem.frame.minY == item.frame.minY {
                lineStore.append(item)
            } else if lineStore.isEmpty {
                lineStore.append(item)
            } else {
                list.append(contentsOf: appendLine(lineStore, minimumInteritemSpacing, collectionView))
                lineStore = [item]
            }
        }
        
        list.append(contentsOf: appendLine(lineStore, minimumInteritemSpacing, collectionView))
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
