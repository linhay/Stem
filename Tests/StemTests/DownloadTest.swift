//
//  File.swift
//  
//
//  Created by linhey on 2022/10/8.
//

import Foundation
import Stem
import StemFilePath
import XCTest
import Combine

class DownloadTest: XCTestCase {
    
    let byteFormatter = ByteCountFormatter()
    var cancellables = Set<AnyCancellable>()
    
    func Downloader(url: String, tag: String) -> STFileDownloader {
        let downloader = try! STFileDownloader(downloadURL: .init(stringLiteral: url),
                                               local: .init(sanbox: .cache))
        downloader.progressPublisher.sink { [weak self] progress in
            guard let self = self else { return }
            print("\(tag): \(self.byteFormatter.string(fromByteCount: progress.completed)) / \(self.byteFormatter.string(fromByteCount: progress.total))")
        }.store(in: &cancellables)
        
        downloader.finishPublisher
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { downloader in
                print("\(tag): ", downloader.file.path)
            }).store(in: &cancellables)
        return downloader
    }
    
    func test() {
        let expectation = XCTestExpectation(description: UUID().uuidString)
        let byteFormatter = ByteCountFormatter()
        var cancellables = Set<AnyCancellable>()
        
        for idx in 0...6 {
            let downloader = Downloader(url: "https://audio.xmcdn.com/storages/0346-audiofreehighqps/76/24/GKwRIJIHCwcJAoabAgGpFw3s.m4a",
                                        tag: idx.description)
            downloader.start()
        }
        
        wait(for: [expectation], timeout: 60)
        print(#function)
    }
    

    
    func testManager() {
        let expectation = XCTestExpectation(description: UUID().uuidString)

        let manager = STFileDownloaderManager()
        manager.maxConcurrentOperationCount = 2
        
        let list = [
        "https://audio.xmcdn.com/storages/0346-audiofreehighqps/76/24/GKwRIJIHCwcJAoabAgGpFw3s.m4a",
        "https://audio.xmcdn.com/storages/4182-audiofreehighqps/45/E0/GKwRIW4HAfvsAx88lwGldyRY.m4a",
        "https://audio.xmcdn.com/storages/c118-audiofreehighqps/11/EF/GKwRIJIG-PXeAgPlyAGhu2cp.m4a",
        "https://audio.xmcdn.com/storages/ab1c-audiofreehighqps/EB/10/GKwRINsG78DRAtd-3wGeUmjF.m4a"
        ]
        for url in list {
            manager.add(Downloader(url: url, tag: url.split(separator: "/").last!.description))
        }
        
        manager.start()
        wait(for: [expectation], timeout: 60)
    }
    
}
