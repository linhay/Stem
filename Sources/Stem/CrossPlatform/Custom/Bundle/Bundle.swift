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

public extension StemValue where Base: Bundle {
    
    var isSandbox: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        guard let receiptName = base.appStoreReceiptURL?.lastPathComponent else {
            return false
        }
        return receiptName == "sandboxReceipt"
        #endif
    }
    
    struct Info {
        let bundle: Bundle
        /* The version of the Info.plist format */
        public var infoVersion: String? { bundle.object(forInfoDictionaryKey: kCFBundleInfoDictionaryVersionKey as String) as? String }
        /* The name of the executable in this bundle, if any */
        public var executableName: String? { bundle.object(forInfoDictionaryKey: kCFBundleExecutableKey as String) as? String }
        /* The bundle identifier (for CFBundleGetBundleWithIdentifier()) */
        public var identifier: String? { bundle.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String }
        /* The version number of the bundle.  For Mac OS 9 style version numbers (for example "2.5.3d5"), */
        /* clients can use CFBundleGetVersionNumber() instead of accessing this key directly since that */
        /* function will properly convert the version string into its compact integer representation. */
        public var version: String? { bundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String }
        /* The name of the development language of the bundle. */
        public var language: String? { bundle.object(forInfoDictionaryKey: kCFBundleDevelopmentRegionKey as String) as? String }
        /* The human-readable name of the bundle.  This key is often found in the InfoPlist.strings since it is usually localized. */
        public var name: String? { bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String }
        /* Allows an unbundled application that handles localization itself to specify which localizations it has available. */
        public var localizations: String? { bundle.object(forInfoDictionaryKey: kCFBundleLocalizationsKey as String) as? String }
    }
    
    var info: Info { return Info(bundle: base) }
    
}
