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

public extension Stem where Base: CTFont {

    func load(from url: URL) -> CTFont? {
        guard let descriptors = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL) as? [CTFontDescriptor], let descriptor = descriptors.first else {
            return nil
        }
        return CTFontCreateWithFontDescriptor(descriptor, 0, nil)
    }

    var unicodeMap: [CGGlyph: UnicodeScalar] {

        let charset = CTFontCopyCharacterSet(base) as CharacterSet

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
