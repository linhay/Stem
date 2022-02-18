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

public class SectionCollectionManager: SectionScrollManager {

    private let sectionManager: SectionManager<UICollectionView>
    private var isPicking = false
    private var wrappers = [Any]()

    public var sections: LazyMapSequence<LazyFilterSequence<LazyMapSequence<LazySequence<[SectionProtocol]>.Elements, SectionCollectionDriveProtocol?>>, SectionCollectionDriveProtocol> { sectionManager.sections.lazy.compactMap({ $0 as? SectionCollectionDriveProtocol }) }
    
    public var sectionView: UICollectionView { sectionManager.sectionView }

    public init(sectionView: UICollectionView) {
        sectionManager = .init(sectionView: sectionView)
        super.init()
        sectionManager.reloadDataEvent = { [weak self] in
            self?.reload()
        }
        sectionView.delegate = self
        sectionView.dataSource = self
    }

}

public extension SectionCollectionManager {

    enum Layout {
        case flow
        case compositional(UICollectionViewCompositionalLayoutConfiguration = UICollectionViewCompositionalLayoutConfiguration())
        case custom(UICollectionViewFlowLayout)
    }
    
    func collectionViewLayout(_ layout: Layout) -> UICollectionViewLayout {
        switch layout {
        case .flow:
            return UICollectionViewFlowLayout()
        case .compositional(let configuration):
            return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] index, environment in
                guard let self = self else { return nil }
                return (self.sections[index] as? SectionCollectionCompositionalLayoutProtocol)?.compositionalLayout(environment: environment)
            }, configuration: configuration)
        case .custom(let layout):
            return layout
        }
    }
    
    func set(layout: Layout) {
        sectionView.setCollectionViewLayout(collectionViewLayout(layout), animated: true)
    }
    
}

public extension SectionCollectionManager {

    func operational(_ refresh: SectionManager<UICollectionView>.Refresh) {
        guard isPicking == false else {
            return
        }
        
        switch refresh {
        case .none:
            break
        case .reload:
            sectionView.reloadData()
        case .insert(let indexSet):
            sectionView.insertSections(indexSet)
        case .delete(let indexSet):
            sectionView.deleteSections(indexSet)
        case .move(from: let from, to: let to):
            sectionView.moveSection(from, toSection: to)
        }
    }

    func pick(_ updates: (() -> Void), completion: ((Bool) -> Void)? = nil) {
        isPicking = true
        updates()
        isPicking = false
        reload()
        completion?(true)
    }

    func reload() {
        operational(sectionManager.reload())
    }

    func update<Section: SectionWrapperProtocol>(_ sections: [Section]) where Section.Section: SectionCollectionDriveProtocol {
        update(sections.map(\.wrappedSection))
        self.wrappers = sections
    }
    
    func update<Section: SectionWrapperProtocol>(_ sections: Section...) where Section.Section: SectionCollectionDriveProtocol {
        update(sections)
    }
    
    func update(_ sections: SectionCollectionDriveProtocol...) {
        update(sections)
    }

    func update(_ sections: [SectionCollectionDriveProtocol]) {
        let update = sectionManager.update(sections)
        sections.forEach({ $0.config(sectionView: sectionView) })
        operational(update)
        self.wrappers = []
    }

    func insert(section: SectionCollectionDriveProtocol, at index: Int) {
        let insert = sectionManager.insert(section: section, at: index)
        section.config(sectionView: sectionView)
        operational(insert)
    }

    func delete(at index: Int) {
        operational(sectionManager.delete(at: index))
    }

    func move(from: Int, to: Int) {
        operational(sectionManager.move(from: from, to: to))
    }

}

#endif

