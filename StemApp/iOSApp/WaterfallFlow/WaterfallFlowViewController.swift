//
//  WaterfallFlowViewController.swift
//  iOS
//
//  Created by 林翰 on 2020/12/10.
//  Copyright © 2020 linhey.ax. All rights reserved.
//

import UIKit
import Stem

class WaterfallFlowViewController: SectionCollectionViewController {
    
    let section = SingleTypeSection<TestCell>()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        sectionView.setCollectionViewLayout(STWaterfallFlowLayout(), animated: true)
        
        let widthSet: [Int: CGFloat] = [
            0: 0.25,
            1: 0.25,
            2: 0.25,
            3: 0.25
        ]
        
        section.sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        section.minimumLineSpacing = 20
        section.minimumInteritemSpacing = 10
        
        let maxWidth = view.frame.width - 10 * CGFloat(widthSet.count - 1) - section.sectionInset.left - section.sectionInset.right
        
        let list = (0...20000).map { (index) -> TestCell.Model in
            return .init(title: "\(section.index) - \(index)",
                         width: maxWidth * widthSet[index % widthSet.count]!,
                         height: CGFloat.random(in: 50...100))
        }
        
        section.config(models: list)
        manager.update(section)
    }
    
}
