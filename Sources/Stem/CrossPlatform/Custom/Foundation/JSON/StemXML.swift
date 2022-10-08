//
//  File.swift
//  
//
//  Created by linhey on 2022/10/5.
//

import Foundation

final public class StemXML: NSObject {
    
    public class Item {
        public let name: String
        public weak var parent: Item?
        public var attributes: [String: String] = [:]
        public var items: [String: [Item]] = [:]
        public var content: String = ""
        
        public init(name: String,
                    attributes: [String : String],
                    items: [String : [Item]],
                    parent: Item?) {
            self.name = name
            self.attributes = attributes
            self.items = items
            self.parent = parent
        }
        
        public convenience init() {
            self.init(name: "", attributes: [:], items: [:], parent: nil)
        }
        
    }
    
    private let parser: XMLParser
    private var root: Item?
    private var current: Item?
    
    public init(parser: XMLParser) {
        self.parser = parser
        super.init()
        self.parser.delegate = self
    }
    
    public convenience init?(contentsOf url: URL) {
        guard let parser = XMLParser(contentsOf: url) else { return nil }
        self.init(parser: parser)
    }
    
    public convenience init(data: Data) {
        self.init(parser: .init(data: data))
    }
    
    public convenience init(stream: InputStream) {
        self.init(parser: .init(stream: stream))
    }
    
    
    public func parse() -> Item {
        self.parser.parse()
        self.current = nil
        return root ?? .init()
    }
    
}

extension StemXML: XMLParserDelegate {
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let item = Item(name: elementName, attributes: attributeDict, items: [:], parent: current)
        if root == nil {
            root = item
        } else if current?.items[item.name] == nil {
            current?.items[item.name] = []
            current?.items[item.name]?.append(item)
        } else {
            current?.items[item.name]?.append(item)
        }
        current = item
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        current = current?.parent
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        current?.content = string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

public extension StemXML.Item {
    
    func collection(prefix: String, separator: String = ":") -> StemXML.Item {
        let items = self.items.filter({ result in
            let tree = result.key.components(separatedBy: separator)
            guard tree.count > 1,
                  tree.first == prefix else {
                return false
            }
            return true
        })
        
        var result = [String: [StemXML.Item]]()
        items.keys
            .forEach { key in
                let new = key.components(separatedBy: separator).dropFirst().joined()
                result[new] = self.items[key]
            }
        return .init(name: prefix,
                     attributes: [:],
                     items: result,
                     parent: self)
    }
    
    subscript(_ name: String) -> StemXML.Item {
        self.items[name]?.first ?? .init()
    }
    
    var stringValue: String {
        self.content
    }
    
    var arrayValue: [StemXML.Item] {
        self.parent?.items[name] ?? [self]
    }
    
}
