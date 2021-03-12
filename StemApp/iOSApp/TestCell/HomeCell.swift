//
//  HomeCell.swift
//  iOSApp
//
//  Created by 林翰 on 2021/3/12.
//

import UIKit
import Stem

class HomeCell: UICollectionViewCell, STViewProtocol, ConfigurableView {
    
    static func preferredSize(limit size: CGSize, model: Model?) -> CGSize {
        return .init(width: size.width, height: 44)
    }
    
    struct Model {
        let title: String
        let action: () -> Void
    }
    
    private let label: UILabel = {
        let item = UILabel()
        item.textAlignment = .center
        item.textColor = .black
        item.font = .systemFont(ofSize: 20, weight: .medium)
        return item
    }()
    
    func config(_ model: Model) {
        label.text = model.title
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
