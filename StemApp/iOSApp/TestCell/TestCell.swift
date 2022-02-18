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
import Combine

class TestCell: UICollectionViewCell, STViewProtocol, ConfigurableView {
    
    class Model: Equatable, Hashable, SelectableProtocol {
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
            hasher.combine(width)
            hasher.combine(height)
            hasher.combine(ObjectIdentifier(selectableModel))
        }
        
        static func == (lhs: TestCell.Model, rhs: TestCell.Model) -> Bool {
            lhs === rhs
        }
        
        init(selectableModel: SelectableModel = .init(isSelected: false, canSelect: true), title: String, width: CGFloat, height: CGFloat) {
            self.selectableModel = selectableModel
            self.title = title
            self.width = width
            self.height = height
        }
        
        var selectableModel: SelectableModel
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
    
    private var cancellables = Set<AnyCancellable>()
    
    func config(_ model: Model) {
        self.contentView.backgroundColor = StemColor.random.convert()
        model.selectedObservable.sink(on: self) { (self, flag) in
            self.label.text = flag ? "selected" : model.title
        }.store(in: &cancellables)
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
