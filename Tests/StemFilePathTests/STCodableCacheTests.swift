//
//  STCodableCacheTests.swift
//  
//
//  Created by linhey on 2023/3/12.
//
import XCTest
import StemFilePath

final class STCodableCacheTests: XCTestCase {

    private var fileManager: FileManager!
    private var cache: STCodableCache<Int>!
    private let cacheKey = "test_cache"
    private let cacheData = 42

    override func setUp() {
        super.setUp()
        do {
            fileManager = FileManager.default
            let file = try STFolder(sanbox: .document).file(name: cacheKey)
            cache = STCodableCache<Int>(file: file, default: .init(cacheData))
            cache.autoconnect()
        } catch {
            XCTAssertFalse(true)
        }
    }

    override func tearDown() {
        try? fileManager.removeItem(at: cache.file?.url ?? URL(fileURLWithPath: ""))
        super.tearDown()
    }

    func testSetValue() {
        let expected = 100
        cache.wrappedValue = expected
        XCTAssertEqual(cache.wrappedValue, expected)
    }

    func testReadValueFromCache() throws {
        let expected = cacheData
        let actual = try XCTUnwrap(STCodableCache.value(file: cache.file!, decoder: cache.decoder!))
        XCTAssertEqual(actual, expected)
    }

    func testCacheExpiration() throws {
        let expirationDate = Date().addingTimeInterval(-3600)
        let expiredCache = STCodableCache<Int>.Entry(value: 123, expirationDate: expirationDate)
        try cache.save(entry: expiredCache, to: cache.file)
        XCTAssertNil(STCodableCache.value(file: cache.file!, decoder: cache.decoder!))
    }
}
