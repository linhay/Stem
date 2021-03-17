//
//  CoverFlowViewController.swift
//  iOSApp
//
//  Created by 林翰 on 2021/3/17.
//

import UIKit
import Stem

class CoverFlowViewController: SectionCollectionViewController {
    
    let section = SingleTypeSection<TestCell>()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        sectionView.setCollectionViewLayout(STCoverFlowLayout(), animated: true)
        sectionView.scrollDirection = .horizontal
        section.sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        section.minimumLineSpacing = 20
        section.minimumInteritemSpacing = 10
                
        let list = (0...20).map { (index) -> TestCell.Model in
            return .init(title: "\(section.index) - \(index)",
                         width: 200, height: 200)
        }
        
        section.config(models: list)
        manager.update(section)
    }
    
}
