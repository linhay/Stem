//
//  HomeViewController.swift
//  iOS
//
//  Created by 林翰 on 2021/3/1.
//  Copyright © 2021 linhey.ax. All rights reserved.
//

import UIKit
import Stem
import Foundation


class HomeViewController: SectionCollectionViewController {
    
    lazy var section = SingleTypeSection<HomeCell>([
        .init(title: "STWaterfallFlowLayout", action: {
            self.st.push(WaterfallFlowViewController())
        }),
        .init(title: "SingleTypeSection", action: {
            self.st.push(SingleTypeSectionViewController())
        })
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        section.selectedEvent.delegate(on: self) { (self, model) in
            model.action()
        }
        section.sectionInset = .init(top: 20, left: 20, bottom: 0, right: 20)
        section.minimumLineSpacing = 16
        section.minimumInteritemSpacing = 16
        
        manager.update(section)
    }
    
}
