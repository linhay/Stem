//
//  StemColorSpacePack.swift
//  Pods-macOS
//
//  Created by 林翰 on 2020/9/1.
//

import Foundation

public protocol StemColorSpacePack {

    associatedtype UnPack
    var unpack: UnPack { get }
    var list: [Double] { get }
    init(_ list: [Double])
    init()
    
}

extension StemColorSpacePack {

    func average(with spaces: [Self]) -> Self {
        return ([self] + spaces).averageItem!
    }

}

extension Array where Element: StemColorSpacePack {

    var averageItem: Element? {
        let count = Double(self.count)
        let values = self.map(\.list)

        guard let firstItem = values.first else {
            return nil
        }

        let list = values
            .dropFirst()
            .reduce(firstItem) { (item, result) -> [Double] in
                var result = result
                for index in 0..<item.count {
                    result[index] += item[index]
                }
                return result
        }
        .map { $0 / count }
        return .init(list)
    }

}
