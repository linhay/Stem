//
//  MimeTypeTest.swift
//  
//
//  Created by linhey on 2022/4/22.
//

import XCTest
import Stem

class MimeTypeTest: XCTestCase {

    func data(_ name: String) -> Data? {
        return NSDataAsset(name: name, bundle: .module)?.data
    }
    
    func Assert(_ name: String, _ type: Data.FileType) {
        guard let mimeType = data(name)?.st.mimeType else {
            XCTAssert(false, "not found: \(name) \(type)")
            return
        }
        let fileType = mimeType.fileType
        XCTAssert(fileType == type, "\(name): \(fileType) != \(type)")
    }

    func testAudioSet() {
        Data.MimeType.audioSet
            .forEach { mime in
            Assert("fixture.\(mime.ext)", mime.fileType)
        }
//        Assert("fixture-adts-mpeg2.aac", .aac)
//        Assert("fixture-adts-mpeg4-2.aac", .aac)
//        Assert("fixture-adts-mpeg4.aac", .aac)
//        Assert("fixture-id3v2.aac", .aac)
    }
    
    func testApplicationSet() {
        Assert("fixture.msi.cfb", .msi)
        Assert("fixture.tar.lz", .lz)
        Assert("fixture.tar.xz", .xz)
        Assert("fixture.tar.gz", .gz)
        Assert("fixture.tar.Z", .z)
        Data.MimeType.applicationSet
            .filter({ [.msi, .lz, .xz, .gz, .z].contains($0) == false })
            .forEach { mime in
            Assert("fixture.\(mime.ext)", mime.fileType)
        }
    }
    
    func testVideoSet() {
        Assert("fixture.wmv.asf", .wmv)

        Data.MimeType.videoSet
            .filter({ [.wmv].contains($0) == false })
            .forEach { mime in
            Assert("fixture.\(mime.ext)", mime.fileType)
        }
    }
    
    func testImageSet() {
        Assert("fixture-sequence.avif", .avif)
        Assert("fixture-yuv420-8bit.avif", .avif)

        Assert("fixture-heic.heic", .heic)
        Assert("fixture-mif1.heic", .mif1)
        Assert("fixture-msf1.heic", .msf1)
        
        Assert("fixture-little-endian.tif", .tiff)
        Assert("fixture-big-endian.tif", .tiff)
        
        Assert("fixture-itxt.png", .png)
        Assert("fixture-corrupt.png", .png)
        Data.MimeType.imageSet
            .filter({ [.avif].contains($0) == false })
            .filter({ [.heic, .heix, .msf1, .mif1, .hevc, .heic, .hevx].contains($0) == false })
            .forEach { mime in
            Assert("fixture.\(mime.ext)", mime.fileType)
        }
    }
    
}
