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

        items.append(TableElement(title: "UIView", subtitle: "") {

        })

        items.append(TableElement(title: "UIImageView", subtitle: "") {[weak self] in
            guard let base = self else { return }
            let vc = TestImageViewController()
            base.st.push(vc: vc)
        })

        items.append(TableElement(title: "UIImage", subtitle: "") { [weak self] in
            guard let base = self else { return }
            let vc = TestImageController()
            base.st.push(vc: vc)
        })

        items.append(TableElement(title: "UIImage-UIColor", subtitle: "") {[weak self] in
            guard let base = self else { return }
            let vc = TestImageColorController()
            base.st.push(vc: vc)
        })

        items.append(TableElement(title: "UIButton", subtitle: "") {[weak self] in
            guard let base = self else { return }
            let vc = TestButtonViewController()
            base.st.push(vc: vc)
        })

        items.append(TableElement(title: "Gesture", subtitle: "") {[weak self] in
            guard let base = self else { return }
            let vc = TestGestureViewController()
            base.st.push(vc: vc)
        })

        items.append(TableElement(title: "CALayer", subtitle: "") {[weak self] in
            guard let base = self else { return }
            let vc = TestCALayerViewController()
            base.st.push(vc: vc)
        })

        items.append(TableElement(title: "Video", subtitle: "") {[weak self] in
            guard let base = self else { return }
            let vc = TestVideoViewController()
            base.st.push(vc: vc)
        })

        items.append(TableElement(title: "Input", subtitle: "") {[weak self] in
            guard let base = self else { return }
            let vc = TestInputViewController()
            base.st.push(vc: vc)
        })

        items.append(TableElement(title: "Navbar", subtitle: "") {[weak self] in
            guard let base = self else { return }
            let vc = TestNavbar01ViewController()
            base.st.push(vc: vc)
        })

    }

}
