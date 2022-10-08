//
//  File.swift
//  
//
//  Created by linhey on 2022/10/8.
//

import Foundation
import CommonCrypto
import Combine

public final class STFileDownloader: NSObject {
    
    public struct Progress {
        public let completed: Int64
        public let total: Int64
    }

    public let downloadURL: URL
    public let local: STFolder
    
    public private(set) lazy var finishPublisher   = finishSubject.eraseToAnyPublisher()
    public private(set) lazy var progressPublisher = progressSubject.dropFirst().eraseToAnyPublisher()
    public private(set) lazy var file = local.file(name: downloadURL.lastPathComponent)
    public private(set) lazy var isStart = false

    private let queue: OperationQueue?
    private var downloadTask: URLSessionDownloadTask?
    
    var finishSubject   = PassthroughSubject<STFileDownloader, Error>()
    var progressSubject = CurrentValueSubject<Progress, Never>(.init(completed: 0, total: 0))
    
    private lazy var urlSession: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: queue)
    private lazy var resumeFile = try! STFolder(sanbox: .temporary).file(name: sha256(downloadURL.absoluteString))
    
    public init(downloadURL: URL, local: STFolder, queue: OperationQueue? = nil) {
        self.downloadURL = downloadURL
        self.local = local
        self.queue = queue
        super.init()
    }
    
    public func start() {
        guard isStart == false else {
            return
        }
        
        isStart = true

        if file.isExist {
            finishSubject.send(self)
            return
        }
        var downloadTask: URLSessionDownloadTask
        if let data = try? resumeFile.data() {
            downloadTask = urlSession.downloadTask(withResumeData: data)
        } else {
            downloadTask = urlSession.downloadTask(with: downloadURL)
        }
        self.downloadTask = downloadTask
        downloadTask.resume()
    }
    
}

private extension STFileDownloader {
    
    func sha256(_ string: String) -> String {
        guard let data = string.data(using: .utf8) else {
            return ""
        }
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash).map({ String(format:"%02x", $0) }).joined()
    }
    
}

extension STFileDownloader: URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard  downloadTask == self.downloadTask else {
            return
        }
        progressSubject.send(Progress(completed: totalBytesWritten, total: totalBytesExpectedToWrite))
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {
            return
        }
        let userInfo = (error as NSError).userInfo
        if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
            try? self.resumeFile.overlay(with: resumeData)
        } else {
            try? self.resumeFile.delete()
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            try STFile(location).move(to: file)
            try? self.resumeFile.delete()
            self.finishSubject.send(self)
        } catch {
            self.finishSubject.send(completion: .failure(error))
        }
    }
    
}
