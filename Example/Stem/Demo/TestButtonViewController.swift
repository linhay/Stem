//
//  TestButtonViewController.swift
//  Stem_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Stem

class TestButtonViewController: BaseViewController {
  
  
  let button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(color: UIColor.red, size: CGSize(width: 15, height: 15)), for: UIControl.State.normal)
    button.setTitle("文字文字文", for: UIControl.State.normal)
    button.setTitleColor(UIColor.black, for: UIControl.State.normal)
    return button
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.addSubview(button)
    
    button.do { (item) in
      item.snp.makeConstraints({ (make) in
        make.center.equalTo(self.contentView.snp.center)
      })
    }
    
    items.append(TableElement(title: "图片与文字垂直居中",
                              subtitle: "button.st.verticalCenterImageAndTitle(spacing: 5)") {
                                self.button.st.verticalCenterImageAndTitle(spacing: 5)
    })
    
    items.append(TableElement(title: "文字与图片水平居中",
                              subtitle: "button.st.horizontalCenterTitleAndImage(spacing: 5)") {
      self.button.st.horizontalCenterTitleAndImage(spacing: 5)
    })

  }
  
}
