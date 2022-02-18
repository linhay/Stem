//
//  CompositionalLayoutViewController.swift
//  iOSApp
//
//  Created by linhey on 2022/2/10.
//

import UIKit
import Stem

class CompositionalLayoutViewController: SectionCollectionViewController {

    var warppers: [SectionSelectableWrapper<DifferenceSection<TestCell>>] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        sectionView.set(layout: .compositional())
        dataSource()
    }

    
    func dataSource() {
        let sections = (0...10).map { index -> CompositionalSection<TestCell> in
            let section = CompositionalSection<TestCell>()
//            section.sectionInset = .init(top: 20, left: 20, bottom: 0, right: 20)
//            section.minimumLineSpacing = 4
//            section.minimumInteritemSpacing = 4
//            section.apply(safeSize: SectionSafeSize({ section in
//                return .init(width: 600, height: 400)
//            }))
            let data = Array(0...100)

//            section.headerSizeProvider.delegate(on: self) { (self, sectionView) in
//                return .init(width: sectionView.frame.width, height: 44)
//            }
            
            section.supplementaryProvider.delegate(on: self) { (self, result) in
                result.section.register(DecorationView.self, for: .header)
                return result.section.dequeue(kind: .header) as DecorationView
            }
                    
//            section.selectedEvent.delegate(on: self) { (self, model) in
//                if data.count > 40 {
//                    data = data.shuffled().dropLast(20)
//                } else {
//                    data = data + Array(data.count...data.count + 1)
//                }
//                let models = data
//                    .map { TestCell.Model(title: "\(index) - \($0)", width: 50, height: 50) }
//                section.config(models: models)
//            }
            
            let models = data.map { TestCell.Model(title: "\(index) - \($0)", width: 50, height: 50) }
            section.config(models: models)
            return section
        }
        
        manager.update(sections.map({ $0.selectableWrapper(isUnique: false, needInvert: true) }))
    }
    
}
