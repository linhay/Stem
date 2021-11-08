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
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

/// https://developer.apple.com/documentation/coretext/ctfont-q6r
#if canImport(AppKit) || canImport(UIKit)
public final class StemFont {
    
    let font: CTFont
    
    public init(ctFont font: CTFont) {
        self.font = font
    }
    
}

public extension StemFont {
    
    enum SpecifierConstants: String, CaseIterable {

        case copyright
        case family
        case subfamily
        case style
        case unique
        case full
        case version
        case postScript
        case trademark
        case manufacturer
        case designer
        case description
        case vendorURL
        case designerURL
        case license
        case licenseURL
        case sampleText
        case postScriptCID

        public typealias RawValue = String

        public init?(rawValue: String) {
            switch rawValue as CFString {
            case kCTFontCopyrightNameKey: self = .copyright
            case kCTFontFamilyNameKey: self = .family
            case kCTFontSubFamilyNameKey: self = .subfamily
            case kCTFontStyleNameKey: self = .style
            case kCTFontUniqueNameKey: self = .unique
            case kCTFontFullNameKey: self = .full
            case kCTFontVersionNameKey: self = .version
            case kCTFontPostScriptNameKey: self = .postScript
            case kCTFontTrademarkNameKey: self = .trademark
            case kCTFontManufacturerNameKey: self = .manufacturer
            case kCTFontDesignerNameKey: self = .designer
            case kCTFontDescriptionNameKey: self = .description
            case kCTFontVendorURLNameKey: self = .vendorURL
            case kCTFontDesignerURLNameKey: self = .designerURL
            case kCTFontLicenseNameKey: self = .license
            case kCTFontLicenseURLNameKey: self = .licenseURL
            case kCTFontSampleTextNameKey: self = .sampleText
            case kCTFontPostScriptCIDNameKey: self = .postScriptCID
            default: return nil
            }
        }

        public var rawValue: String {
            switch self {
            case .copyright: return kCTFontCopyrightNameKey as String
            case .family: return kCTFontFamilyNameKey as String
            case .subfamily: return kCTFontSubFamilyNameKey as String
            case .style: return kCTFontStyleNameKey as String
            case .unique: return kCTFontUniqueNameKey as String
            case .full: return kCTFontFullNameKey as String
            case .version: return kCTFontVersionNameKey as String
            case .postScript: return kCTFontPostScriptNameKey as String
            case .trademark: return kCTFontTrademarkNameKey as String
            case .manufacturer: return kCTFontManufacturerNameKey as String
            case .designer: return kCTFontDesignerNameKey as String
            case .description: return kCTFontDescriptionNameKey as String
            case .vendorURL: return kCTFontVendorURLNameKey as String
            case .designerURL: return kCTFontDesignerURLNameKey as String
            case .license: return kCTFontLicenseNameKey as String
            case .licenseURL: return kCTFontLicenseURLNameKey as String
            case .sampleText: return kCTFontSampleTextNameKey as String
            case .postScriptCID: return kCTFontPostScriptCIDNameKey as String
            }
        }
        
    }
    
}

@available(macCatalyst, unavailable)
public extension StemFont {

    static func isAvailable(familyName: String) -> Bool {
        #if canImport(AppKit)
        return NSFontManager.shared.availableFontFamilies.contains(familyName)
        #elseif canImport(UIKit)
        return !UIFont.fontNames(forFamilyName: familyName).isEmpty
        #else
        return false
        #endif
    }
    
    static var availableFontFamilies: [String] {
        #if canImport(AppKit)
        return NSFontManager.shared.availableFontFamilies
        #elseif canImport(UIKit)
        return UIFont.familyNames
        #else
        return []
        #endif
    }
    
}

public extension StemFont {
    
/// Determines whether a file is in a supported font format.
//    @available(macOS 10.6, *)
//    static func isSupported(from url: URL) -> Bool {
//       return CTFontManagerIsSupportedFont(url as CFURL)
//    }
    
    static func register(from url: URL) throws {
        try register(data: Data(contentsOf: url))
    }
    
    static func register(data: Data) throws {
        guard let provider = CGDataProvider(data: data as CFData),
              let font = CGFont(provider) else {
                  return
              }
        
        var error: Unmanaged<CFError>?
        
        if CTFontManagerRegisterGraphicsFont(font, &error) == false, let error = error?.takeUnretainedValue() {
            throw error
        }
    }
    
    static func registerFonts(from url: URL) throws -> [CTFont] {
        var error: Unmanaged<CFError>?
        if CTFontManagerRegisterFontsForURL(url as CFURL, .none, &error) == false, let error = error?.takeUnretainedValue() {
            throw error
        }
        
        guard let descriptors = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL) as? [CTFontDescriptor] else {
            return []
        }
        
        return descriptors.map { descriptor in
            CTFontCreateWithFontDescriptor(descriptor, 0, nil)
        }
    }
    
}

// MARK: - Getting Font Data
public extension StemFont {

    /// Returns the normalized font descriptors for the given font reference.
    var descriptor: CTFontDescriptor { CTFontCopyFontDescriptor(font) }

    /// Returns the value associated with an arbitrary attribute.
    /// - Parameter attribute: The requested attribute.
    /// - Returns: This function returns a retained reference to an arbitrary attribute. If the requested attribute is not present, NULL is returned. Refer to the attribute definitions for documentation as to how each attribute is packaged as a CFType.
    func attribute(_ attribute: String) -> CFTypeRef? {
        return CTFontCopyAttribute(font, attribute as CFString)
    }

    /// Returns the point size of the font reference.
    var size: CGFloat { CTFontGetSize(font) }

    /// Returns the transformation matrix of the font.
    var matrix: CGAffineTransform { CTFontGetMatrix(font) }

    /// Returns the symbolic font traits.
    var symbolicTraits: CTFontSymbolicTraits { CTFontGetSymbolicTraits(font) }

    /// Returns the font traits dictionary.
    var traits: [String: Any] { CTFontCopyTraits(font) as? [String: Any] ?? [:] }
    
    /// Retrieves an ordered list of font substitution preferences.
    func defaultCascadeList(with languages: [String]) -> [CTFontDescriptor] {
        CTFontCopyDefaultCascadeListForLanguages(font, languages as CFArray) as? [CTFontDescriptor] ?? []
    }
}

// MARK: - Getting Font Names
public extension StemFont {

    /// Returns the PostScript name of the given font.
    var postScriptName: String { CTFontCopyPostScriptName(font) as String }

    /// Returns the family name of the given font.
    var familyName: String { CTFontCopyFamilyName(font) as String }

    /// Returns the full name of the given font.
    var fullName: String { CTFontCopyFullName(font) as String }

    /// Returns the display name of the given font.
    var displayName: String { CTFontCopyDisplayName(font) as String }

    /// Returns a reference to the requested name of the given font.
    func name(with key: SpecifierConstants) -> String? {
        return CTFontCopyName(font, key.rawValue as CFString) as String?
    }
    
    /// Returns a reference to a localized name for the given font.
    func localizedName(key: SpecifierConstants, language: String?) -> String? {
        var actualLanguage: Unmanaged<CFString>?
        if let language = language {
            actualLanguage = .passRetained(language as CFString)
        }
        return CTFontCopyLocalizedName(font, key.rawValue as CFString, &actualLanguage) as String?
    }
    
}

// MARK: - Working With Encoding
public extension StemFont {
    
    /// Returns the Unicode character set of the font.
    var characterSet: CharacterSet { CTFontCopyCharacterSet(font) as CharacterSet }
    
    /// Returns the best string encoding for legacy format support.
    var stringEncoding: CFStringEncoding { CTFontGetStringEncoding(font) }
    
    /// Returns an array of languages supported by the font.
    var supportedLanguages: [String] { CTFontCopySupportedLanguages(font) as! [String] }
    
}

// MARK: - Getting Font Metrics
public extension StemFont {

    var ascent: Double { Double(CTFontGetAscent(font)) }
    var dscent: Double { Double(CTFontGetDescent(font)) }
    var leading: Double { Double(CTFontGetLeading(font)) }
    var unitsPerEm: Int { Int(CTFontGetUnitsPerEm(font)) }
    var glyphCount: Int { CTFontGetGlyphCount(font) as Int }
    var boundingBox: CGRect { CTFontGetBoundingBox(font) }
    var underlinePosition: Double { CTFontGetUnderlinePosition(font) }
    var underlineThickness: Double { CTFontGetUnderlineThickness(font) }
    var slantAngle: Double { CTFontGetSlantAngle(font) }
    var capHeight: Double { CTFontGetCapHeight(font) }
    var xHeight: Double { CTFontGetXHeight(font) }
    
}

// MARK: - Getting Glyph Data
public extension StemFont {
    
    /// Returns the CGGlyph value for the specified glyph name in the given font.
    func glyph(with name: String) -> CGGlyph {
        CTFontGetGlyphWithName(font, name as CFString)
    }
    
    /// Creates a path for the specified glyph.
    func path(for glyph: CGGlyph, transform: CGAffineTransform?) -> CGPath? {
        if var transform = transform {
            return CTFontCreatePathForGlyph(font, glyph, &transform)
        } else {
            return CTFontCreatePathForGlyph(font, glyph, nil)
        }
    }
    
    
    /// Calculates the bounding rects for an array of glyphs and returns the overall bounding rectangle for the glyph run.
    /// - Parameters:
    ///   - glyphs: An array of count number of glyphs.
    ///   - orientation: The intended drawing orientation of the glyphs. Used to determined which glyph metrics to return.
    ///   - boundingRects: On output, the computed glyph rectangles in an array of count number of CGRect objects. If NULL, only the overall bounding rectangle is calculated.
    ///   - count: The capacity of the glyphs and boundingRects buffers.
    /// - Returns: The overall bounding rectangle for an array or run of glyphs. Returns null on error.
    func boundingRects(for glyphs: [CGGlyph], orientation: CTFontOrientation, boundingRects: [CGRect], count: Int) -> CGRect {
        var boundingRects = boundingRects
        return CTFontGetBoundingRectsForGlyphs(font, orientation, glyphs, &boundingRects, count)
    }
    
    /// Calculates the advances for an array of glyphs and returns the summed advance.
    /// - Parameters:
    ///   - glyphs: An array of count number of glyphs.
    ///   - orientation: The intended drawing orientation of the glyphs. Used to determined which glyph metrics to return.
    ///   - advances: An array of count number of CGSize objects to receive the computed glyph advances. If NULL, only the overall advance is calculated.
    ///   - count: The capacity of the glyphs and boundingRects buffers.
    /// - Returns: The overall bounding rectangle for an array or run of glyphs. Returns null on error.
    func advances(for glyphs: [CGGlyph], orientation: CTFontOrientation, advances: [CGSize], count: Int) -> Double {
        var advances = advances
        return CTFontGetAdvancesForGlyphs(font, orientation, glyphs, &advances, count)
    }

    func opticalBounds(for glyphs: [CGGlyph], boundingRects: CGRect?, options: CFOptionFlags, count: Int) -> CGRect {
        if var boundingRects = boundingRects {
            return CTFontGetOpticalBoundsForGlyphs(font, glyphs, &boundingRects, count, options)
        } else {
            return CTFontGetOpticalBoundsForGlyphs(font, glyphs, nil, count, options)
        }
    }
    
    func verticalTranslations(for glyphs: [CGGlyph], translations: [CGSize], count: Int) -> [CGSize] {
        var translations = translations
        CTFontGetVerticalTranslationsForGlyphs(font, glyphs, &translations, count)
        return translations
    }
    
}

/// Getting Font Features
public extension StemFont {
    
//    func CTFontCopyFeatures(CTFont) -> CFArray?
//    Returns an array of font features.
//    func CTFontCopyFeatureSettings(CTFont) -> CFArray?
//    Returns an array of font feature-setting tuples.

}

/// Working with Glyphs
public extension StemFont {

    /// Performs basic character-to-glyph mapping.
//    var glyphsForCharacters: [CGGlyph: UnicodeScalar] {
//        let charset = characterSet
//        var glyphToUnicode = [CGGlyph: UnicodeScalar]()
//
//        // Enumerate all Unicode scalar values from the character set:
//        for plane: UInt8 in 0...16 where charset.hasMember(inPlane: plane) {
//            for unicode in UTF32Char(plane) << 16 ..< UTF32Char(plane + 1) << 16 {
//                if let uniChar = UnicodeScalar(unicode), charset.contains(uniChar) {
//
//                    // Get glyph for this `uniChar` ...
//                    let utf16 = Array(uniChar.utf16)
//                    var glyphs = [CGGlyph](repeating: 0, count: utf16.count)
//                    if CTFontGetGlyphsForCharacters(font, utf16, &glyphs, utf16.count) {
//                        // ... and add it to the map.
//                        glyphToUnicode[glyphs[0]] = uniChar
//                    }
//                }
//            }
//        }
//        return glyphToUnicode
//    }
    
}

#endif
