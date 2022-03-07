//
//  LoadNibProtocol.swift
//  iDxyer
//
//  Created by 林翰 on 2020/7/8.
//

#if canImport(UIKit)
import UIKit

public protocol LoadNibProtocol: LoadViewProtocol { }

public extension LoadNibProtocol {

    static var id: String {
        return String(describing: Self.self)
    }

    static var nib: UINib? {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }

    static var loadFromNib: Self {
        return nib!.instantiate(withOwner: nil, options: nil)[0] as! Self
    }

}
#endif
