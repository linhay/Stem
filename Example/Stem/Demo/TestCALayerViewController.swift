//
//  TestButtonViewController.swift
//  Stem_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Stem

class TestCALayerViewController: BaseViewController {


    let noneLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        items.append(TableElement(title: "inset",
                                  subtitle: "gesture.st.add({ (item) in ...})") {
                                    self.noneLayer.removeFromSuperlayer()
                                    self.noneLayer.backgroundColor = UIColor.st.random.cgColor
                                    self.contentView.layer.addSublayer(self.noneLayer)
//                                    self.noneLayer.st.inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        })

        items.append(TableElement(title: "contentView.frame.size.height += 10", subtitle: "") {
                                    self.contentView.frame.size.height += 10
        })

        items.append(TableElement(title: "contentView.frame.size.height -= 10", subtitle: "") {
                                    self.contentView.frame.size.height -= 10
        })


    }

}
