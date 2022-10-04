//
//  File.swift
//  
//
//  Created by linhey on 2022/9/8.
//

import UIKit

public extension Stem where Base: UIStackView {
    
    func addArrangedSubview(_ views: UIView...) {
        addArrangedSubview(views)
    }
    
    func addArrangedSubview(_ views: [UIView]) {
        views.forEach { view in
            base.addArrangedSubview(view)
        }
    }
    
}
