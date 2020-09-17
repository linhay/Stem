//
//  NumberFormatter.swift
//  Stem
//
//  Created by 林翰 on 2020/9/17.
//

import Foundation

public extension Stem where Base: NumberFormatter {

    func string(from value: Int8) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: UInt8) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: Int32) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: UInt32) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: Int64) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: UInt64) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: Float) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: Double) -> String? {
        return base.string(from: .init(value: value))
    }

    func string(from value: Bool) -> String? {
        return base.string(from: .init(value: value))
    }

    @available(macOS 10.5, *)
    func string(from value: Int) -> String? {
        return base.string(from: .init(value: value))
    }

    @available(macOS 10.5, *)
    func string(from value: UInt) -> String? {
        return base.string(from: .init(value: value))
    }

}
