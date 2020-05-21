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

import UIKit

public extension Stem where Base: UIFont {

    var isBold: Bool {
        return base.fontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue > 0
    }

    var isItalic: Bool {
        return base.fontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue > 0
    }

    var isMonoSpace: Bool {
        return base.fontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitMonoSpace.rawValue > 0
    }

    var isColorGlyphs: Bool {
        return CTFontGetSymbolicTraits(base as! CTFont).rawValue & CTFontSymbolicTraits.traitColorGlyphs.rawValue != 0
    }

    var weight: CGFloat {
        let dict = base.fontDescriptor.fontAttributes[.traits] as? [String: Any]
        return dict?[UIFontDescriptor.TraitKey.weight.rawValue] as? CGFloat ?? 0
    }

    var cgFont: CGFont? {
        return CGFont(base.fontName as CFString)
    }

}

public extension Stem where Base: UIFont {

    func register() -> Bool {
        guard let cgFont = cgFont else {
            return false
        }
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(cgFont, &error)
        guard success else {
            assert(false, "Error registering font: maybe it was already registered.")
            return false
        }
        return true
    }

}

public extension Stem where Base: UIFont {

    static func load(from path: String) -> UIFont? {
        load(from: URL(fileURLWithPath: path))
    }

    static func load(from url: URL) -> UIFont? {
        guard let descriptors = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL) as? [CTFontDescriptor], let descriptor = descriptors.first else {
            return nil
        }
        return load(from: CTFontCreateWithFontDescriptor(descriptor, 0, nil))
    }

    /// Use CTFont to create UIFont
    ///
    /// - Parameter ctFont: CTFont

    static func load(from ctFont: CTFont) -> UIFont? {
        let name = CTFontCopyPostScriptName(ctFont) as String
        guard !name.isEmpty else { return nil }
        let size = CTFontGetSize(ctFont)
        return UIFont(name: name, size: size)
    }

    /// Use CGFont to create UIFont
    ///
    /// - Parameters:
    ///   - cgFont: CGFont
    ///   - size: font size

    static func load(from cgFont: CGFont, size: CGFloat = UIFont.systemFontSize) -> UIFont? {
        guard let name = cgFont.postScriptName as String?, name.isEmpty == false else { return nil }
        return UIFont(name: name, size: size)
    }

    /// Use Data to create UIFont
    ///
    /// - Parameter data: Data
    static func load(from data: Data) -> UIFont? {
        guard let provider = CGDataProvider(data: (data as CFData)), let cgFont = CGFont(provider) else { return nil }
        return load(from: cgFont, size: UIFont.systemFontSize)
    }

}
