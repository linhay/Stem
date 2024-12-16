//
//  File.swift
//  
//
//  Created by linhey on 2023/3/24.
//

import Combine

private var cancellables = Set<AnyCancellable>()

public extension Publisher {
    
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func async(where predicate: (Self.Output) async throws -> Bool) async throws -> Output? {
        return try await self.values.first(where: predicate)
    }
    
    func asyncThrowingStream() -> AsyncThrowingStream<Output, Swift.Error> {
        AsyncThrowingStream<Output, Swift.Error>(Output.self) { continuation in
            let cancellable = self
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            continuation.finish()
                        case let .failure(error):
                            continuation.yield(with: .failure(error))
                        }
                    },
                    receiveValue: { output in
                        continuation.yield(output)
                    }
                )

            continuation.onTermination = { @Sendable _ in
                withExtendedLifetime(cancellable, {})
            }
        }
    }
    
    func asyncStream() -> AsyncStream<Output> where Failure == Never {
        AsyncStream(Output.self) { continuation in
            let cancellable = self
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            continuation.finish()
                        }
                    },
                    receiveValue: { output in
                        continuation.yield(output)
                    }
                )

            continuation.onTermination = { @Sendable _ in
                withExtendedLifetime(cancellable, {})
            }
        }
    }
    
}
