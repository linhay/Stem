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
import CoreText

extension CTFont: StemCompatible { }

// MARK: - Font Names
public extension Stem where Base: CTFont {

    /// a retained reference to the PostScript name of the font.
    var postScriptName: String { CTFontCopyPostScriptName(base) as String }

    /// a retained reference to the family name of the font.
    var familyName: String { CTFontCopyFamilyName(base) as String }

    /// a retained reference to the full name of the font.
    var fullName: String { CTFontCopyFullName(base) as String }

    /// a retained reference to the localized display name of the font.
    var displayName: String { CTFontCopyDisplayName(base) as String }

    /// get a reference to the requested name
    /// - Parameter key: The name specifier. See `CTFontSpecifierConstants`.
    /// - Returns: This function creates the requested name for the font, or NULL if the font does not have an entry for the requested name. The Unicode version of the name will be preferred, otherwise the first available will be used.
    func name(with key: CTFontSpecifierConstants) -> String? {
        return CTFontCopyName(base, key.rawValue as CFString) as String?
    }

    /// Returns a reference to a localized font name.
    //    func localizedName(with key: CTFontSpecifierConstants, actualLanguage: [String]?) -> String? {
    //        var actualLanguage = actualLanguage?.map({ Unmanaged<CFString>.passRetained($0 as CFString) })
    //        return CTFontCopyLocalizedName(base, key.rawValue as CFString, &actualLanguage) as String?
    //    }
}

// MARK: - Font Accessors
public extension Stem where Base: CTFont {

    /// Returns the normalized font descriptors for the given font reference.
    var descriptor: CTFontDescriptor { CTFontCopyFontDescriptor(base) }

    /// Returns the value associated with an arbitrary attribute.
    /// - Parameter attribute: The requested attribute.
    /// - Returns: This function returns a retained reference to an arbitrary attribute. If the requested attribute is not present, NULL is returned. Refer to the attribute definitions for documentation as to how each attribute is packaged as a CFType.
    func attribute(_ attribute: String) -> CFTypeRef? {
        return CTFontCopyAttribute(base, attribute as CFString)
    }

    /// Returns the point size of the font reference.
    var size: CGFloat { CTFontGetSize(base) }

    /// Returns the transformation matrix of the font.
    var matrix: CGAffineTransform { CTFontGetMatrix(base) }

    /// Returns the symbolic font traits.
    var symbolicTraits: CTFontSymbolicTraits { CTFontGetSymbolicTraits(base) }

    /// Returns the font traits dictionary.
    var traits: [String: Any] { CTFontCopyTraits(base) as? [String: Any] ?? [:] }

}

// MARK: - Font Encoding
public extension Stem where Base: CTFont {

    /// Returns the Unicode character set of the font.
    var characterSet: CharacterSet { CTFontCopyCharacterSet(base) as CharacterSet }
    /// Returns the best string encoding for legacy format support.
    var stringEncoding: CFStringEncoding { CTFontGetStringEncoding(base) }
    /// Returns an array of languages supported by the font.
    var supportedLanguages: [Any] { CTFontCopySupportedLanguages(base) as! [Any] }
    /// Performs basic character-to-glyph mapping.
    var glyphsForCharacters: [CGGlyph: UnicodeScalar] {
        let charset = characterSet
        var glyphToUnicode = [CGGlyph: UnicodeScalar]() // Start with empty map.

        // Enumerate all Unicode scalar values from the character set:
        for plane: UInt8 in 0...16 where charset.hasMember(inPlane: plane) {
            for unicode in UTF32Char(plane) << 16 ..< UTF32Char(plane + 1) << 16 {
                if let uniChar = UnicodeScalar(unicode), charset.contains(uniChar) {

                    // Get glyph for this `uniChar` ...
                    let utf16 = Array(uniChar.utf16)
                    var glyphs = [CGGlyph](repeating: 0, count: utf16.count)
                    if CTFontGetGlyphsForCharacters(base, utf16, &glyphs, utf16.count) {
                        // ... and add it to the map.
                        glyphToUnicode[glyphs[0]] = uniChar
                    }
                }
            }
        }
        return glyphToUnicode
    }
}

public extension Stem where Base: CTFont {

    static func load(from url: URL) -> CTFont? {
        guard let descriptors = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL) as? [CTFontDescriptor], let descriptor = descriptors.first else {
            return nil
        }
        return CTFontCreateWithFontDescriptor(descriptor, 0, nil)
    }

}
