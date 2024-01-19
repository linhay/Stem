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
public enum STAVMetadataObject: RawRepresentable {
    
    case machineReadable(AVMetadataMachineReadableCodeObject)
    case face(AVMetadataFaceObject)
    
    public init?(rawValue object: AVMetadataObject) {
        if let object = object as? AVMetadataMachineReadableCodeObject {
            self = .machineReadable(object)
        } else if let object = object as? AVMetadataFaceObject {
            self = .face(object)
        } else {
            return nil
        }
    }
    
    public var rawValue: AVMetadataObject {
        switch self {
        case .machineReadable(let object):
            return object
        case .face(let object):
            return object
        }
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<AVMetadataObject, T>) -> T {
        return rawValue[keyPath: keyPath]
    }
    
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<AVMetadataObject, T>) -> T {
        get { rawValue[keyPath: keyPath] }
    }
    
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<AVMetadataObject, T>) -> T {
        get { rawValue[keyPath: keyPath] }
        set { rawValue[keyPath: keyPath] = newValue }
    }
    
}
#endif
