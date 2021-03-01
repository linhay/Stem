//
//  WaterfallFlowCell.swift
//  iOS
//
//  Created by 林翰 on 2020/12/10.
//  Copyright © 2020 linhey.ax. All rights reserved.
//

import UIKit
import Stem

class TestIndexPathCell: UICollectionViewCell, STViewProtocol, ConfigurableView {
    
    struct Model {
        let indexPath: IndexPath
        let color: StemColor = .random
        let size: CGSize
    }
    
    static func preferredSize(limit size: CGSize, model: Model?) -> CGSize {
        return model?.size ?? .zero
    }
    
    let label = UILabel()
    
    func config(_ model: Model) {
        label.text = "\(model.indexPath.section) - \(model.indexPath.item)"
        contentView.backgroundColor = model.color.convert()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
