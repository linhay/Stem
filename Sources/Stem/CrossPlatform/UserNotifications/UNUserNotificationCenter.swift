//
//  File.swift
//  
//
//  Created by linhey on 2022/11/17.
//

#if canImport(UserNotifications) && canImport(Combine)

import Foundation
import UserNotifications
import Combine

public extension Stem where Base: UNUserNotificationCenter {
    
    func requestAuthorization(options: UNAuthorizationOptions = []) -> any Publisher<Bool, Error> {
        Future { [weak base] promise in
            guard let base = base else {
                promise(.success(false))
                return
            }
            base.requestAuthorization(options: options) { flag, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(flag))
                }
            }
        }
    }
    
}

#endif
