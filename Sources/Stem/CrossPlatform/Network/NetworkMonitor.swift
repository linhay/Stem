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
import Network
import Combine

final public class NetworkMonitor {
    
    public enum Result {
        case success(NWInterface.InterfaceType)
        case failure
    }
    
    public static let shared = NetworkMonitor()
    
    public private(set) lazy var connectPublisher = pathPublisher.map { path -> Result in
        guard path.status != .unsatisfied,
              let status = [.other, .wifi, .cellular, .loopback, .wiredEthernet].first(where: { path.usesInterfaceType($0) }) else {
            return Result.failure
        }
        return Result.success(status)
    }.eraseToAnyPublisher()
    
    public private(set) lazy var pathPublisher = pathSubject.eraseToAnyPublisher()
    
    private lazy var pathSubject = CurrentValueSubject<NWPath, Never>(monitor.currentPath)
    
    private let queue = DispatchQueue(label: "network.monitor.queue")
    private lazy var monitor = NWPathMonitor()
    
    public init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.pathSubject.send(path)
        }
    }
    
    public func start() {
        stop()
        pathSubject.send(monitor.currentPath)
        monitor.start(queue: queue)
    }
    
    public func stop() {
        monitor.cancel()
    }
}
