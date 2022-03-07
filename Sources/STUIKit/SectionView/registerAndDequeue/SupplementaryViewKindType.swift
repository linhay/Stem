//
//  File.swift
//  
//
//  Created by linhey on 2022/3/6.
//

import Foundation

#if canImport(UIKit)
import UIKit

/// SupplementaryView regist type
///
/// - header: header
/// - footer: footer
/// - custom: custom
public enum SupplementaryViewKindType: Equatable {
    case header
    case footer
    case custom(_ value: String)
    
    public var rawValue: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        case .custom(let value): return value
        }
    }
}
#endif
