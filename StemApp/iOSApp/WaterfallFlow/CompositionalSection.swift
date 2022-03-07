//
//  coSection.swift
//  iOSApp
//
//  Created by linhey on 2022/2/14.
//

import UIKit
import Stem

class CompositionalSection<Cell: UICollectionViewCell & ConfigurableView & LoadViewProtocol>: SingleTypeCompositionalSection<Cell> {
    
    override func config(sectionView: UICollectionView) {
        super.config(sectionView: sectionView)
        register(DecorationView.self, for: .custom(UICollectionView.elementKindSectionHeader))
    }
    
    override func compositionalLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        let _: CGFloat = 1 / 5
        let inset: CGFloat = 2.5

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(88))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
}
