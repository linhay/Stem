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
        case cmykAverage([CMYKSpace])
        case kubelkaMunk([RGBSpace])
    }

    private static func cmykAverage(with colors: [CMYKSpace]) -> CMYKSpace? {
        if colors.isEmpty {
            return nil
        }
        return CMYKSpace.average(colors)
    }

    private static func kubelkaMunk(with colors: [RGBSpace]) -> RGBSpace? {

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
            .map(\.list)
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

        return RGBSpace(list)
    }
    
    static func mix(use mixer: Mixer) -> StemColor? {
        switch mixer {
        case .kubelkaMunk(let colors):
            if let value = kubelkaMunk(with: colors) {
                return .init(rgb: value)
            }
        case .cmykAverage(let colors):
            if let value = cmykAverage(with: colors) {
                return .init(cmyk: value)
            }
        }
        return nil
    }
    
    func mix(use mixer: Mixer) -> StemColor {
        StemColor.mix(use: mixer) ?? self
    }

}
