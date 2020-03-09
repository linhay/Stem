//
//  ViewController.swift
//  iOS
//
//  Created by 林翰 on 2020/1/8.
//  Copyright © 2020 linhey.pod.template.ios. All rights reserved.
//

import UIKit
import Stem

let aEvent = Event<Void>(key: "a")

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.pushViewController(AVC(), animated: true)
    }


    class AVC: UIViewController {

        var name: String = "AVC"
        let pusherBtn = UIButton(frame: CGRect(x: 30, y: 200, width: 200, height: 60))
        let acceptBtn = UIButton(frame: CGRect(x: 30, y: 400, width: 200, height: 60))
        var token: EventToken?

        deinit {
            print("deinit: \(name)")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            pusherBtn.setTitle("present", for: .normal)
            acceptBtn.setTitle("dismiss", for: .normal)
            view.st.addSubviews(pusherBtn, acceptBtn)
            view.backgroundColor = UIColor.st.random

            token = aEvent.subscribe(using: { [weak self] _ in
                guard let self = self else {
                    return
                }
                print(self.name)
            })

            pusherBtn.st.add(for: .touchUpInside) { [weak self] _ in
                guard let self = self else {
                    return
                }
                let vc = AVC()
                vc.name = self.name + "0"
                self.navigationController?.pushViewController(vc, animated: true)
            }

            acceptBtn.st.add(for: .touchUpInside) { _ in
                aEvent.accept(nil)
            }
        }

    }

}

