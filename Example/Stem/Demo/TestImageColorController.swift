//
//  TestImageColorController.swift
//  Stem_Example
//
//  Created by linhey on 2019/1/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Accelerate.vImage
import Stem

class TestImageColorController: BaseViewController {
    
    
    let image = UIImage(named: "torch")!
    let imageView = UIImageView(image: UIImage(named: "torch")).then { (item) in
        item.contentMode = UIView.ContentMode.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.masksToBounds = true
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
        
        items.append(TableElement(title: "修改单色系图片颜色", subtitle: "image.st.setTint(color: .red)") {
            self.imageView.image = self.image.st.setTint(color: .red)
        })
        
        //      items.append(TableElement(title: "高斯模糊", subtitle: "image.st.blur(value: 80)") {
        //        self.imageView.image = self.image.st.blur(value: 80)
        //      })
    }

    
}
