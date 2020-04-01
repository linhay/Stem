/// MIT License
///
/// Copyright (c) 2020 linhey
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.

/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import Foundation

public extension Data {
    
    enum MimeType: Int {
        // MARK: - Audio Types
        case amr
        case mp3
        case ogg
        case flac
        case wav
        case mid
        case m4a
        case opus
        
        // MARK: - Image Types
        case png
        case jpeg
        case gif
        case webp
        case tiff
        case bmp
        case psd
        
        // MARK: - Application Types
        case ico
        case sqlite
        case tar
        case rar
        case gzip
        case bz2
        
        case unknown
        
        init(data: Data) {
            
            func matches(bytes: [UInt8], range: CountableClosedRange<Int>? = nil) -> Bool {
                if let range = range {
                    guard range.upperBound > bytes.count else {
                        return false
                    }
                    return Array(data.st.bytes[range]) == bytes
                } else {
                    return Array(data.st.bytes[0...(bytes.count - 1)]) == bytes
                }
            }
            
            if matches(bytes: [0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A]) {
                self = .amr
            } else if matches(bytes: [0x49, 0x44, 0x33]) || matches(bytes: [0xFF, 0xFB]) {
                self = .mp3
            } else if matches(bytes: [0x4F, 0x67, 0x67, 0x53]) {
                self = .ogg
            } else if matches(bytes: [0x66, 0x4C, 0x61, 0x43]) {
                self = .flac
            } else if matches(bytes: [0x52, 0x49, 0x46, 0x46]) && matches(bytes: [0x57, 0x41, 0x56, 0x45], range: 8...11) {
                self = .wav
            } else if matches(bytes: [0x4D, 0x54, 0x68, 0x64]) {
                self = .mid
            } else if matches(bytes: [0x4D, 0x34, 0x41, 0x20]) || matches(bytes: [0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x41], range: 4...10) {
                self = .m4a
            } else if matches(bytes: [0x4F, 0x70, 0x75, 0x73, 0x48, 0x65, 0x61, 0x64], range: 28...35) {
                self = .opus
            } else if matches(bytes: [0x89, 0x50, 0x4E, 0x47]) {
                self = .png
            } else if matches(bytes: [0xFF, 0xD8, 0xFF]) {
                self = .jpeg
            } else if matches(bytes: [0x47, 0x49, 0x46]) {
                self = .gif
            } else if matches(bytes: [0x57, 0x45, 0x42, 0x50], range: 8...11) {
                self = .webp
            } else if matches(bytes: [0x49, 0x49, 0x2A, 0x00]) || matches(bytes: [0x4D, 0x4D, 0x00, 0x2A]) {
                self = .tiff
            } else if matches(bytes: [0x42, 0x4D]) {
                self = .bmp
            } else if matches(bytes: [0x38, 0x42, 0x50, 0x53]) {
                self = .psd
            } else if matches(bytes: [0x00, 0x00, 0x01, 0x00]) {
                self = .ico
            } else if matches(bytes: [0x53, 0x51, 0x4C, 0x69]) {
                self = .sqlite
            } else if matches(bytes: [0x75, 0x73, 0x74, 0x61, 0x72], range: 257...261) {
                self = .tar
            } else if  matches(bytes: [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07]) && (matches(bytes: [0x0], range: 6...6) || matches(bytes: [0x1], range: 6...6)) {
                self = .rar
            } else if matches(bytes: [0x1F, 0x8B, 0x08]) {
                self = .gzip
            } else if matches(bytes: [0x42, 0x5A, 0x68]) {
                self = .bz2
            } else {
                self = .unknown
            }
        }
    }
    
}

public
extension StemValue where Base == Data {
    
    var mimeType: Data.MimeType { Data.MimeType(data: base) }
    
}
