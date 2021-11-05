//
//  VPageController.swift
//  iOSApp
//
//  Created by 林翰 on 2021/4/4.
//

import UIKit
import Stem

protocol Vchildren {
    
}

class VPageController: UIViewController {
    
    let mainScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if #available(iOS 13.0, *) {
            mainScrollView.backgroundColor = UIColor.init(light: .red, dark: .blue)
        } else {
            // Fallback on earlier versions
        }
    }
    
}
