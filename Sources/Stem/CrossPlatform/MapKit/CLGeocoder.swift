//
//  File.swift
//  
//
//  Created by linhey on 2022/11/17.
//

#if canImport(CoreLocation) && canImport(Combine)
import Foundation
import CoreLocation
import Combine

public extension Stem where Base: CLGeocoder {
    func reverseGeocode(location: CLLocation) -> any Publisher<[CLPlacemark], Error> {
        Future { [weak base] promise in
            guard let base = base else {
                promise(.success([]))
                return
            }
            base.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(placemarks ?? []))
                }
            }
        }
    }
    
    func reverseGeocode(location: CLLocation) async throws -> [CLPlacemark] {
       try await withUnsafeThrowingContinuation { continuation in
            base.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: placemarks ?? [])
                }
            }
        }
    }
}
#endif
