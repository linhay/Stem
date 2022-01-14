//
//  WaterfallFlowCell.swift
//  iOS
//
//  Created by 林翰 on 2020/12/10.
//  Copyright © 2020 linhey.ax. All rights reserved.
//

import UIKit
import Stem
import SnapKit

class TestCell: UICollectionViewCell, STViewProtocol, ConfigurableView {
    
    struct Model: Equatable, Hashable {
        let title: String
        let width: CGFloat
        let height: CGFloat
    }
    
    static func preferredSize(limit size: CGSize, model: Model?) -> CGSize {
        guard let model = model else { return .zero }
        return .init(width: size.width, height: model.height)
    }
    
    let label: UILabel = {
        let item = UILabel()
        item.textAlignment = .center
        item.textColor = .white
        item.font = .systemFont(ofSize: 20, weight: .medium)
        return item
    }()
    
    func config(_ model: Model) {
        label.text = model.title
        contentView.backgroundColor = StemColor.random.convert()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.black.cgColor
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
