//
//  TestButtonViewController.swift
//  Stem_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Stem

class TestGestureViewController: BaseViewController {
  
  
  let testView: UIView = {
    let item = UIView()
    item.translatesAutoresizingMaskIntoConstraints = false
    item.backgroundColor = UIColor.blue
    return item
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.addSubview(testView)
    
    testView.do { (item) in
      item.snp.makeConstraints({ (make) in
        make.center.equalTo(self.contentView.snp.center)
        make.width.height.equalTo(200)
      })
    }
    
    items.append(TableElement(title: "UITapGestureRecognizer",
                              subtitle: "gesture.st.add({ (item) in ...})") {

                                let ges = UITapGestureRecognizer()
                                self.testView.addGestureRecognizer(ges)
                                ges.st.add({ (gesture) in
                                    self.testView.backgroundColor = UIColor.random
                                })

    })

  }
  
}
