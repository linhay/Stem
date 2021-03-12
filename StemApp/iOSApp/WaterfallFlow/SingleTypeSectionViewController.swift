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
        
        sectionView.set(pluginModes: .centerX)
        
        let section = HashableSingleTypeSection<TestCell>()
        section.sectionInset = .init(top: 20, left: 20, bottom: 0, right: 20)
        section.minimumLineSpacing = 4
        section.minimumInteritemSpacing = 4
        section.useSizeCache(true)
        
        var data = Array(0...3)

        section.selectedEvent.delegate(on: self) { (self, model) in
            if data.count > 40 {
                data = data.shuffled().dropLast(20)
            } else {
                data = data + Array(data.count...data.count + 1)
            }
            let models = data
                .map { TestCell.Model(title: "\($0)", width: 50, height: 50) }
            if #available(iOS 13, *) {
                section.config(difference: models)
            } else {
                // Fallback on earlier versions
            }
        }
        
        let models = data.map { TestCell.Model(title: "\($0)", width: 50, height: 50) }
        section.config(models: models)
        manager.update(section)
    }
    
}
