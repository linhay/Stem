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

class ViewController: UITableViewController {

    @IBAction func Notice(_ sender: UIButton) {
        st.push(vc: NoticeViewController())
    }

}
