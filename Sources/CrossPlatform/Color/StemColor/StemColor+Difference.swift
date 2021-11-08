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
    
    enum Difference {
        case cie76(StemColor)
        case cie94(StemColor, CIE94Values)
        case ciede2000(StemColor)
    }
    
    struct CIE94Values {
        
        public static let graphicArts = CIE94Values(kL: 1, k1: 0.045, k2: 0.015)
        public static let textiles    = CIE94Values(kL: 2, k1: 0.048, k2: 0.014)
        
        let kL: Double
        let k1: Double
        let k2: Double
    }
    
    func difference(_ type: Difference) -> Double {
        switch type {
        case .cie94(let color, let values):
            return Self.differenceCIE94(labSpace, color.labSpace, values: values)
        case .ciede2000(let color):
            return Self.differenceCIEDE2000(labSpace, color.labSpace)
        case .cie76(let color):
            return Self.differenceCIE76(labSpace, color.labSpace)
        }
    }
    
}

public extension StemColor {
    
    static func differenceCIE76(_ lhs: CIELABSpace, _ rhs: CIELABSpace) -> Double {
        return sqrt(pow(lhs.l - rhs.l, 2)
                    + pow(lhs.a - rhs.a, 2)
                    + pow(lhs.b - rhs.b, 2))
    }
    
    static func differenceCIE94(_ lhs: CIELABSpace, _ rhs: CIELABSpace, values: CIE94Values) -> Double {
        
        let kC = 1.0
        let kH = 1.0
        
        let kL = values.kL
        let k1 = values.k1
        let k2 = values.k2
        
        let c1 = sqrt(pow(lhs.a, 2) + pow(lhs.b, 2))
        
        let sL = 1.0
        let sC = 1 + k1 * c1
        let sH = 1 + k2 * c1
        
        let deltaL = lhs.l - rhs.l
        let deltaA = lhs.a - rhs.a
        let deltaB = lhs.b - rhs.b
        
        let c2 = sqrt(pow(rhs.a, 2) + pow(rhs.b, 2))
        let deltaCab = c1 - c2
        
        let deltaHab = sqrt(pow(deltaA, 2) + pow(deltaB, 2) - pow(deltaCab, 2))
        
        let p1 = pow(deltaL   / (kL * sL), 2)
        let p2 = pow(deltaCab / (kC * sC), 2)
        let p3 = pow(deltaHab / (kH * sH), 2)
        
        let deltaE = sqrt(p1 + p2 + p3)
        
        return deltaE
    }
    
    /*
     CIEDE2000 color difference, original Matlab implementation by Gaurav Sharma
     Based on "The CIEDE2000 Color-Difference Formula: Implementation Notes, Supplementary Test Data, and Mathematical Observations"
     by Gaurav Sharma, Wencheng Wu, Edul N. Dalal in Color Research and Application, vol. 30. No. 1, pp. 21-30, February 2005.
     http://www2.ece.rochester.edu/~gsharma/ciede2000/
     */
    static func differenceCIEDE2000(_ lhs: CIELABSpace, _ rhs: CIELABSpace) -> Double {
        
        func degrees(_ n: Double) -> Double { return n*(180 / Double.pi) }
        func radians(_ n: Double) -> Double { return n*(Double.pi / 180) }
        
        func a_hp_f(_ C1: Double, _ C2: Double, _ h1p: Double, _ h2p: Double) -> Double {
            if C1*C2 == 0 { return h1p+h2p }
            if abs(h1p-h2p) <= 180                        { return (h1p+h2p)/2.0 }
            if (abs(h1p-h2p) > 180) && ((h1p+h2p) < 360)  { return (h1p+h2p+360)/2.0 }
            if (abs(h1p-h2p) > 180) && ((h1p+h2p) >= 360) { return (h1p+h2p-360)/2.0 }
            return .nan
        }
        
        func dhp_f(_ C1: Double, _ C2: Double, _ h1p: Double, _ h2p: Double) -> Double {
            if C1 * C2 == 0 { return 0 }
            if abs(h2p-h1p) <= 180 { return h2p-h1p }
            if (h2p-h1p) > 180 { return (h2p-h1p)-360 }
            if (h2p-h1p) < -180 { return (h2p-h1p)+360 }
            return .nan
        }
        
        func hp_f(_ x: Double, _ y: Double) -> Double {
            
            if(x == 0 && y == 0) {
                return 0
            }
            
            let tmphp = degrees(atan2(x,y));
            
            if(tmphp >= 0) {
                return tmphp
            }
            
            return tmphp + 360
        }
        
        let L1 = lhs.l
        let a1 = lhs.a
        let b1 = lhs.b
        
        let L2 = rhs.l
        let a2 = rhs.a
        let b2 = rhs.b
        
        let kL = 1.0
        let kC = 1.0
        let kH = 1.0
        
        let C1 = sqrt(pow(a1, 2) + pow(b1, 2))
        let C2 = sqrt(pow(a2, 2) + pow(b2, 2))
        
        let a_C1_C2 = (C1+C2) / 2.0
        
        let G = 0.5 * (1 - sqrt(pow(a_C1_C2 , 7.0) / (pow(a_C1_C2, 7.0) + pow(25.0, 7.0))))
        
        let a1p = (1.0 + G) * a1
        let a2p = (1.0 + G) * a2
        
        let C1p = sqrt(pow(a1p, 2) + pow(b1, 2))
        let C2p = sqrt(pow(a2p, 2) + pow(b2, 2))
        
        let h1p = hp_f(b1, a1p)
        let h2p = hp_f(b2, a2p)
        
        let dLp = L2 - L1
        let dCp = C2p - C1p
        
        let dhp = dhp_f(C1,C2, h1p, h2p)
        let dHp = 2 * sqrt(C1p*C2p) * sin(radians(dhp) / 2.0)
        
        let a_L = (L1 + L2) / 2.0
        let a_Cp = (C1p + C2p) / 2.0
        
        let a_hp = a_hp_f(C1,C2,h1p,h2p)
        
        let T = 1
        - 0.17 * cos(radians(a_hp - 30))
        + 0.24 * cos(radians(2 * a_hp))
        + 0.32 * cos(radians(3 * a_hp + 6))
        - 0.20 * cos(radians(4 * a_hp - 63))
        
        let d_ro = 30 * exp(-(pow((a_hp-275) / 25, 2)))
        let RC = sqrt(pow(a_Cp, 7.0) / (pow(a_Cp, 7.0) + pow(25.0, 7.0)))
        
        let SL = 1 + (0.015 * pow(a_L - 50, 2)) / sqrt(20 + pow(a_L - 50, 2.0))
        let SC = 1 + 0.045 * a_Cp
        let SH = 1 + 0.015 * a_Cp * T
        
        let RT = -2 * RC * sin(radians(2 * d_ro))
        
        return sqrt(pow(dLp / (SL * kL), 2)
                    + pow(dCp / (SC * kC), 2)
                    + pow(dHp / (SH * kH), 2)
                    + RT * (dCp / (SC * kC))
                    * (dHp / (SH * kH)))
    }
    
}
