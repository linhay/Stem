// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
