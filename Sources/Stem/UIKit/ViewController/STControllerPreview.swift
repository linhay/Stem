//
//  STViewControllerRepresentable.swift
//  
//
//  Created by linhey on 2023/3/2.
//

#if DEBUG && canImport(UIKit) && canImport(SwiftUI)
import UIKit
import SwiftUI

public struct STControllerPreview<T: UIViewController>: UIViewControllerRepresentable {
    
    public let controller: T
    
    public init(_ controller: T) {
        self.controller = controller
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        controller
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
#endif
