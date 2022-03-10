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

open class SectionCollectionView: UICollectionView {
    
    public private(set) lazy var manager = SectionCollectionManager(sectionView: self)
        
    public convenience init() {
        self.init(frame: .zero, layout: .flow)
    }
    
    public convenience init(frame: CGRect = .zero, layout: Layout) {
        switch layout {
        case .flow:
            self.init(frame: frame, collectionViewLayout: SectionCollectionFlowLayout())
        case .compositional:
            self.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
            self.set(layout: layout)
        case .custom(let layout):
            self.init(frame: frame, collectionViewLayout: layout)
        }
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        collectionViewLayout = SectionCollectionFlowLayout()
        initialize()
    }
    
}

public extension SectionCollectionView {
    
    var sectionFlowLayout: SectionCollectionFlowLayout? { collectionViewLayout as? SectionCollectionFlowLayout }
    
    /// 滚动方向
    var scrollDirection: UICollectionView.ScrollDirection {
        set {
            switch collectionViewLayout {
            case let layout as UICollectionViewFlowLayout:
                layout.scrollDirection = newValue
            case let layout as UICollectionViewCompositionalLayout:
                layout.configuration.scrollDirection = newValue
            default:
                assertionFailure("未识别的 collectionViewLayout 类型")
            }
        }
        get {
            switch collectionViewLayout {
            case let layout as UICollectionViewFlowLayout:
                return layout.scrollDirection
            case let layout as UICollectionViewCompositionalLayout:
                return layout.configuration.scrollDirection
            default:
                assertionFailure("未识别的 collectionViewLayout 类型")
                return .vertical
            }
        }
    }

}

// MARK: - Layout
public extension SectionCollectionView {
    
    enum Layout {
        case flow
        case compositional(UICollectionViewCompositionalLayoutConfiguration = UICollectionViewCompositionalLayoutConfiguration())
        case custom(UICollectionViewFlowLayout)
    }
    
    func set(layout: Layout) {
        switch layout {
        case .flow:
            manager.set(layout: .custom(SectionCollectionFlowLayout()))
        case .compositional(let configuration):
            manager.set(layout: .compositional(configuration))
        case .custom(let layout):
            manager.set(layout: .custom(layout))
        }
    }
    
}

// MARK: - PluginModes
public extension SectionCollectionView {
    
    /// 设置 SupplementaryView 填充 单个 section 区域
    /// - Parameters:
    ///   - backgroundView: SupplementaryView
    ///   - section: section
    func set(backgroundView: SectionCollectionFlowLayout.DecorationView.Type, for section: SectionCollectionProtocol) {
        guard let pluginModes = sectionFlowLayout?.pluginModes else {
            return
        }
        
        var item = pluginModes
            .compactMap { mode -> SectionCollectionFlowLayout.DecorationElement? in
                switch mode {
                case .sectionBackgroundView(let element):
                    return element
                default:
                    return nil
                }
            }
            .reduce(SectionCollectionFlowLayout.DecorationElement()) { result, item in
                result.merging(item, uniquingKeysWith: { $1 })
            }
        
        item[.init(get: { section.isLoaded ? section.index : nil })] = backgroundView
        sectionFlowLayout?.update(mode: .sectionBackgroundView(item))
    }
    
    /// 布局插件
    /// - Parameter pluginModes: 样式
    func set(pluginModes: [SectionCollectionFlowLayout.PluginMode]) {
        sectionFlowLayout?.pluginModes = pluginModes
    }
    
    /// 布局插件
    /// - Parameter pluginModes: 样式
    func set(pluginModes: SectionCollectionFlowLayout.PluginMode...) {
        self.set(pluginModes: pluginModes)
    }
    
}


private extension SectionCollectionView {
    
    func initialize() {
        if backgroundColor == .black {
            backgroundColor = .white
        }
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
}

#endif
