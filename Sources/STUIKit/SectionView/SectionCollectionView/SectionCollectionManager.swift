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

    private var environment: SectionReducer.Environment<UICollectionView>
    private var reducer = SectionReducer(state: .init())
    private var isPicking = false

    public var sectionView: UICollectionView { environment.sectionView }
    public var dynamicTypes: [SectionDynamicType] { reducer.state.types }
    public var sections: LazyMapSequence<LazyFilterSequence<LazyMapSequence<LazySequence<[SectionDynamicType]>.Elements, SectionCollectionDriveProtocol?>>, SectionCollectionDriveProtocol> { dynamicTypes.lazy.compactMap({ $0.section as? SectionCollectionDriveProtocol }) }
    

    public init(sectionView: UICollectionView) {
        environment = .init(sectionView: sectionView, reloadDataEvent: nil)
        super.init()
        environment.reloadDataEvent = { [weak self] in
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

private extension SectionCollectionManager {

    func operational(_ refresh: SectionReducer.OutputAction) {
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
    
}

public extension SectionCollectionManager {

    func pick(_ updates: (() -> Void), completion: ((Bool) -> Void)? = nil) {
        isPicking = true
        updates()
        isPicking = false
        reload()
        completion?(true)
    }
    
    func reload() {
        let action = reducer.reducer(action: .reload, environment: environment)
        operational(action)
    }

}

public extension SectionCollectionManager {

    func update<Section: SectionWrapperProtocol>(_ sections: Section...) {
        update(sections)
    }
    
    func update<Section: SectionWrapperProtocol>(_ sections: [Section]) {
        update(sections.map(\.eraseToDynamicType))
    }
    
    func insert<Section: SectionWrapperProtocol>(_ sections: Section..., at index: Int) {
        insert(sections, at: index)
    }
    
    func insert<Section: SectionWrapperProtocol>(_ sections: [Section], at index: Int) {
        insert(sections.map(\.eraseToDynamicType), at: index)
    }

    func delete<Section: SectionWrapperProtocol>(_ sections: Section...) {
        delete(sections)
    }
    
    func delete<Section: SectionWrapperProtocol>(_ sections: [Section]) {
        delete(sections.map(\.eraseToDynamicType))
    }

    func move<Section1: SectionWrapperProtocol, Section2: SectionWrapperProtocol>(from: Section1, to: Section2) {
        move(from: from.eraseToDynamicType, to: to.eraseToDynamicType)
    }
    
}

public extension SectionCollectionManager {
    
    func update(_ sections: SectionCollectionDriveProtocol...) {
        update(sections)
    }

    func update(_ sections: [SectionCollectionDriveProtocol]) {
        update(sections.map(\.eraseToDynamicType))
    }
    
    func insert(_ sections: SectionCollectionDriveProtocol..., at index: Int) {
        insert(sections, at: index)
    }

    func insert(_ sections: [SectionCollectionDriveProtocol], at index: Int) {
        insert(sections.map(\.eraseToDynamicType), at: index)
    }
    
    func delete(_ sections: SectionCollectionDriveProtocol...) {
        delete(sections)
    }

    func delete(_ sections: [SectionCollectionDriveProtocol]) {
        delete(sections.map(\.eraseToDynamicType))
    }

    func move(from: SectionCollectionDriveProtocol, to: SectionCollectionDriveProtocol) {
        move(from: from.eraseToDynamicType, to: to.eraseToDynamicType)
    }

}

public extension SectionCollectionManager {

    func update(_ types: [SectionDynamicType]) {
        let update = reducer.reducer(action: .update(types: types), environment: environment)
        types.map(\.section).compactMap({ $0 as? SectionCollectionDriveProtocol }).forEach({ $0.config(sectionView: sectionView) })
        operational(update)
    }

    func insert(_ types: [SectionDynamicType], at index: Int) {
        let insert = reducer.reducer(action: .insert(types: types, at: index), environment: environment)
        types.map(\.section).compactMap({ $0 as? SectionCollectionDriveProtocol }).forEach({ $0.config(sectionView: sectionView) })
        operational(insert)
    }

    func delete(_ types: [SectionDynamicType]) {
        operational(reducer.reducer(action: .delete(types: types), environment: environment))
    }

    func move(from: SectionDynamicType, to: SectionDynamicType) {
        operational(reducer.reducer(action: .move(from: from, to: to), environment: environment))
    }
    
}

#endif

