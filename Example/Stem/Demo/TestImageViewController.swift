//
//  TestImageViewController.swift
//  Stem_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Then
import Stem
import SnapKit

class TestImageViewController: BaseViewController {
  
  let imageView = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.addSubview(imageView)
    
    imageView.do { (item) in
      item.snp.makeConstraints({ (make) in
        make.top.left.equalToSuperview().offset(8)
        make.bottom.right.equalToSuperview().offset(-8)
      })
    }
    
    items.append(TableElement(title: "复原", subtitle: "") {
      self.imageView.st.removeSubviews()
      self.imageView.image = nil
    })
    
    items.append(TableElement(title: "从网络上下载图片", subtitle: "imageView.st.download(from: url,placeholder: image,completionHandler: nil)") {
      let url = URL(string: "https://s.linhey.com/hexo-docker-1.png")!
      self.imageView.st.download(from: url,
                            placeholder: UIImage(named: "loading"),
                            completionHandler: nil)
    })
    
    items.append(TableElement(title: "毛玻璃效果", subtitle: "imageView.st.blur()") {
      self.imageView.st.blur()
    })
    
  }
  
}
