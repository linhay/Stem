//
//  DecorationView.swift
//  iOSApp
//
//  Created by 林翰 on 2021/3/23.
//

import UIKit
import Stem

class DecorationView: UICollectionReusableView, LoadViewProtocol {
    
    let gradientView = STLayerView<CAGradientLayer>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(gradientView)
        gradientView.colors = [UIColor.white.cgColor, StemColor.random.convert() as CGColor]
        gradientView.startPoint = .init(x: 0, y: 0)
        gradientView.endPoint = .init(x: 1, y: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
