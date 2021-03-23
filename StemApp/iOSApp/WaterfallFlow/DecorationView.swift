//
//  DecorationView.swift
//  iOSApp
//
//  Created by 林翰 on 2021/3/23.
//

import UIKit
import Stem

class DecorationView: UICollectionReusableView, STViewProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = StemColor.random.convert()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
