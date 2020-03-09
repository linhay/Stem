//
//  ViewController.swift
//  macOS
//
//  Created by 林翰 on 2020/1/8.
//  Copyright © 2020 linhey.pod.template.ios. All rights reserved.
//

import Cocoa
import Stem

let aEvent = Event<Void>(key: "aa")

class ViewController: NSViewController {

    @IBAction func test(_ sender: Any) {
        aEvent.accept(nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        aEvent.subscribe(observer: self) {_ in
            print("ViewController")
        }
    }

}


class AViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        aEvent.subscribe(observer: self) { _ in
            print("AViewController")
        }
    }

}


class BViewController: NSViewController {

    @IBAction func pusher(_ sender: NSButton) {
        aEvent.accept(nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        aEvent.subscribe(observer: self) { _ in
            print("BViewController")
        }
    }

}
