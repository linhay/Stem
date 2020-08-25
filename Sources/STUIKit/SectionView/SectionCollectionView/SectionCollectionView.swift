/// MIT License
///
/// Copyright (c) 2020 linhey
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.

/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import UIKit

open class SectionCollectionView: UICollectionView {

    public var sectionFlowLayout: SectionCollectionFlowLayout? { collectionViewLayout as? SectionCollectionFlowLayout }
    /// 滚动方向
    public var scrollDirection: UICollectionView.ScrollDirection? {
        set { sectionFlowLayout?.scrollDirection = newValue ?? .vertical }
        get { return sectionFlowLayout?.scrollDirection }
    }
    
    public var layoutMode: SectionCollectionFlowLayout.ContentMode {
        set { sectionFlowLayout?.contentMode = newValue }
        get { sectionFlowLayout?.contentMode ?? .none }
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: SectionCollectionFlowLayout())
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
    
    private func initialize() {
        if backgroundColor == .black {
            backgroundColor = .white
        }
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
}
