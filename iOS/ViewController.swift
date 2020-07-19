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

    @IBAction func colors(_ sender: UIButton) {
        var image = UIImage(named: "colors")
        image = image?.st.scale(toWidth: image?.size.width ?? 0)
        let pixels = image?.st.pixels
        print(pixels?.count)
        pixels?.forEach({ color in
            print(color.st.hexString)
        })
    }

}
