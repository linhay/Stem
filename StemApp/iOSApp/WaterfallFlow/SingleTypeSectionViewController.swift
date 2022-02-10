//
//  SingleTypeSectionViewController.swift
//  iOSApp
//
//  Created by 林翰 on 2021/3/12.
//

import UIKit
import Stem

class SingleTypeSectionViewController: SectionCollectionViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionView.set(pluginModes: .centerX, .sectionHeadersPinToVisibleBounds([.init(get: { 3 }), .init(get: { 2 })]))
        
        let sections = (0...10).map { index -> DifferenceSection<TestCell> in
            let section = DifferenceSection<TestCell>()
            section.sectionInset = .init(top: 20, left: 20, bottom: 0, right: 20)
            section.minimumLineSpacing = 4
            section.minimumInteritemSpacing = 4
            section.apply(safeSize: SectionSafeSize({ section in
                return .init(width: 600, height: 400)
            }))
            var data = Array(0...3)

            section.headerSizeProvider.delegate(on: self) { (self, sectionView) in
                return .init(width: sectionView.frame.width, height: 44)
            }
            
            section.headerViewProvider.delegate(on: self) { (self, section) in
                section.register(DecorationView.self, for: .header)
                return section.dequeue(kind: .header) as DecorationView
            }
                    
            section.selectedEvent.delegate(on: self) { (self, model) in
                if data.count > 40 {
                    data = data.shuffled().dropLast(20)
                } else {
                    data = data + Array(data.count...data.count + 1)
                }
                let models = data
                    .map { TestCell.Model(title: "\(index) - \($0)", width: 50, height: 50) }
                section.config(models: models)
            }
            
            let models = data.map { TestCell.Model(title: "\(index) - \($0)", width: 50, height: 50) }
            section.config(models: models)
            return section
        }
        
        sectionView.set(pluginModes: .sectionHeadersPinToVisibleBounds([
            .init(get: { sections[2].index }),
            .init(get: { sections[4].index }),
            .init(get: { sections[5].index }),
        ]))
        manager.update(sections)
    }
    
}
