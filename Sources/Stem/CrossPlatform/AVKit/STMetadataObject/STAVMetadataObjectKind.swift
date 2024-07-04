//
//  File.swift
//  
//
//  Created by linhey on 2023/12/23.
//

#if canImport(AVFoundation)
import Foundation
import AVFoundation

@dynamicMemberLookup
public enum STMetadataObjectKind: RawRepresentable {
    
    case machineReadable(STMetadataMachineReadableCodeObject)
    case face(STMetadataFaceObject)
    
    public init?(rawValue object: STMetadataObject) {
        if let object = object as? STMetadataMachineReadableCodeObject {
            self = .machineReadable(object)
        } else if let object = object as? STMetadataFaceObject {
            self = .face(object)
        } else {
            return nil
        }
    }
    
    public init?(rawValue object: AVMetadataObject) {
        if let object = object as? AVMetadataMachineReadableCodeObject {
            self = .machineReadable(.init(from: object))
        } else if let object = object as? AVMetadataFaceObject {
            self = .face(.init(from: object))
        } else {
            return nil
        }
    }
    
    public var rawValue: STMetadataObject {
        switch self {
        case .machineReadable(let object):
            return object
        case .face(let object):
            return object
        }
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<STMetadataObject, T>) -> T {
        return rawValue[keyPath: keyPath]
    }
    
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<STMetadataObject, T>) -> T {
        get { rawValue[keyPath: keyPath] }
    }
    
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<STMetadataObject, T>) -> T {
        get { rawValue[keyPath: keyPath] }
        set { rawValue[keyPath: keyPath] = newValue }
    }
    
}
#endif
