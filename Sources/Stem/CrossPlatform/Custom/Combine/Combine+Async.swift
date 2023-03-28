//
//  File.swift
//  
//
//  Created by linhey on 2023/3/24.
//

import Combine

private var cancellables = Set<AnyCancellable>()

public extension AnyPublisher {
    
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
    
}
