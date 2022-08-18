//
//  File.swift
//  
//
//  Created by linhey on 2022/8/10.
//

import Foundation

public protocol StemStringMarkProtocol {
    
    associatedtype MarkType
    var type: MarkType { get }
    func matches(_ text: String) throws -> [NSTextCheckingResult]
    
}

public extension StemStringMarkProtocol {
    
    /// 标记字符串中符合规则的子串
    /// - Parameters:
    ///   - text: 被标记字符串
    ///   - mark: 标记规则
    /// - Returns: 被标记与未标记的子串数组
    func marked(_ text: String) throws -> [StemStringMarker.Marked<MarkType>] {
        guard !text.isEmpty else {
            return []
        }
        
        let matches = try self.matches(text)
        let ranges = matches.map(\.range)
        
        var result = [StemStringMarker.Marked<MarkType>]()
        var lastRange: Range<String.Index>
        
        if let nsrange = ranges.first, let range = Range(nsrange, in: text), range.lowerBound > text.startIndex {
            result.append(.unknown(String(text[text.startIndex..<range.lowerBound])))
            lastRange = range
        } else {
            lastRange = Range<String.Index>(uncheckedBounds: (lower: text.startIndex, upper: text.startIndex))
        }
        
        for range in matches.map(\.range) {
            guard let range = Range(range, in: text) else {
                continue
            }
            
            if range.lowerBound > lastRange.upperBound {
                result.append(.unknown(String(text[lastRange.upperBound..<range.lowerBound])))
            }
            
            result.append(.mark(type, String(text[range])))
            lastRange = range
        }
        
        if lastRange.upperBound < text.endIndex {
            result.append(.unknown(String(text[lastRange.upperBound..<text.endIndex])))
        }
        return result
    }
    
}

public struct StemStringMarker {
    
    public enum MarkWapper<MarkType>: StemStringMarkProtocol {
        
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
        
        case regex(RegexMark<MarkType>)
        case detector(DetectorMark<MarkType>)
    }
    
    public struct RegexMark<MarkType>: StemStringMarkProtocol {
        
        public let type: MarkType
        public let regex: NSRegularExpression
        
        public init(type: MarkType, pattern: String) throws {
            self.type = type
            self.regex = try NSRegularExpression(pattern: pattern)
        }
        
        public func matches(_ text: String) throws -> [NSTextCheckingResult] {
            regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
        }
        
    }
    
    public struct DetectorMark<MarkType>: StemStringMarkProtocol {
        
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
    
    public enum Marked<MarkType> {
        case mark(_ mark: MarkType, _ payload: String)
        case unknown(_ payload: String)
    }
    
}

public extension StemStringMarker {
    
    /// 提取符合规则的子串
    /// - Parameters:
    ///   - text: 被提取字符串
    ///   - pattern: 匹配的正则
    /// - Returns: 被匹配到的文本
    static func extract(_ text: String, pattern: String) throws -> [String] {
        let regex  = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return _extract(text, matches)
    }
    
    /// 提取符合规则的子串
    /// - Parameters:
    ///   - text: 被提取字符串
    ///   - pattern: 匹配的正则
    /// - Returns: 被匹配到的文本
    static func extract(_ text: String, pattern: NSTextCheckingResult.CheckingType) throws -> [String] {
        let matches = try NSDataDetector(types: pattern.rawValue).matches(in: text, range: NSRange(text.startIndex..., in: text))
        return _extract(text, matches)
    }
    
}

extension StemStringMarker {
    
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
    
    public static func matches<M: StemStringMarkProtocol>(_ text: String, mark list: [M]) throws -> [Marked<M.MarkType>] {
        try self._matches(text, mark: list)
    }
    
    public static func matches<T>(_ text: String, mark list: [MarkWapper<T>]) throws -> [Marked<T>] {
        try self._matches(text, mark: list)
    }
    
}

private extension StemStringMarker {
    
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
    
    static func _matches<M: StemStringMarkProtocol>(_ text: String, mark list: [M]) throws -> [Marked<M.MarkType>] {
        guard !text.isEmpty else {
            return []
        }
        
        var result: [Marked<M.MarkType>] = [.unknown(text)]
        
        for mark in list {
            var new: [[Marked<M.MarkType>]] = []
            for item in result {
                switch item {
                case .unknown(let text):
                    try new.append(mark.marked(text))
                case .mark:
                    new.append([item])
                }
            }
            result = Array(new.joined())
        }
        return result
    }
    
    
}
