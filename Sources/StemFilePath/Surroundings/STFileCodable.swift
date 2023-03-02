//
//  File.swift
//  
//
//  Created by linhey on 2023/1/30.
//

import Foundation

/**
 针对单个文件数据的 Codable 便捷读写设计.
 */
public struct STFileJSONCodable<Model> {
    
    public var file: STFile
    public var decoder: JSONDecoder
    public var encoder: JSONEncoder
    
    public init(file: STFile,
                type: Model.Type = Model.self,
                decoder: JSONDecoder = .init(),
                encoder: JSONEncoder = .init()) {
        self.decoder = decoder
        self.encoder = encoder
        self.file = file
    }
    
}

public extension STFileJSONCodable where Model: Decodable {
    
    func get() throws -> Model {
        let data = try file.data()
        return try decoder.decode(Model.self, from: data)
    }
    
}

public extension STFileJSONCodable where Model: Encodable {
    
    func set(_ model: Model) throws {
        let data = try encoder.encode(model)
        try file.overlay(with: data)
    }
    
}
