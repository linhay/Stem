//
//  File.swift
//  
//
//  Created by linhey on 2022/3/25.
//

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
