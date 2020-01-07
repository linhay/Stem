//
//  MainViewController.swift
//  Stem_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Stem

class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.removeFromSuperview()
        tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        func addCell(vc: UIViewController.Type) {
            let title = vc.description()
                .split(separator: ".").last!
                .replacingOccurrences(of: "ViewController", with: "")
                .replacingOccurrences(of: "Controller", with: "")
                .replacingOccurrences(of: "Test", with: "")
            items.append(TableElement(title: title, subtitle: "") { [weak self] in
                guard let self = self else { return }
                self.st.push(vc: vc.init())
            })
        }
        
        [TestImageViewController.self,
         TestImageColorController.self,
         TestButtonViewController.self,
         TestCALayerViewController.self,
         TestGestureViewController.self,
         TestVideoViewController.self,
         TestInputViewController.self,
         TestNavbar01ViewController.self,
         TestVCViewController.self].forEach({ addCell(vc: $0) })
        
    }
    
}
