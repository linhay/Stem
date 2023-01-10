//
//  File.swift
//  
//
//  Created by linhey on 2023/1/5.
//

import Foundation

/// https://en.m.wikipedia.org/wiki/LRC_(file_format)
public struct STLyric {
    
    public struct IDTagKey: RawRepresentable, ExpressibleByStringLiteral, Hashable {
        
        public var rawValue: String
        
        public init(stringLiteral value: String) {
            self.rawValue = value
        }
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }

    }
    
    struct Regex {
        
        var rawValue: String { expression.pattern }
        var expression: NSRegularExpression
        
        init(_ pattern: String, options: NSRegularExpression.Options = []) throws {
            self.expression = try .init(pattern: pattern, options: options)
        }
        
        func matches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
            expression.matches(in: string, options: options, range: NSRange(string.startIndex..<string.endIndex, in: string))
        }
        
        func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = []) -> NSTextCheckingResult? {
            expression.firstMatch(in: string, options: options, range: NSRange(string.startIndex..<string.endIndex, in: string))
        }
        
    }
    
    
    /// Simple format extended
    public enum LineKind: String {
        case male   = "M:"
        case duet   = "D:"
        case female = "F:"
        case none   = ""
    }
    
    public struct LineNode {
        public let time: TimeInterval
        public let value: String
    }
    
    public struct Line {
        
        public let kind: LineKind
        public let time: TimeInterval
        public let nodes: [LineNode]
        public let value: String
        
        init(_ string: String) throws {
            guard let firstMatch = try Regex.time.firstMatch(in: string),
                  firstMatch.numberOfRanges == 3,
                  let ttRange = Range(firstMatch.range(at: 0), in: string),
                  let mmrange = Range(firstMatch.range(at: 1), in: string),
                  let ssrange = Range(firstMatch.range(at: 2), in: string),
                  let mm = TimeInterval(string[mmrange]),
                  let ss = TimeInterval(string[ssrange])
            else {
                throw StemError("error")
            }
            
            let time  = mm * 60 + ss
            var value = String(string[ttRange.upperBound..<string.endIndex])
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let kind  = LineKind(rawValue: String(value.prefix(2)).uppercased()) ?? .none
            value = String(value.dropFirst(kind.rawValue.count))
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let nodes = [LineNode(time: time, value: value)]

            self.time  = time
            self.kind  = kind
            self.nodes = nodes
            self.value = nodes.map(\.value).joined()
        }
        
    }
    
    public var idTags: [IDTagKey: String] = [:]
    public var lines: [Line] = []
    
    public var offset: TimeInterval {
        get { return idTags[.offset].flatMap { Double($0) } ?? 0 }
        set { idTags[.offset] = "\(newValue)" }
    }
    
    public init(lyric: String) throws {
    var idTags: [IDTagKey: String] = [:]
        try Regex.idTag.matches(in: lyric)
            .forEach({ match in
                guard match.numberOfRanges == 3,
                      let idrange = Range(match.range(at: 1), in: lyric),
                      let vvrange = Range(match.range(at: 2), in: lyric) else {
                    return
                }
                let key   = String(lyric[idrange]).trimmingCharacters(in: .whitespacesAndNewlines)
                let value = String(lyric[vvrange]).trimmingCharacters(in: .whitespacesAndNewlines)
                idTags[IDTagKey(rawValue: key)] = value
            })
        
        self.idTags = idTags
        self.lines = try Regex.line.matches(in: lyric)
            .map(\.range)
            .compactMap { nsrange in
                Range(nsrange, in: lyric)
            }
            .map { range in
                String(lyric[range])
            }
            .map(Line.init)
    }
    
}

public extension STLyric {
    
    func line(at time: TimeInterval) -> Line? {
        let time = time - offset
        
        if lines.isEmpty {
            return nil
        }
        
        if let last = lines.last, time > last.time {
            return nil
        }
        
        if let first = lines.first, time < first.time {
            return nil
        }
        
        func find(left: Int, right: Int) -> Line? {
           
            if right - left <= 1 {
                var candidate = lines[right]
                if time >= candidate.time {
                    return candidate
                }
                candidate = lines[left]
                if time >= candidate.time {
                    return candidate
                }
                
                return nil
            }
            
            let mid = (left + right) / 2
            let candidate = lines[mid]
            if candidate.time < time {
                return find(left: mid, right: right)
            } else if candidate.time > time {
                return find(left: left, right: mid)
            } else {
                return candidate
            }
        }

        return find(left: 0, right: lines.count - 1)
    }

    
}

extension STLyric.Regex {
    
    static var line: STLyric.Regex {
        get throws {
            try .init(#"^(\[[+-]?\d+:\d+(?:\.\d+)?\])+(?!\[)([^【\n\r]*)(?:【(.*)】)?"#, options: .anchorsMatchLines)
        }
    }
    
    static var idTag: STLyric.Regex {
        get throws {
            try .init(#"^(?!\[[+-]?\d+:\d+(?:\.\d+)?\])\[(.+?):(.+)\]$"#, options: .anchorsMatchLines)
        }
    }
    
    static var time: STLyric.Regex {
        get throws {
            try .init(#"\[([-+]?\d+):(\d+(?:\.\d+)?)\]"#)
        }
    }
    
}

public extension STLyric.IDTagKey {
    /// Lyrics artist
    static let artist  = STLyric.IDTagKey("ar")
    /// Album where the song is from
    static let album   = STLyric.IDTagKey("al")
    /// Lyrics (song) title
    static let title   = STLyric.IDTagKey("ti")
    /// Creator of the Songtext
    static let author  = STLyric.IDTagKey("au")
    /// How long the song is
    static let length  = STLyric.IDTagKey("length")
    /// Creator of the LRC file
    static let creator = STLyric.IDTagKey("by")
    /// +/- Overall timestamp adjustment in milliseconds, + shifts time up, - shifts down
    static let offset  = STLyric.IDTagKey("offset")
    /// The player or editor that created the LRC file
    static let editor  = STLyric.IDTagKey("re")
    /// version of program
    static let version = STLyric.IDTagKey("ve")
}
