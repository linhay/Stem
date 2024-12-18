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
    func hasItemConform(to type: UTType) -> Bool {
        base.hasItemConformingToTypeIdentifier(type.identifier)
    }

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
    
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    func loadFileRepresentation(for type: UTType) async throws -> URL? {
       try await loadFileRepresentation(for: type.identifier)
    }
    
    func loadFileRepresentation(for typeIdentifier: String) async throws -> URL? {
        try await withUnsafeThrowingContinuation { continuation in
            base.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let url = url else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                try? FileManager.default.removeItem(at: localURL)
                do {
                    try FileManager.default.copyItem(at: url, to: localURL)
                } catch {
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: localURL)
            }
        }
    }
    
}

@available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)
public extension Stem where Base: NSItemProvider {

    func loadObject<T>(ofClass: T.Type) async throws -> T? where T : _ObjectiveCBridgeable, T._ObjectiveCType : NSItemProviderReading {
       try await withCheckedThrowingContinuation { continuation in
          _ = base.loadObject(ofClass: ofClass) { reading, error in
               if let error {
                   continuation.resume(throwing: error)
               } else {
                   continuation.resume(returning: reading)
               }
           }
        }
    }
}
#endif
