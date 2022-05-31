//
//  File.swift
//  
//
//  Created by linhey on 2022/6/1.
//

import AppKit

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias StemColorImage = NSImage
#elseif canImport(UIKit)
import UIKit
public typealias StemColorImage = UIImage
#endif
