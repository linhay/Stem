//
//  TestImageController.swift
//  Stem_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Stem

class TestImageController: BaseViewController {
  
  let image = UIImage(named: "lena")!
  let imageView = UIImageView(image: UIImage(named: "lena")).then { (item) in
    item.contentMode = UIView.ContentMode.center
  }
  
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
      self.imageView.image = self.image
    })
    
    items.append(TableElement(title: "图像处理: 裁圆", subtitle: "image.st.rounded()") {
      self.imageView.image = self.image.st.rounded()
    })
    
    items.append(TableElement(title: "获取指定颜色的图片", subtitle: "UIImage(color: UIColor,size: CGSize)") {
      let image = UIImage(color: UIColor.red, size: CGSize(width: 50, height: 50))
      self.imageView.image = image
    })
    
    items.append(TableElement(title: "裁剪对应区域", subtitle: "image.st.crop(bound: CGRect)") {
      let image = self.image.st.crop(bound: CGRect(x: 0,
                                                   y: 0,
                                                   width: self.image.size.width * 0.5,
                                                   height: self.image.size.height * 0.5))
      self.imageView.image = image
    })
    
    items.append(TableElement(title: "图像处理: 圆角", subtitle: "image.st.round(...)") {
      let image = self.image.st.rounded(radius: self.image.size.width * 0.5,
                                        corners: [.topRight,.bottomRight],
                                        borderWidth: 8,
                                        borderColor: UIColor.white,
                                        borderLineJoin: CGLineJoin.bevel)
      self.imageView.image = image
    })
    
    items.append(TableElement(title: "缩放至指定宽度", subtitle: "image.st.scaled(toWidth: CGFloat)") {
      let image = self.image.st.scaled(toWidth: 50)
      self.imageView.image = image
    })
    
    items.append(TableElement(title: "缩放至指定高度", subtitle: "image.st.scaled(toHeight: CGFloat)") {
      let image = self.image.st.scaled(toHeight: 80)
      self.imageView.image = image
    })
  }
  
}
