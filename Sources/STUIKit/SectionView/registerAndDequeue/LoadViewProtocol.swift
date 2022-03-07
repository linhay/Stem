//
//  LoadViewProtocol.swift
//  iDxyer
//
//  Created by 林翰 on 2020/7/8.
//

#if canImport(UIKit)
import UIKit

public protocol LoadViewProtocol: UIView {
    static var identifier: String { get }
    static var nib: UINib? { get }
}

public extension LoadViewProtocol {

    static var identifier: String {
        return String(describing: Self.self)
    }
    static var nib: UINib? {
        return nil
    }

}
#endif
