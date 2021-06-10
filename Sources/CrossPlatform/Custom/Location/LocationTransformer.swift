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
#if canImport(CoreLocation)
import CoreLocation
#endif

public struct LocationTransformer: Equatable, Codable {

    public enum LocationType: Int, Equatable, Codable {
        /// World Geodetic System 1984
        case wgs84
        /// 国家测量局02号标准(火星坐标系)
        case gcj02
        /// 百度坐标系
        case bd09
    }
    
    public struct Coordinate2D: Equatable, Codable {
        public let latitude: Double
        public let longitude: Double
        
        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    
        #if canImport(CoreLocation)
        public init(_ value: CLLocationCoordinate2D) {
            self.init(latitude: value.latitude, longitude: value.longitude)
        }
        
        public func convert() -> CLLocationCoordinate2D {
            .init(latitude: latitude, longitude: longitude)
        }
        #endif
    }
    
    public let type: LocationType
    public let coordinate: Coordinate2D
    
    public init(type: LocationType, coordinate: Coordinate2D) {
        self.type = type
        self.coordinate = coordinate
    }
    
    #if canImport(CoreLocation)
    public func convert() -> CLLocationCoordinate2D { coordinate.convert() }
    #endif
    public var longitude: Double { coordinate.longitude }
    public var latitude: Double { coordinate.latitude }
    
    public func transform(type: LocationType) -> LocationTransformer {
        switch (self.type, type) {
        case (.wgs84, .gcj02):
            if isOutOfChina {
                return self
            }
            let offset = GCJ02Offset(coordinate: coordinate)
            let result = Coordinate2D(latitude: latitude + offset.latitude, longitude: longitude + offset.longitude)
            return .init(type: type, coordinate: result)
        case (.gcj02, .wgs84):
            let offset = LocationTransformer(type: .wgs84, coordinate: coordinate).transform(type: .gcj02)
            let result = Coordinate2D(latitude: latitude * 2 - offset.latitude, longitude: longitude * 2 - offset.longitude)
            return .init(type: type, coordinate: result)
        case (.gcj02, .bd09):
            let x = longitude
            let y = latitude
            let z = sqrt(x * x + y * y) + 0.00002 * sin(y * .pi)
            let theta = atan2(y, x) + 0.000003 * cos(x * .pi)
            let result = Coordinate2D(latitude: z * sin(theta) + 0.006, longitude: z * cos(theta) + 0.0065)
            return .init(type: type, coordinate: result)
        case (.bd09, .gcj02):
            let x = longitude - 0.0065
            let y = latitude - 0.006
            let z = sqrt(x * x + y * y) - 0.00002 * sin(y * .pi)
            let theta = atan2(y, x) - 0.000003 * cos(x * .pi)
            let result = Coordinate2D(latitude: z * sin(theta), longitude: z * cos(theta))
            return .init(type: type, coordinate: result)
        case (.wgs84, .bd09):
           return transform(type: .gcj02).transform(type: type)
        case (.bd09, .wgs84):
            return transform(type: .gcj02).transform(type: type)
        case (.bd09, .bd09):
            return self
        case (.gcj02, .gcj02):
            return self
        case (.wgs84, .wgs84):
            return self
        }
    }

}
 
private extension LocationTransformer {
    
    struct Constant {
        static let A = 6378245.0
        static let EE = 0.00669342162296594323
    }
    
    var isOutOfChina: Bool {
        if (longitude < 72.004 || longitude > 137.8347) {
            return true
        }
        
        if (latitude < 0.8293 || latitude > 55.8271) {
            return true
        }
        
        return false
    }
    
    func GCJ02Offset(coordinate: Coordinate2D) -> Coordinate2D {
        let x = coordinate.longitude - 105.0
        let y = coordinate.latitude - 35.0
        let latitude = (-100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x)))
            + ((20.0 * sin(6.0 * x * .pi) + 20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0)
            + ((20.0 * sin(y * .pi) + 40.0 * sin(y / 3.0 * .pi)) * 2.0 / 3.0)
            + ((160.0 * sin(y / 12.0 * .pi) + 320 * sin(y * .pi / 30.0)) * 2.0 / 3.0)
        let longitude = (300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x)))
            + ((20.0 * sin(6.0 * x * .pi) + 20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0)
            + ((20.0 * sin(x * .pi) + 40.0 * sin(x / 3.0 * .pi)) * 2.0 / 3.0)
            + ((150.0 * sin(x / 12.0 * .pi) + 300.0 * sin(x / 30.0 * .pi)) * 2.0 / 3.0)
        let radLat = 1 - coordinate.latitude / 180.0 * .pi
        var magic = sin(radLat)
        magic = 1 - Constant.EE * magic * magic
        let sqrtMagic = sqrt(magic)
        let dLat = (latitude * 180.0) / ((Constant.A * (1 - Constant.EE)) / (magic * sqrtMagic) * .pi)
        let dLon = (longitude * 180.0) / (Constant.A / sqrtMagic * cos(radLat) * .pi)
        return Coordinate2D(latitude: dLat, longitude: dLon)
    }
    
    
}
