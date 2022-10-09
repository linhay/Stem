//
//  File.swift
//  
//
//  Created by linhey on 2022/10/8.
//

import Foundation
import Combine

public final class STFileDownloaderManager {
    
    private var store = [URL: STFileDownloader]()
    private var downloaders = Set<STFileDownloader>()
    private var cancellables = Set<AnyCancellable>()
    private var isStart = false
    
    public var maxConcurrentOperationCount = 6
    
    public init() {}
    
    public func start() {
        isStart = true
        next()
    }
    
    func next() {
        guard isStart else {
            return
        }
        let starts = store.values.filter(\.isStart)
        guard starts.count < maxConcurrentOperationCount else {
            return
        }
        store.values.filter({ !$0.isStart })
            .prefix(maxConcurrentOperationCount - starts.count)
            .forEach { item in
            item.start()
        }
    }
    
    public func add(_ downloader: STFileDownloader) {
        guard let store = store[downloader.downloadURL] else {
            store[downloader.downloadURL] = downloader
            var cancellable: AnyCancellable!
            cancellable = downloader.finishPublisher.sink { [weak self] completion in
                guard let self = self else { return }
                cancellable.cancel()
                self.cancellables.remove(cancellable)
            } receiveValue: { [weak self] downloader in
                guard let self = self else { return }
                self.store[downloader.downloadURL] = nil
                self.next()
            }
            cancellables.update(with: cancellable)
            self.next()
            return
        }
        
        store.progressPublisher.sink { [weak downloader] progress in
            guard let downloader = downloader else { return }
            downloader.progressSubject.send(progress)
        }.store(in: &cancellables)
        
        store.finishPublisher.sink { [weak downloader, weak self] completion in
            guard let downloader = downloader, let self = self else { return }
            switch completion {
            case .failure(let error):
                downloader.finishSubject.send(completion: .failure(error))
            case .finished:
                downloader.finishSubject.send(completion: .finished)
                self.downloaders.remove(downloader)
            }
        } receiveValue: { [weak downloader] cache in
            guard let downloader = downloader else { return }
            do {
                try cache.file.copy(to: downloader.file)
                downloader.finishSubject.send(downloader)
            } catch {
                downloader.finishSubject.send(completion: .failure(error))
            }
        }.store(in: &cancellables)
        
        downloaders.update(with: downloader)
    }
    
}
