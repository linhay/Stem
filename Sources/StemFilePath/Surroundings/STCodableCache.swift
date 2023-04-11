//
//  File.swift
//  
//
//  Created by linhey on 2023/3/11.
//

#if canImport(Combine)
import Foundation
import Combine

@propertyWrapper
public final class STCodableCache<Value: Codable>: Codable {

    public typealias CacheDecoder = (_ data: Data, _ type: Entry.Type) throws -> Entry
    public typealias CacheEncoder = (_ entry: Codable) throws -> Data?
    
    public var wrappedValue: Value {
        get { entry.value }
        set { entry.value = newValue }
    }
    
    private var entry: Entry {
        get { entrySubject.value }
        set { entrySubject.value = newValue }
    }
    
    public private(set) lazy var projectedValue = entrySubject.map(\.value).eraseToAnyPublisher()
    public var file: STFile?
    public var encoder: ((_ entry: Codable) throws -> Data?)?
    public var decoder: ((_ data: Data, _ type: Entry.Type) throws -> Entry)?

    private let entrySubject: CurrentValueSubject<Entry, Never>
    private var cancellable: AnyCancellable?
    private var observableCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    public convenience init(file: STFile?,
                            default: Value,
                            decoder: CacheDecoder?,
                            encoder: CacheEncoder?) {
        self.init(file: file, default: .init(value: `default`), decoder: decoder, encoder: encoder)
    }
    
    public convenience init(file: STFile?,
                            default: Value,
                            decoder: CacheDecoder?,
                            encoder: CacheEncoder?) where Value: ObservableObject {
        self.init(file: file, default: .init(value: `default`), decoder: decoder, encoder: encoder)
    }
    
    public convenience init(file: STFile?,
                default: STCodableCache<Value>.Entry,
                decoder: CacheDecoder?,
                encoder: CacheEncoder?) where Value: ObservableObject {
        self.init(file: file, default: `default`, decoder: decoder, encoder: encoder)
        entrySubject.sink { [weak self] entry in
            self?.observableCancellable = entry.value.objectWillChange.sink { [weak self] _ in
               try? self?.save(entry: entry, to: self?.file)
            }
        }.store(in: &cancellables)
    }
    
    public init(file: STFile?,
                default: STCodableCache<Value>.Entry,
                decoder: CacheDecoder?,
                encoder: CacheEncoder?) {
        if let data = try? file?.data(), let entry = try? decoder?(data, Entry.self) {
            self.entrySubject = .init(entry)
        } else {
            self.entrySubject = .init(`default`)
        }
        self.file = file
        self.encoder = encoder
        self.decoder = decoder
    }
    
    public convenience init(file: STFile,
                            default: Value,
                            decoder: JSONDecoder = JSONDecoder(),
                            encoder: JSONEncoder = JSONEncoder()) {
        self.init(file: file, default: `default`) { data, type in
            try decoder.decode(type, from: data)
        } encoder: { entry in
            try encoder.encode(entry)
        }
    }
    
    public static func value(file: STFile, decoder: CacheDecoder) -> Value? {
        do {
            let data = try file.data()
            return try decoder(data, Entry.self).value
        } catch  {
            return nil
        }        
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(file: nil,
                  default: try container.decode(Entry.self),
                  decoder: nil,
                  encoder: nil)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(entry)
    }
    
    deinit {
        if file?.isExist == true {
            try? save(entry: entry, to: file)
        }
    }
    
    @discardableResult
    public func autoconnect() -> Self {
        cancellable = entrySubject
            .filter { [weak self] _ in
                self?.file != nil
            }
            .sink { [weak self] entry in
                guard let self = self else { return }
                try? self.save(entry: entry, to: self.file)
            }
        return self
    }
    
    public func disconnect() {
        cancellable?.cancel()
    }

}

extension STCodableCache {
    
    public func sync(from file: STFile?) throws {
        guard let file = file, let decoder = decoder else { return }
        let entry = try decoder(file.data(), Entry.self)
        self.entry = entry
    }
    
    public func save(entry: Entry?, to file: STFile?) throws {
        guard let file = file, let encoder = encoder else { return }
        let data = try encoder(entry)
        try file.overlay(with: data)
    }
    
}

extension STCodableCache {
    
    public struct Entry: Codable {
        
        var value: Value
        var expirationDate: Date?
        
        public init(value: Value, expirationDate: Date? = nil) {
            self.value = value
            self.expirationDate = expirationDate
        }
        
    }
    
}

#endif
