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
    public typealias DecorationElement = [DecorationElementKey: DecorationView.Type]
    
    public class DecorationElementKey: Hashable {

        public static let all = DecorationElementKey(get: { -1 })
        
        public static func == (lhs: SectionCollectionFlowLayout.DecorationElementKey, rhs: SectionCollectionFlowLayout.DecorationElementKey) -> Bool {
            return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }
        
        let callback: () -> Int?
        
        public init(get callback: @escaping () -> Int?) {
            self.callback = callback
        }
        
        var index: Int { callback() ?? -404 }
        
    }
    
    /// 布局插件样式
    public enum PluginMode {
        /// 左对齐
        case left
        /// 居中对齐
        case centerX
        /// fix: header & footer 贴合 cell
        case fixSupplementaryViewInset
        /// fix: header & footer size与设定值不符
        case fixSupplementaryViewSize
        case sectionBackgroundView(DecorationElement)
        case allSectionBackgroundView(type: DecorationView.Type)
        
        var id: Int {
            switch self {
            case .left:    return 1
            case .centerX: return 2
            case .fixSupplementaryViewSize: return 3
            case .fixSupplementaryViewInset: return 4
            case .sectionBackgroundView: return 5
            case .allSectionBackgroundView: return 6
            }
        }
        
        var priority: Int {
            switch self {
            case .left:    return 100
            case .centerX: return 100
            case .fixSupplementaryViewSize: return 1
            case .fixSupplementaryViewInset: return 2
            case .sectionBackgroundView: return 200
            case .allSectionBackgroundView: return 200
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
    
    public func update(mode: PluginMode) {
        var modes = pluginModes.filter({ $0.id != mode.id })
        modes.append(mode)
        self.pluginModes = modes
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
            case .fixSupplementaryViewSize:
                attributes = modeFixSupplementaryViewSize(collectionView, attributes: attributes) ?? []
            case .centerX:
                attributes = modeCenterX(collectionView, attributes: attributes) ?? []
            case .left:
                attributes = modeLeft(collectionView, attributes: attributes) ?? []
            case .fixSupplementaryViewInset:
                attributes = modeFixSupplementaryViewInset(collectionView, attributes: attributes) ?? []
            case .sectionBackgroundView(let elements):
                attributes = modeSectionBackgroundView(collectionView, element: elements, attributes: attributes) ?? []
            case .allSectionBackgroundView(type: let type):
                attributes = modeSectionBackgroundView(collectionView, element: [DecorationElementKey.all: type], attributes: attributes) ?? []
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
    
    func modeSectionBackgroundView(_ collectionView: UICollectionView,
                                   element: DecorationElement,
                                   attributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes]? {
        
        func task(section: Int, type: DecorationView.Type) -> UICollectionViewLayoutAttributes? {
            if decorationViewCache[section] != nil {
                return nil
            }
            
            if let nib = type.nib {
                register(nib, forDecorationViewOfKind: type.id)
            } else {
                register(type.self, forDecorationViewOfKind: type.id)
            }
            
            let count = collectionView.numberOfItems(inSection: section)
            let sectionIndexPath = IndexPath(item: 0, section: section)
            
            let header = self.layoutAttributesForSupplementaryView(ofKind: SectionCollectionViewKind.header.rawValue, at: sectionIndexPath)
            let footer = self.layoutAttributesForSupplementaryView(ofKind: SectionCollectionViewKind.footer.rawValue, at: sectionIndexPath)
            let cells  = (0..<count).map({ self.layoutAttributesForItem(at: IndexPath(row: $0, section: section)) })
            let elements = ([header, footer] + cells).compactMap(\.?.frame).filter({ $0.size.width > 0 && $0.size.height > 0 })
            guard let first = elements.first else {
                return nil
            }
            
            let attribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: type.id, with: sectionIndexPath)
            attribute.zIndex = -1
            attribute.frame = elements.dropFirst().reduce(first) { return $0.union($1) }
            
            if pluginModes.contains(where: { $0.priority == PluginMode.fixSupplementaryViewInset.priority }) {
                let inset = insetForSection(at: attribute.indexPath.section)
                if let header = header, header.frame.size != .zero {
                    attribute.frame.origin.y += inset.top
                }
                if let footer = footer, footer.frame.size != .zero {
                    attribute.frame.size.height -= inset.top + inset.bottom
                }
            }
            
            decorationViewCache[section] = attribute
            return attribute
        }
        
        var sectionSet = Set<Int>()
        let sections = attributes
            .map(\.indexPath.section)
            .filter({ sectionSet.insert($0).inserted })
        
        if let type = element[DecorationElementKey.all] {
            return attributes + sections.compactMap { task(section: $0, type: type) }
        } else {
            let indexs = element.keys.map(\.index)
            return attributes + sections
                .filter({ indexs.contains($0) })
                .compactMap { index in
                    guard let view = element.first(where: { $0.key.index == index })?.value else {
                        return nil
                    }
                    return task(section: index, type: view)
                }
        }
        
    }
    
    func modeFixSupplementaryViewSize(_ collectionView: UICollectionView, attributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes]? {
        let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
        return attributes
            .filter{ $0.representedElementCategory == .supplementaryView }
            .map { attribute in
                let inset = insetForSection(at: attribute.indexPath.section)
                if attribute.representedElementKind == UICollectionView.elementKindSectionFooter {
                    attribute.size = self.footerSizeForSection(at: attribute.indexPath.section)
                } else if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                    attribute.size = self.headerSizeForSection(at: attribute.indexPath.section)
                }
                return attribute
            }
    }
    
    func modeFixSupplementaryViewInset(_ collectionView: UICollectionView, attributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes]? {
        attributes
            .filter{ $0.representedElementCategory == .supplementaryView }
            .map { attribute in
                let inset = insetForSection(at: attribute.indexPath.section)
                if attribute.representedElementKind == UICollectionView.elementKindSectionFooter {
                    attribute.frame.origin.y -= inset.bottom
                } else if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                    attribute.frame.origin.y += inset.top
                }
                
                return attribute
            }
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
            
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
            let insets = delegate?.collectionView?(collectionView,
                                                   layout: self,
                                                   insetForSectionAt: item.indexPath.section) ?? sectionInset
            
            let minimumInteritemSpacing = delegate?.collectionView?(collectionView,
                                                 layout: self,
                                                 minimumInteritemSpacingForSectionAt: item.indexPath.section) ?? minimumInteritemSpacing
            
            switch scrollDirection {
            case .horizontal:
                if let lastItem = section.last {
                    if lastItem.indexPath.section != item.indexPath.section {
                        item.frame.origin.x = lastItem.frame.maxX + insets.left
                    } else {
                        item.frame.origin.x = lastItem.frame.maxX + minimumInteritemSpacing
                    }
                } else {
                    item.frame.origin.x = insets.left
                }
            case .vertical:
                if section.last?.indexPath.section != item.indexPath.section {
                    section.removeAll()
                }
                
                if let lastItem = section.last, lastItem.frame.maxY == item.frame.maxY {
                    item.frame.origin.x = lastItem.frame.maxX + minimumInteritemSpacing
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

private extension SectionCollectionFlowLayout {
    
    func headerSizeForSection(at section: Int) -> CGSize {
        guard let collectionView = collectionView,
              let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
              let size = delegate.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) else {
                  return .zero
        }
        return size
    }
    
    func footerSizeForSection(at section: Int) -> CGSize {
        guard let collectionView = collectionView,
              let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
              let size = delegate.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section) else {
                  return .zero
        }
        return size
    }
    
    func insetForSection(at section: Int) -> UIEdgeInsets {
        guard let collectionView = collectionView,
              let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
              let inset = delegate.collectionView?(collectionView, layout: self, insetForSectionAt: section) else {
            return sectionInset
        }
        return inset
    }
    
}
#endif
