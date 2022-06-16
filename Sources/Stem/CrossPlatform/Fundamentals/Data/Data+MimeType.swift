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

public extension Data {
    
    struct MimeType: Equatable {
        
        public static func == (lhs: Data.MimeType, rhs: Data.MimeType) -> Bool {
            lhs.fileType == rhs.fileType
            && lhs.mime == rhs.mime
            && lhs.ext == rhs.ext
        }
        
        public let fileType: FileType
        public let mime: String
        public let ext: String
        public let condition: ((ClosedRange<Int>) -> [UInt8]) -> Bool
        
        public init?(_ data: Data, in set: [MimeType] = MimeType.all) {
            guard let item = set.first(where: { $0.condition({ data.count > $0.upperBound ? Array(data[$0]) : [] }) }) else {
                return nil
            }
            self = item
        }
        
        public init(_ fileType: FileType, mime: String, ext: String, _ condition: @escaping ((ClosedRange<Int>) -> [UInt8]) -> Bool) {
            self.fileType = fileType
            self.condition = condition
            self.mime = mime
            self.ext = ext
        }
        
        public init(_ fileType: FileType, mime: String, ext: String, _ condition: [UInt8], at: Int) {
            self.init(fileType, mime: mime, ext: ext) { data in
                let bytes = data(at...at+condition.count-1)
                return bytes == condition
            }
        }
        
        public init(_ fileType: FileType, mime: String, ext: String, _ condition: [UInt8]) {
            self.init(fileType, mime: mime, ext: ext, condition, at: 0)
        }
        
        public static let all = imageSet + audioSet + videoSet + applicationSet
        public static let audioSet = [
            mid, mp3,
            // aac,
            m4b, m4a,
            f4a, f4b,
            wav, amr, opus, ogg, flac]
        public static let videoSet = [
            flv,
            m4v, m4p, f4v, f4p,
            avi, wmv, quicktime
        ]
        public static let imageSet = [
            flif, bmp, ico, jpeg, png, gif, webp,
            jxr,
            cr2,
            // cr3,
            tiff, avif,
            mif1, msf1, heic, heix, hevc, hevx
        ]
        public static let applicationSet = [
            sqlite, crx, rpm, nes, msi, mxf, lz, ps, xz,
            ttf, otf, rtf, pdf, exe, dmg, _7z, bz2, gz, rar,
            eot, swf, xpi, z, cab, deb, ar, woff, epub, woff2, zip, tar
        ]
        
        // MARK: - Audio Types
        // public static let aac = MimeType(.aac, mime: "audio/aac", ext: "aac", [0xFF, 0xF1])
        public static let mid = MimeType(.mid, mime: "audio/midi", ext: "mid", [0x4D, 0x54, 0x68, 0x64])
        public static let mp3 = MimeType(.mp3, mime: "audio/mpeg", ext: "mp3") { data in
            (data(0...2) == [0x49, 0x44, 0x33]) || (data(0...1) == [0xFF, 0xFB])
        }
        
        public static let m4a = MimeType(.m4a, mime: "audio/x-m4a", ext: "m4a") { ftypIdentifiable($0) == "M4A" }
        public static let m4b = MimeType(.m4b, mime: "audio/mp4", ext: "m4b") { ftypIdentifiable($0) == "M4B" }
        public static let f4a = MimeType(.f4a, mime: "audio/mp4", ext: "f4a") { ftypIdentifiable($0) == "F4A" }
        public static let f4b = MimeType(.f4b, mime: "audio/mp4", ext: "f4b") { ftypIdentifiable($0) == "F4B" }
        
        public static let wav = MimeType(.wav, mime: "audio/x-wav", ext: "wav") { data in
            (data(0...3) == [0x52, 0x49, 0x46, 0x46]) && (data(8...11) == [0x57, 0x41, 0x56, 0x45])
        }
        public static let amr = MimeType(.opus, mime: "audio/amr", ext: "amr", [0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A])
        public static let opus = MimeType(.opus, mime: "audio/opus", ext: "opus", [0x4F, 0x70, 0x75, 0x73, 0x48, 0x65, 0x61, 0x64], at: 28)
        public static let ogg  = MimeType(.ogg, mime: "audio/ogg", ext: "ogg", [0x4F, 0x67, 0x67, 0x53])
        public static let flac = MimeType(.flac, mime: "audio/x-flac", ext: "flac", [0x66, 0x4C, 0x61, 0x43])
        
        // MARK: - Video Types
        public static let flv = MimeType(.flv, mime: "video/x-flv", ext: "flv", [0x46, 0x4C, 0x56, 0x01])
        
        public static let m4v = MimeType(.m4v, mime: "video/x-m4v", ext: "m4v") { ["M4V", "M4VH", "M4VP"].contains(ftypIdentifiable($0)) }
        public static let m4p = MimeType(.m4p, mime: "video/mp4", ext: "m4p") { ftypIdentifiable($0) == "M4P" }
        public static let f4v = MimeType(.f4v, mime: "video/mp4", ext: "f4v") { ftypIdentifiable($0) == "F4V" }
        public static let f4p = MimeType(.f4p, mime: "video/mp4", ext: "f4p") { ftypIdentifiable($0) == "F4P" }
        
        public static let avi = MimeType(.avi, mime: "video/x-msvideo", ext: "avi") { data in
            (data(0...3) == [0x52, 0x49, 0x46, 0x46]) && (data(8...10) == [0x41, 0x56, 0x49])
        }
        public static let wmv = MimeType(.wmv, mime: "video/x-ms-wmv", ext: "wmv", [0x30, 0x26, 0xB2, 0x75, 0x8E, 0x66, 0xCF, 0x11, 0xA6, 0xD9])
        public static let mp4 = MimeType(.mp4, mime: "video/mp4", ext: "mp4") { data in
            (data(0...2) == [0x00, 0x00, 0x00]
             && (data(3...3) == [0x18] || data(3...3) == [0x20])
             && data(4...7)  == [0x66, 0x74, 0x79, 0x70])
            || (data(0...3)  == [0x33, 0x67, 0x70, 0x35])
            || (data(0...11) == [0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32]
                && data(16...27) == [0x6D, 0x70, 0x34, 0x31, 0x6D, 0x70, 0x34, 0x32, 0x69, 0x73, 0x6F, 0x6D])
            || (data(0...11) == [0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D])
            || (data(0...11) == [0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32])
        }
        public static let quicktime = MimeType(.quicktime, mime: "video/quicktime", ext: "mov") { ftypIdentifiable($0) == "qt" }
        
        // MARK: - Image Types
        /// https://zh.wikipedia.org/wiki/自由无损图像格式
        public static let flif = MimeType(.flif, mime: "image/flif", ext: "flif", [0x46, 0x4C, 0x49, 0x46])
        public static let bmp  = MimeType(.bmp,  mime: "image/bmp", ext: "bmp", [0x42, 0x4D])
        public static let ico  = MimeType(.ico,  mime: "image/x-icon", ext: "ico", [0x00, 0x00, 0x01, 0x00])
        public static let jpeg = MimeType(.jpeg, mime: "image/jpeg", ext: "jpg", [0xFF, 0xD8, 0xFF])
        public static let png  = MimeType(.png,  mime: "image/png", ext: "png", [0x89, 0x50, 0x4E, 0x47])
        public static let gif  = MimeType(.gif,  mime: "image/gif", ext: "gif", [0x47, 0x49, 0x46])
        public static let webp = MimeType(.webp, mime: "image/webp", ext: "webp", [0x57, 0x45, 0x42, 0x50], at: 8)
        public static let jxr  = MimeType(.jxr,  mime: "image/vnd.ms-photo", ext: "jxr", [0x49, 0x49, 0xBC])
        // public static let cr3 = MimeType(.cr3,  mime: "image/x-canon-cr3", ext: "crx") { ftypIdentifiable($0) == "crx" }
        public static let cr2  = MimeType(.cr2,  mime: "image/x-canon-cr2", ext: "cr2") { data in
            tiff.condition(data) && (data(8...9) == [0x43, 0x52])
        }
        public static let tiff = MimeType(.tiff, mime: "image/tiff", ext: "tif") { data in
            return data(0...3) == [0x49, 0x49, 0x2A, 0x00] || data(0...3) == [0x4D, 0x4D, 0x00, 0x2A]
        }
        
        public static let avif = MimeType(.avif, mime: "image/avif", ext: "avif") { ["avif", "avis"].contains(ftypIdentifiable($0)) }
        
        public static let hevc = MimeType(.hevc, mime: "image/heic-sequence", ext: "heic") { ftypIdentifiable($0) == "hevc" }
        public static let hevx = MimeType(.hevx, mime: "image/heic-sequence", ext: "heic") { ftypIdentifiable($0) == "hevx" }
        
        public static let heix = MimeType(.heix, mime: "image/heic", ext: "heix") { ftypIdentifiable($0) == "hevc" }
        public static let heic = MimeType(.heic, mime: "image/heic", ext: "heic") { ftypIdentifiable($0) == "heic" }
        
        public static let mif1 = MimeType(.mif1, mime: "image/heif", ext: "heic") { ftypIdentifiable($0) == "mif1" }
        public static let msf1 = MimeType(.msf1, mime: "image/heif-sequence", ext: "heic") { ftypIdentifiable($0) == "msf1" }
        
        // MARK: - Application Types
        public static let sqlite = MimeType(.sqlite, mime: "application/x-sqlite3", ext: "sqlite", [0x53, 0x51, 0x4C, 0x69])
        public static let crx = MimeType(.crx, mime: "application/x-google-chrome-extension", ext: "crx", [0x43, 0x72, 0x32, 0x34])
        public static let rpm = MimeType(.rpm, mime: "application/x-rpm", ext: "rpm", [0xED, 0xAB, 0xEE, 0xDB])
        public static let nes = MimeType(.nes, mime: "application/x-nintendo-nes-rom", ext: "nes", [0x4E, 0x45, 0x53, 0x1A])
        public static let msi = MimeType(.msi, mime: "application/x-msi", ext: "msi", [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1])
        public static let mxf = MimeType(.mxf, mime: "application/mxf", ext: "mxf", [0x06, 0x0E, 0x2B, 0x34, 0x02, 0x05, 0x01, 0x01, 0x0D, 0x01, 0x02, 0x01, 0x01, 0x02])
        public static let lz  = MimeType(.lz,  mime: "application/x-lzip", ext: "lz", [0x4C, 0x5A, 0x49, 0x50])
        public static let ar  = MimeType(.ar,  mime: "application/x-unix-archive", ext: "ar", [0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E])
        public static let ps  = MimeType(.ps,  mime: "application/postscript", ext: "ps", [0x25, 0x21])
        public static let xz  = MimeType(.xz,  mime: "application/x-xz", ext: "xz", [0xFD, 0x37, 0x7A, 0x58, 0x5A, 0x00])
        public static let ttf = MimeType(.ttf, mime: "application/font-sfnt", ext: "ttf", [0x00, 0x01, 0x00, 0x00, 0x00])
        public static let otf = MimeType(.otf, mime: "application/font-sfnt", ext: "otf", [0x4F, 0x54, 0x54, 0x4F, 0x00])
        public static let rtf = MimeType(.rtf, mime: "application/rtf", ext: "rtf", [0x7B, 0x5C, 0x72, 0x74, 0x66])
        public static let pdf = MimeType(.pdf, mime: "application/pdf", ext: "pdf", [0x25, 0x50, 0x44, 0x46])
        public static let exe = MimeType(.exe, mime: "application/x-msdownload", ext: "exe", [0x4D, 0x5A])
        public static let dmg = MimeType(.dmg, mime: "application/x-apple-diskimage", ext: "dmg", [0x78, 0x01])
        public static let _7z = MimeType(._7z, mime: "application/x-7z-compressed", ext: "7z", [0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C])
        public static let bz2 = MimeType(.bz2, mime: "application/x-bzip2", ext: "bz2", [0x42, 0x5A, 0x68])
        public static let gz  = MimeType(.gz, mime: "application/gzip", ext: "gz", [0x1F, 0x8B, 0x08])
        public static let tar = MimeType(.tar, mime: "application/x-tar", ext: "tar", [0x75, 0x73, 0x74, 0x61, 0x72], at: 257)
        public static let rar = MimeType(.rar, mime: "application/x-rar-compressed", ext: "rar") { data in
            data(0...5) == [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07] && (data(6...6) == [0x0] || data(6...6) == [0x1])
        }
        public static let eot = MimeType(.eot, mime: "application/vnd.ms-fontobject", ext: "eot") { data in
            data(34...35) == [0x4c, 0x50]
            && data(64...79) == Array(repeating: 0x00, count: 16)
            && data(82...82) != [0x00]
        }
        public static let swf = MimeType(.swf, mime: "application/x-shockwave-flash", ext: "swf") { data in
            (data(0...0) == [0x43] || data(0...0) == [0x46]) && (data(1...2) == [0x57, 0x53])
        }
        public static let xpi = MimeType(.xpi, mime: "application/x-xpinstall", ext: "xpi") { data in
            data(0...3) == [0x50, 0x4B, 0x03, 0x04]
            && data(30...49) == [
                0x4D, 0x45, 0x54, 0x41, 0x2D, 0x49, 0x4E, 0x46, 0x2F, 0x6D, 0x6F, 0x7A,
                0x69, 0x6C, 0x6C, 0x61, 0x2E, 0x72, 0x73, 0x61
            ]
        }
        public static let zip = MimeType(.zip, mime: "application/zip", ext: "zip") { data in
            return data(0...1) == [0x50, 0x4B]
            && (data(2...2) == [0x3] || data(2...2) == [0x5] || data(2...2) == [0x7])
            && (data(3...3) == [0x4] || data(3...3) == [0x6] || data(3...3) == [0x8])
        }
        public static let deb = MimeType(.deb, mime: "application/x-deb", ext: "deb", [
            0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E, 0x0A, 0x64, 0x65, 0x62, 0x69,
            0x61, 0x6E, 0x2D, 0x62, 0x69, 0x6E, 0x61, 0x72, 0x79
        ])
        public static let z = MimeType(.z, mime: "application/x-compress", ext: "z") { data in
            data(0...1) == [0x1F, 0xA0] || data(0...1) == [0x1F, 0x9D]
        }
        public static let cab = MimeType(.cab, mime: "application/vnd.ms-cab-compressed", ext: "cab") { data in
            (data(0...3) == [0x4D, 0x53, 0x43, 0x46]) || (data(0...3) == [0x49, 0x53, 0x63, 0x28])
        }
        
        public static let woff = MimeType(.woff, mime: "application/font-woff", ext: "woff") { data in
            data(0...3) == [0x77, 0x4F, 0x46, 0x46]
            && (data(4...7) == [0x00, 0x01, 0x00, 0x00] || data(4...7) == [0x4F, 0x54, 0x54, 0x4F])
        }
        public static let epub = MimeType(.epub, mime: "application/epub+zip",  ext: "epub") { data in
            data(0...3) == [0x50, 0x4B, 0x03, 0x04]
            && data(30...57) == [
                0x6D, 0x69, 0x6D, 0x65, 0x74, 0x79, 0x70, 0x65, 0x61, 0x70, 0x70, 0x6C,
                0x69, 0x63, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x2F, 0x65, 0x70, 0x75, 0x62,
                0x2B, 0x7A, 0x69, 0x70
            ]
        }
        public static let woff2 = MimeType(.woff2, mime: "application/font-woff", ext: "woff2") { data in
            data(0...3) == [0x77, 0x4F, 0x46, 0x32]
            && (data(4...7) == [0x00, 0x01, 0x00, 0x00] || data(4...7) == [0x4F, 0x54, 0x54, 0x4F])
        }
    }
    
    static func isFtyp(_ data: (ClosedRange<Int>) -> [UInt8]) -> Bool {
        guard data(4...7) == [0x66, 0x74, 0x79, 0x70] else {
            return false
        }
        guard let flag = data(8...8).first,
              flag & 0x60 != 0x00 else {
            return false
        }
        return true
    }
    
    static func ftypIdentifiable(_ data: (ClosedRange<Int>) -> [UInt8]) -> String {
        guard isFtyp(data) else {
            return ""
        }
        return String(data: Data(data(8...11)), encoding: .utf8)?.trimmingCharacters(in: .whitespaces) ?? ""
    }
    
    enum FileType: Int, CaseIterable, Equatable, Codable {
        case unknown
        
        public static let videos: [FileType] = [.mp4, .m4v, .m4p, .f4v, .f4p, .avi, .wmv, .flv, .quicktime]
        public static let audios: [FileType] = [.amr, .mp3, .ogg, .flac, .wav, .mid, .m4a, .m4b, .f4a, .f4b, .opus]
        public static let images: [FileType] = [.avif, .jxr, .flif, .pdf, .png, .jpeg, .gif, .webp, .tiff, .bmp, .psd,
                                                .cr2, .cr3, .mif1, .msf1, .heic, .heix, .hevc, .hevx]
        public static let applications: [FileType] = [.z, .ar, .rpm, .deb, .crx, .cab, .xz, .nes, .ps, .eot,
                                                      .ttf, .otf, .woff, .woff2, .rtf, .dmg, .bz2, ._7z, .gz,
                                                      .zip, .xpi, .epub, .ico, .sqlite, .tar, .rar, .gzip, .exe,
                                                      .swf, .lz, .msi, .mxf]
        
        // MARK: - Video Types
        case mp4, m4v, m4p, f4v, f4p, avi, wmv, flv, quicktime
        
        // MARK: - Audio Types
        // case aac
        case amr, mp3, ogg, flac, wav, mid, m4a, m4b, f4a, f4b, opus
        
        // MARK: - Image Types
        case avif, jxr, flif, pdf, png, jpeg, gif, webp, tiff,
             bmp, psd, cr2, cr3, mif1, msf1, heic, heix, hevc, hevx
        
        // MARK: - Application Types
        case z, ar, rpm, deb, crx, cab, xz, nes, ps, eot, ttf,
             otf, woff, woff2, rtf, dmg, bz2, _7z, gz, zip, xpi,
             epub, ico, sqlite, tar, rar, gzip, exe, swf, lz, msi, mxf
    }
    
}

public extension StemValue where Base == Data {
    
    var mimeType: Data.MimeType? { .init(base) }
    var fileType: Data.FileType { Data.MimeType(base)?.fileType ?? .unknown }
    
}
