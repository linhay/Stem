//
//  StringRender+Node.swift
//  DUI
//
//  Created by linhey on 2023/5/12.
//

import Foundation

public extension StringRender.Marker {
    
    static func htmlImage(_ render: @escaping (_ url: URL) -> NSAttributedString?) throws -> Self {
        try .regex(pattern: #"<img[^>]* src\s*=\s*['"]([^'"]+)['"][^>]*>"#, type: .init(render: { payload in
            guard payload.group.count >= 2,
                  let url = URL(string: payload.group[1]) else {
                return nil
            }
            return render(url)
        }))
    }
    
    static func htmlLink(_ render: @escaping (_ content: String, _ url: URL) -> NSAttributedString?) throws -> Self {
        try .regex(pattern: #"<a\s+(?:[^>]*?\s+)?href="([^"]*)"[^>]*>(.*?)<\/a>"#,
                   type: .init(render: { payload in
            guard payload.group.count >= 3,
                  let url = URL(string: payload.group[1]) else {
                return nil
            }
            return render(payload.group[2], url)
        }))
    }
    
    static func htmlTagContent(_ tagName: String, _ render: @escaping (_ content: String) -> NSAttributedString?) throws -> Self {
        try .regex(pattern: #"<[^>]+>([^<]+)<\/[^>]+>"#,
                   type: .init(render: { payload in
            guard payload.group.count >= 2 else {
                return nil
            }
            return render(payload.group[1])
        }))
    }
    
    static func textLink(_ render: @escaping (_ url: URL) -> NSAttributedString?) throws -> Self {
        try .regex(pattern: #"(?:https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"#,
                   type: .init(render: { payload in
            guard payload.group.count >= 1,
                  let url = URL(string: payload.group[0]) else {
                return nil
            }
            return render(url)
        }))
    }
    
}
