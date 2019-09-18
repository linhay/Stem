//
//  TestButtonViewController.swift
//  Stem_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Stem
import SVProgressHUD

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
                                  subtitle: "button.st.verticalCenterImageAndTitle(spacing: 5)") { [weak self] in
                                    self?.button.st.verticalCenterImageAndTitle(spacing: 5)
        })

        items.append(TableElement(title: "文字与图片水平居中",
                                  subtitle: "button.st.horizontalCenterTitleAndImage(spacing: 5)") { [weak self] in
                                    self?.button.st.horizontalCenterTitleAndImage(spacing: 5)
        })

        items.append(TableElement(title: "点击事件",
                                  subtitle: "button.st.add(for: .touchUpInside, action: (btn) -> Void)") { [weak self] in
                                    self?.button.st.add(for: .touchUpInside, action: { (btn) in
                                        self?.contentView.backgroundColor = UIColor.st.random
                                    })
        })

        items.append(TableElement(title: "点击事件间隔",
                                  subtitle: "button.st.eventInterval = 5") { [weak self] in
                                    self?.button.st.eventInterval = 5
                                    self?.button.st.set(timeoutEvent: { (item) in
                                        SVProgressHUD.showSuccess(withStatus: item.st.lastEventTime.debugDescription)
                                    })

        })
    }

}
