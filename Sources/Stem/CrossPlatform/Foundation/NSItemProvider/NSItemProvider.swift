//
//  File.swift
//  
//
//  Created by linhey on 2022/6/28.
//

#if canImport(UniformTypeIdentifiers)
import Foundation
import UniformTypeIdentifiers

public extension Stem where Base: NSItemProvider {

    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    func loadDataRepresentation(for type: UTType) async throws -> Data? {
       try await loadDataRepresentation(for: type.identifier)
    }
    
    func loadDataRepresentation(for typeIdentifier: String) async throws -> Data? {
        try await withUnsafeThrowingContinuation { continuation in
            base.loadDataRepresentation(forTypeIdentifier: typeIdentifier) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: data)
                }
            }
        }
    }
    
}
#endif
