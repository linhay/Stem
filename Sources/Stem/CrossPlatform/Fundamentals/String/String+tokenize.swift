// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

/// Tokenization options
public struct StringTokenizationOptions: OptionSet {
    /* kCFStringTokenizerUnitWord doesn't return space between words as a token. */
    /**
     Tokenization Unit
     Use one of tokenization unit options with CFStringTokenizerCreate to
     specify how the string should be tokenized.
     */
    /* kCFStringTokenizerUnitWord不会将字与字之间的空间作为标记返回。*/
    /**
     标记化单元
     在CFStringTokenizerCreate中使用一个标记化单元选项来指定字符串如何被标记化。
     指定字符串应该如何被标记化。
     */
    public static let unitWord = StringTokenizationOptions(rawValue: kCFStringTokenizerUnitWord)
    /**
     Tokenization Unit
     Use one of tokenization unit options with CFStringTokenizerCreate to
     specify how the string should be tokenized.
     */
    /**
     标记化单元
     在CFStringTokenizerCreate中使用一个标记化单元选项来指定字符串应该如何被标记。
     指定应该如何对字符串进行标记化。
     */
    public static let unitSentence = StringTokenizationOptions(rawValue:  kCFStringTokenizerUnitSentence)
    /**
     Tokenization Unit
     Use one of tokenization unit options with CFStringTokenizerCreate to
     specify how the string should be tokenized.
     */
    /**
     标记化单元
     在CFStringTokenizerCreate中使用一个标记化单元选项来指定字符串应该如何标记。
     指定应该如何对字符串进行标记化。
     */
    public static let unitParagraph = StringTokenizationOptions(rawValue: kCFStringTokenizerUnitParagraph)
    
    /**
     Tokenization Unit
     Use one of tokenization unit options with CFStringTokenizerCreate to
     specify how the string should be tokenized.
     */
    /**
     标记化单元
     使用CFStringTokenizerCreate的一个标记化单元选项来指定字符串应该如何标记。
     指定应该如何对字符串进行标记化。
     */
    public static let unitLineBreak = StringTokenizationOptions(rawValue: kCFStringTokenizerUnitLineBreak)
    
    /* kCFStringTokenizerUnitWordBoundary can be used in double click detection
     and whole word search. It is locale sensitive. If the locale parameter of
     CFStringTokenizerCreate is NULL, default locale is used.
     kCFStringTokenizerUnitWordBoundary returns space between words as a token. */
    /* kCFStringTokenizerUnitWordBoundary可以用于双击检测
     和整个单词搜索。它是对地区敏感的。如果CFStringTokenizerC的locale参数
     CFStringTokenizerCreate的locale参数为NULL，则使用默认locale。
     kCFStringTokenizerUnitWordBoundary将单词之间的空间作为一个标记返回。*/
    /**
     Tokenization Unit
     Use one of tokenization unit options with CFStringTokenizerCreate to
     specify how the string should be tokenized.
     */
    
    /**
     标记化单元
     在CFStringTokenizerCreate中使用一个标记化单元选项来指定字符串的标记化方式。
     指定字符串应该如何被标记化。
     */
    public static let unitWordBoundary = StringTokenizationOptions(rawValue: kCFStringTokenizerUnitWordBoundary)
    
    /* Latin Transcription. Used with kCFStringTokenizerUnitWord or kCFStringTokenizerUnitWordBoundary */
    /* 拉丁语转写。与kCFStringTokenizerUnitWord或 kCFStringTokenizerUnitWordBoundary */
    /**
     Attribute Specifier
     Use attribute specifier to tell tokenizer to prepare the specified attribute
     when it tokenizes the given string. The attribute value can be retrieved by
     calling CFStringTokenizerCopyCurrentTokenAttribute with one of the attribute
     option.
     */
    /**
     属性指定器
     使用属性指定器来告诉标记器在标记给定的字符串时准备指定的属性。
     当它对给定的字符串进行标记时。该属性值可以通过
     可以通过调用CFStringTokenizerCopyCurrentTokenAttribute与其中一个属性
     选项中的一个。
     */
    public static let attributeLatinTranscription = StringTokenizationOptions(rawValue: kCFStringTokenizerAttributeLatinTranscription)
    
    /* Language in BCP 47 string. Used with kCFStringTokenizerUnitSentence
     or kCFStringTokenizerUnitParagraph. */
    /**
     Attribute Specifier
     Use attribute specifier to tell tokenizer to prepare the specified attribute
     when it tokenizes the given string. The attribute value can be retrieved by
     calling CFStringTokenizerCopyCurrentTokenAttribute with one of the attribute
     option.
     */
    /* BCP 47字符串中的语言。与kCFStringTokenizerUnitSentence一起使用
     或 kCFStringTokenizerUnitParagraph. */
    /**
     属性指定器
     使用属性指定器来告诉标记器在标记给定的字符串时准备指定的属性。
     当它对给定的字符串进行标记时。该属性值可以通过
     可以通过调用CFStringTokenizerCopyCurrentTokenAttribute与其中一个属性
     选项中的一个。
     */
    public static let attributeLanguage = StringTokenizationOptions(rawValue: kCFStringTokenizerAttributeLanguage)
    
    public let rawValue: CFOptionFlags
    
    public init(rawValue: CFOptionFlags) {
        self.rawValue = rawValue
    }
}


public extension StemValue where Base == String {
    
    /// 分词
    func tokenize(options: StringTokenizationOptions = .unitWord, locale: Locale = .current) -> [String] {
        let tokenize = self.tokenizer(options: options, locale: locale)
        var keywords: [String] = []
        while true {
            if let keyword = self.nextKeyword(tokenize) {
                keywords.append(keyword)
            } else {
                break
            }
        }
        return keywords
    }
    
    /// 分词
    func tokenizeAsyncStream(options: StringTokenizationOptions = .unitWord, locale: Locale = .current) -> AsyncStream<String> {
        .init { continuation in
            let tokenize = self.tokenizer(options: options, locale: locale)
            while true {
                if let keyword = self.nextKeyword(tokenize) {
                    continuation.yield(keyword)
                } else {
                    continuation.finish()
                    break
                }
            }
        }
    }
    
}

private extension StemValue where Base == String {
    
    func tokenizer(options: StringTokenizationOptions, locale: Locale) -> CFStringTokenizer {
        let locale = CFLocaleCreate(kCFAllocatorDefault, CFLocaleIdentifier(locale.identifier as CFString))
        return CFStringTokenizerCreate(kCFAllocatorDefault, base as CFString, CFRangeMake(0, base.count), options.rawValue, locale)
    }
    
    func nextKeyword(_ tokenizer: CFStringTokenizer) -> String? {
        CFStringTokenizerAdvanceToNextToken(tokenizer)
        let range = CFStringTokenizerGetCurrentTokenRange(tokenizer)
        if range.length <= 0 {
            return nil
        }
        let wRange = base.index(base.startIndex, offsetBy: range.location)..<base.index(base.startIndex, offsetBy: range.location + range.length)
        return String(base[wRange])
    }
    
}
