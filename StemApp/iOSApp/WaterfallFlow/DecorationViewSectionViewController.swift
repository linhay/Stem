//
//  DecorationViewSectionViewController.swift
//  iOSApp
//
//  Created by 林翰 on 2021/3/23.
//

import UIKit
import Stem

class DecorationViewSectionViewController: SectionCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sections = (0...5).map { _ -> HashableSingleTypeSection<TestCell> in
            let section = HashableSingleTypeSection<TestCell>()
            section.sectionInset = .init(top: 20, left: 20, bottom: 0, right: 20)
            section.minimumLineSpacing = 4
            section.minimumInteritemSpacing = 4
            section.useSizeCache(true)
            
            section.headerViewProvider.delegate(on: self) { (self, section) -> UICollectionReusableView in
                section.register(DecorationView.self, for: .header)
                return section.dequeue(at: 0, kind: .header) as DecorationView
            }
            
            section.headerSizeProvider.delegate(on: self) { (self, sectionView) -> CGSize in
                return .init(width: 120, height: 20)
            }
            
            section.footerViewProvider.delegate(on: self) { (self, section) -> UICollectionReusableView in
                section.register(DecorationView.self, for: .footer)
                return section.dequeue(at: 0, kind: .footer) as DecorationView
            }
            
            section.footerSizeProvider.delegate(on: self) { (self, sectionView) -> CGSize in
                return .init(width: 120, height: 40)
            }
            
            let models = (0...10).map { TestCell.Model(title: "\($0)", width: 50, height: 50) }
            section.config(models: models)
            return section
        }
        
        sectionView.set(pluginModes: [
            //.allSectionBackgroundView(view: DecorationView.self),
            .sectionBackgroundView([
                1: DecorationView.self,
                3: DecorationView.self,
                5: DecorationView.self,
            ]),
            .fixSupplementaryViewInset
        ])
        sectionView.sectionFlowLayout?.st.register(DecorationView.self)
        
        manager.update(sections)
    }
    
}
