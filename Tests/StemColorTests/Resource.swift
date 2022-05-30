//
//  File.swift
//  
//
//  Created by linhey on 2022/5/30.
//

#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif

struct Resource {
    
    static func data(for name: String) -> Data {
        NSDataAsset(name: name, bundle: .module)!.data
    }
    
    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    static func image(for name: String) -> NSImage {
        NSImage(data: data(for: name))!
    }
    static var jpg: NSImage { image(for: "fixture.jpg") }
    static var png: NSImage { image(for: "fixture.png") }
    static var svg: NSImage { image(for: "fixture.svg") }
    #elseif canImport(UIKit)
    static func image(for name: String) -> UIImage {
        UIImage(data: data(for: name))!
    }
    static var jpg: UIImage { image(for: "fixture.jpg") }
    static var png: UIImage { image(for: "fixture.png") }
    static var svg: UIImage { image(for: "fixture.svg") }
    #endif
    
}
