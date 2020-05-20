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

public enum CTFontSpecifierConstants: String, CaseIterable {

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
