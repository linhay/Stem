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

public extension StemColor {

    enum Mixer {
        case cmykAverage([StemColor])
        case kubelkaMunk([StemColor])
    }

    private static func cmykAverage(with colors: [StemColor]) -> StemColor? {
        if colors.isEmpty {
            return nil
        }
        return .init(cmyk: CMYKSpace.average(colors.map(\.cmykSpace)))
    }

    private static func kubelkaMunk(with colors: [StemColor]) -> StemColor? {

        if colors.isEmpty {
            return nil
        }

        func absorbance(_ value: Double) -> Double {
            return pow(1 - value, 2) / (2.0 * value)
        }

        func reflectance(_ value: Double) -> Double {
            return 1.0 + value - sqrt(pow(value, 2) + 2 * value)
        }

        let concentration = 1.0 / Double(colors.count)

        let list = colors
            .map(\.rgbSpace.list)
            .map { $0
                .map({ max($0, 0.00001) * concentration })
//                .map { absorbance($0) }
            }
            .reduce([0.0, 0.0, 0.0]) { (item, result) -> [Double] in
                var result = result
                result[0] += item[0]
                result[1] += item[1]
                result[2] += item[2]
                return result
            }
            .map { reflectance($0) }


        let space = RGBSpace(list)
        return .init(rgb: space)
    }

    func mix(use mixer: Mixer) -> StemColor {
        switch mixer {
        case .kubelkaMunk(let colors):
            return Self.kubelkaMunk(with: [self] + colors) ?? self
        case .cmykAverage(let colors):
            return Self.cmykAverage(with: [self] + colors) ?? self
        }
    }

    static func mix(use mixer: Mixer) -> StemColor? {
        switch mixer {
        case .kubelkaMunk(let colors):
            return kubelkaMunk(with: colors)
        case .cmykAverage(let colors):
            return cmykAverage(with: colors)
        }
    }

}
