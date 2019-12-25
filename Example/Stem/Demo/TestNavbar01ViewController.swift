//
//  TestNavbar01ViewController.swift
//  Stem_Example
//
//  Created by 林翰 on 2019/10/10.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Stem

class TestNavbar01ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        items.append(TableElement(title: "回退", subtitle: "") { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        })

        items.append(TableElement(title: "push: setNavigationBarHidden == false", subtitle: "") { [weak self] in
            guard let self = self else { return }
            let vc = TestNavbar01ViewController()
            vc.st.setNavigationBarHiddenWhenAppear = false
            self.navigationController?.st.push(vc: vc)
        })

        items.append(TableElement(title: "push: setNavigationBarHidden == true", subtitle: "") { [weak self] in
            guard let self = self else { return }
            let vc = TestNavbar01ViewController()
            vc.st.setNavigationBarHiddenWhenAppear = true
            self.navigationController?.st.push(vc: vc)
        })

        items.append(TableElement(title: "current: setNavigationBarHidden(true, animated: true)", subtitle: "") { [weak self] in
            guard let self = self else { return }
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        })

        items.append(TableElement(title: "current: setNavigationBarHidden(false, animated: true)", subtitle: "") { [weak self] in
            guard let self = self else { return }
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        })
    }

}
