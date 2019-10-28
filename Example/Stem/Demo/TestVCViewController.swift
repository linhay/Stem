//
//  TestVCViewController.swift
//  Stem_Example
//
//  Created by 林翰 on 2019/10/28.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Stem

class TestVCViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        items.append(TableElement(title: "present", subtitle: "") {
            let vc1 = TestVCViewController()
            vc1.contentView.backgroundColor = UIColor.st.random
            let vc2 = TestVCViewController()
            vc2.contentView.backgroundColor = UIColor.st.random
            print(self.st.canPresentVC)
            self.st.canPresentVC?.st.present(vc: vc1)
            print(self.st.canPresentVC)
//            self.st.canPresentVC?.st.present(vc: vc2)
        })
        
        items.append(TableElement(title: "dismiss", subtitle: "") {
            self.dismiss(animated: true, completion: nil)
        })
    }

}
