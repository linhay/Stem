//
//  File.swift
//  
//
//  Created by linhey on 2022/2/8.
//

import Foundation

public extension Bundle {
    
    var isSandbox: Bool {
        #if targetEnvironment(simulator)
        return true
        #endif
        
        guard let receiptName = self.appStoreReceiptURL?.lastPathComponent else {
            return false
        }
        return receiptName == "sandboxReceipt"
    }
    
}
