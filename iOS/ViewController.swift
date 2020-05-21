//
//  ViewController.swift
//  iOS
//
//  Created by 林翰 on 2020/1/8.
//  Copyright © 2020 linhey.pod.template.ios. All rights reserved.
//

import Foundation
import UIKit
import Stem

let aEvent = Event<Void>(key: "a")

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.pushViewController(AVC(), animated: true)
    }

}

class AVC: UIViewController {

    let tokens = EventTokens()
    var name: String = "AVC"
    let pusherBtn = UIButton(frame: CGRect(x: 30, y: 200, width: 200, height: 60))
    let acceptBtn = UIButton(frame: CGRect(x: 30, y: 400, width: 200, height: 60))

    override func viewDidLoad() {
        super.viewDidLoad()
        pusherBtn.setTitle("push", for: .normal)
        acceptBtn.setTitle("accept", for: .normal)
        view.st.addSubviews(pusherBtn, acceptBtn)
        view.backgroundColor = UIColor.st.random

        aEvent.subscribe(using: { [weak self] _ in
            guard let self = self else {
                return
            }
            print(self.name)
        }).disposed(tokens)

        pusherBtn.st.add(for: .touchUpInside) { [weak self] _ in
            guard let self = self else {
                return
            }
            let vc = AVC()
            vc.st.observeDeinit {
                print("deinit: jaaa")
            }
            vc.name = self.name + "0"
            self.navigationController?.pushViewController(vc, animated: true)
        }

        acceptBtn.st.add(for: .touchUpInside) { _ in
            aEvent.accept(nil)
        }
    }

}

