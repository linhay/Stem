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

/// https://en.wikipedia.org/wiki/Standard_illuminant
/// https://search.r-project.org/CRAN/refmans/colorSpec/html/00Index.html
public struct CIEStandardIlluminants: StemColorSpace {

    let x: Double
    let y: Double
    let z: Double
    
    init(_ rawValue: [Double]) {
        x = rawValue[0]
        y = rawValue[1]
        z = rawValue[2]
    }

    /// A (ASTM E308-01)
    /// Simulates typical, domestic, tungsten-filament lighting with correlated color temperature of 2856 K.
    public static let A   = CIEStandardIlluminants([1.09850, 1.0, 0.3558500])
    /// B (Wyszecki & Stiles, p. 769)
    public static let B   = CIEStandardIlluminants([0.99072, 1.0, 0.85223])
    /// C (ASTM E308-01)
    /// Simulates average or north sky daylight with correlated color temperature of 6774 K. Deprecated by CIE.
    public static let C   = CIEStandardIlluminants([0.98074, 1.0, 1.18232])
    /// D50 (ASTM E308-01)
    public static let D50 = CIEStandardIlluminants([0.96422, 1.0, 0.8252100])
    /// D50.ICC
    public static let D50ICC = CIEStandardIlluminants([0.9642029, 1.0, 0.8249054])
    /// D55 (ASTM E308-01)
    public static let D55 = CIEStandardIlluminants([0.95682, 1.0, 0.92149])
    /// D65/2° (ASTM E308-01)
    public static let D65 = CIEStandardIlluminants([0.9504700, 1.0, 1.0888300])
    /// D75 (ASTM E308-01)
    public static let D75 = CIEStandardIlluminants([0.94972, 1.0, 1.22638])
    /// E (ASTM E308-01)
    public static let E   = CIEStandardIlluminants([1.00000, 1.0, 1.00000])
    /// F2 (ASTM E308-01)
    public static let F2  = CIEStandardIlluminants([0.99186, 1.0, 0.67393])
    /// F7 (ASTM E308-01)
    public static let F7  = CIEStandardIlluminants([0.95041, 1.0, 1.08747])
    /// F11 (ASTM E308-01)
    public static let F11 = CIEStandardIlluminants([1.00962, 1.0, 0.64350])

}
