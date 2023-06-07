//
//  PostContentMarker.swift
//  iDxyer
//
//  Created by linhey on 2023/5/11.
//  Copyright © 2023 dxy.cn. All rights reserved.
//

import CoreGraphics
import Foundation

public struct StringRender {
    
    public typealias Marker = StringMarker.MarkWapper<Style>
    
    public struct Style {
        
        public let render: (_ payload: StringMarker.MarkedPayload) throws -> NSAttributedString?
        
        public init(render: @escaping (_ payload: StringMarker.MarkedPayload) -> NSAttributedString?) {
            self.render = render
        }
        
    }
    
    public struct Finish {
        
        public let block: (_ string: NSMutableAttributedString) -> NSAttributedString
        
        public init(_ block: @escaping (_ string: NSMutableAttributedString) -> NSAttributedString) {
            self.block = block
        }
        
    }
    
    public struct Contenxt {
        
        public let marker: [Marker]
        public let unknown: Style?
        public let finish: Finish?

        public init(marker: [Marker], unknown: Style?, finish: Finish? = nil) {
            self.marker = marker
            self.unknown = unknown
            self.finish = finish
        }
        
        public func render(_ string: String) throws -> NSAttributedString {
            let builder = NSMutableAttributedString()
            for result in try StringMarker.matches(string, mark: marker) {
                switch result {
                case let .mark(type: style, payload: payload):
                    if let text = try style.render(payload) {
                        builder.append(text)
                    }
                case .unknown(let payload):
                    if let text = try unknown?.render(.init(match: payload, lazy_group: { [payload] })) {
                        builder.append(text)
                    }
                }
            }
            return finish?.block(builder) ?? builder
        }
        
    }
    
    public let string: String
    public let contenxt: Contenxt
    
    public init(string: String, contenxt: Contenxt) {
        self.string = string
        self.contenxt = contenxt
    }
    
    public func render() throws -> NSAttributedString {
       try contenxt.render(string)
    }
    
}
