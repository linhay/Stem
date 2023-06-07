//
//  File.swift
//
//
//  Created by linhey on 2022/8/10.
//

import Foundation

public protocol StringMarkProtocol {
    
    associatedtype MarkType
    var type: MarkType { get }
    func matches(_ text: String) throws -> [NSTextCheckingResult]
    
}

public extension StringMarkProtocol {
    
    func groups(_ text: String, _ matches: NSTextCheckingResult) -> [String] {
        if matches.numberOfRanges == 0 {
            return []
        }
        return (0..<matches.numberOfRanges)
            .compactMap { Range(matches.range(at: $0), in: text) }
            .compactMap({ text[$0] })
            .map({ String($0) })
    }
    
    /// 标记字符串中符合规则的子串
    /// - Parameters:
    ///   - text: 被标记字符串
    ///   - mark: 标记规则
    /// - Returns: 被标记与未标记的子串数组
    func marked(_ text: String, _ matches: [NSTextCheckingResult]) throws -> [StringMarker.Marked<MarkType>] {
        guard !text.isEmpty else { return [] }
        
        guard !matches.isEmpty else {
           return [.unknown(text)]
        }
        
        var marked = [(range: Range<String.Index>, marked: StringMarker.Marked<MarkType>)]()
        for matche in matches {
            guard let range = Range(matche.range, in: text) else {
                continue
            }
            marked.append((range: range, marked: .mark(type: type, payload: .init(match: String(text[range]), lazy_group: {
                self.groups(text, matche)
            }))))
        }
        
        var result = [(range: Range<String.Index>, marked: StringMarker.Marked<MarkType>)]()
        marked.sorted { lhs, rhs in
            lhs.range.lowerBound < rhs.range.lowerBound
        }.forEach { (range, value) in
            if let last = result.last {
                if last.range.upperBound != range.lowerBound {
                    let range = last.range.upperBound..<range.lowerBound
                    let string = String(text[range])
                    result.append((range, .unknown(string)))
                }
            } else if range.lowerBound != text.startIndex {
                let range  = text.startIndex..<range.lowerBound
                let string = String(text[range])
                result.append((range, .unknown(string)))
            }
            result.append((range, value))
        }
        
        if let last = result.last, last.range.upperBound != text.endIndex {
            let range = last.range.upperBound..<text.endIndex
            result.append((range, .unknown(String(text[range]))))
        }
        return result.map(\.marked)
    }
    
}

public struct StringMarker {
    
    public struct RegexPattern: RawRepresentable, ExpressibleByStringLiteral {
        
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: String) {
            self.rawValue = value
        }
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    public enum MarkWapper<MarkType>: StringMarkProtocol {
        
        case regex(RegexMark<MarkType>)
        case detector(DetectorMark<MarkType>)
        
        public static func regex(pattern: String, type: MarkType) throws -> Self {
            try .regex(.init(type: type, pattern: pattern))
        }
        
        public static func regex(pattern: StringMarker.RegexPattern, type: MarkType) throws -> Self {
            try .regex(pattern: pattern.rawValue, type: type)
        }
        
        public static func detector(pattern: NSTextCheckingResult.CheckingType, type: MarkType) throws -> Self {
            try .detector(.init(type: type, pattern: pattern))
        }
        
        public var type: MarkType {
            switch self {
            case .regex(let mark):
                return mark.type
            case .detector(let mark):
                return mark.type
            }
        }
        
        public func matches(_ text: String) throws -> [NSTextCheckingResult] {
            switch self {
            case .regex(let mark):
                return try mark.matches(text)
            case .detector(let mark):
                return try mark.matches(text)
            }
        }
    }
    
    public struct RegexMark<MarkType>: StringMarkProtocol {
        
        public let type: MarkType
        public let regex: NSRegularExpression
        
        public init(type: MarkType, pattern: String) throws {
            self.type = type
            self.regex = try NSRegularExpression(pattern: pattern)
        }
        
        public init(type: MarkType, pattern: RegexPattern) throws {
            try self.init(type: type, pattern: pattern.rawValue)
        }
        
        public func matches(_ text: String) throws -> [NSTextCheckingResult] {
            regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
        }
        
    }
    
    public struct DetectorMark<MarkType>: StringMarkProtocol {
        
        public let type: MarkType
        public let regex: NSTextCheckingResult.CheckingType
        
        public init(type: MarkType, pattern: NSTextCheckingResult.CheckingType) throws {
            self.type = type
            self.regex = pattern
        }
        
        public func matches(_ text: String) throws -> [NSTextCheckingResult] {
            try NSDataDetector(types: regex.rawValue).matches(in: text, range: NSRange(text.startIndex..., in: text))
        }
        
    }
    
    public class MarkedPayload {
     
        public let match: String
        public lazy var group: [String] = lazy_group()
        private let lazy_group: () -> [String]
        
        init(match: String, lazy_group: @escaping () -> [String]) {
            self.match = match
            self.lazy_group = lazy_group
        }
    }
    
    public enum Marked<MarkType> {

        case mark(type: MarkType, payload: MarkedPayload)
        case unknown(_ payload: String)
        
        public var matchText: String {
            switch self {
            case .mark(type: _, payload: let payload):
                return payload.match
            case .unknown(let payload):
                return payload
            }
        }
        
    }
    
}

extension StringMarker {
    
    /// 标记字符串中符合规则的子串
    /// - Parameters:
    ///   - text: 被标记字符串
    ///   - mark: 标记规则
    /// - Returns: 被标记与未标记的子串数组
    public static func matches<T>(_ text: String, mark list: [RegexMark<T>]) throws -> [Marked<T>] {
        try self._matches(text, mark: list)
    }
    
    public static func matches<T>(_ text: String, mark list: [DetectorMark<T>]) throws -> [Marked<T>] {
        try self._matches(text, mark: list)
    }
    
    public static func matches<M: StringMarkProtocol>(_ text: String, mark list: [M]) throws -> [Marked<M.MarkType>] {
        try self._matches(text, mark: list)
    }
    
    public static func matches<T>(_ text: String, mark list: [MarkWapper<T>]) throws -> [Marked<T>] {
        try self._matches(text, mark: list)
    }
    
}

private extension StringMarker {
    
    static func _extract(_ text: String, _ matches: [NSTextCheckingResult]) -> [String] {
        return matches
            .compactMap({ result -> [String]? in
                if result.numberOfRanges == 0 {
                    return nil
                }
                return (0..<result.numberOfRanges)
                    .compactMap { Range(result.range(at: $0), in: text) }
                    .compactMap({ text[$0] })
                    .map({ String($0) })
            })
            .flatMap({ $0 })
    }
    
    static func _matches<M: StringMarkProtocol>(_ text: String, mark list: [M]) throws -> [Marked<M.MarkType>] {
        guard !text.isEmpty else {
            return []
        }
        
        var result: [Marked<M.MarkType>] = [.unknown(text)]
        
        for mark in list {
            var new: [Marked<M.MarkType>] = []
            for item in result {
                switch item {
                case .unknown(let text):
                    let matches = try mark.matches(text)
                    try new.append(contentsOf: mark.marked(text, matches))
                case .mark:
                    new.append(item)
                }
            }
            result = new
        }
        return result
    }
    
}
