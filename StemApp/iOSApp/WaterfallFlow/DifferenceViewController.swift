//
//  DifferentViewController.swift
//  iOSApp
//
//  Created by linhey on 2022/2/28.
//

import Foundation
import Stem
import UIKit

class DifferenceCollectionViewController: SectionCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let section = SingleTypeSection<DifferenceCell>()
        section.config(models: [1])

        let wrapper = section.differenceWrapper
        
        wrapper.selectedEvent.delegate(on: self) { (self, _) in
            wrapper.config(models: Array(0...Int.random(in: 10...15)))
        }
        
        wrapper.minimumLineSpacing = 20
        wrapper.minimumInteritemSpacing = 20
        manager.update(wrapper)
    }
    
}

extension DifferenceCollectionViewController {
    
    class DifferenceCell: UICollectionViewCell, ConfigurableView, LoadViewProtocol {
        
        static func preferredSize(limit size: CGSize, model: Int?) -> CGSize {
            return .init(width: 100, height: 100)
        }
        
        private lazy var textLabel: UILabel = {
            let view = UILabel(frame: .zero)
            view.textColor = .red
            view.font = UIFont.systemFont(ofSize: 14)
            return view
        }()
        
        func config(_ model: Int) {
            textLabel.text = "\(model)"
            textLabel.textAlignment = .center
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addSubview(textLabel)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            contentView.layer.borderColor = UIColor.blue.cgColor
            contentView.layer.borderWidth = 1
            textLabel.frame = contentView.bounds
        }
        
    }
    
}
