//
//  File.swift
//  
//
//  Created by linhey on 2023/3/24.
//

import Combine

private var cancellables = Set<AnyCancellable>()

public extension Publisher {
    
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation({ continuation in
            var cancellable: AnyCancellable?
            cancellable = first()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(with: .failure(error))
                    }
                    if let cancellable = cancellable{
                        cancellables.remove(cancellable)
                    }
                }, receiveValue: { value in
                    continuation.resume(with: .success(value))
                })
            if let cancellable {
                cancellables.update(with: cancellable)
            }
        })
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
