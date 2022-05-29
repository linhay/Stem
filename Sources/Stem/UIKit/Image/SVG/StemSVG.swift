//
//  File.swift
//  
//
//  Created by linhey on 2022/5/15.
//

import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(CoreGraphics)
import CoreGraphics
#endif



public class StemSVG {
    
   private static let CoreSVG = dlopen("/System/Library/PrivateFrameworks/CoreSVG.framework/CoreSVG", RTLD_NOW)
    
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
    private static let SVGImageRep: NSImageRep.Type? = {
        guard let rep = NSClassFromString("_NSSVGImageRep") as? NSImageRep.Type else {
            return nil
        }
        NSImageRep.registerClass(rep)
        return rep
    }()
    
    private let imageRep: NSImageRep?
    
    public func image() -> NSImage? {
        guard let imageRep = imageRep else {
            return nil
        }
        let image = NSImage(size: size)
        image.addRepresentation(imageRep)
        return image
    }
#endif
    
    private let document: CGSVGDocument
    
    public init?(_ data: Data) {
        guard let document = CGSVGDocument.create(from: data) else {
            return nil
        }
        let CanvasSize: (@convention(c) (CGSVGDocument?) -> CGSize) = Self.load("CGSVGDocumentGetCanvasSize")
        self.size = CanvasSize(document)
        self.document = document
        
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
        if let ImageRep = (Self.SVGImageRep as AnyObject as? NSObjectProtocol),
           let rep = ImageRep
            .perform(.init("alloc"))
            .takeRetainedValue()
            .perform(.init("initWithData:"), with: data)
            .takeUnretainedValue() as? NSImageRep {
            self.imageRep = rep
        } else {
            self.imageRep = nil
        }
#endif
    }
    
    @objc
    private class CGSVGDocument: NSObject {
        
        func load<T>(_ name: String) -> T {
            Self.load(name)
        }
        
        static func load<T>(_ name: String) -> T {
            unsafeBitCast(dlsym(CoreSVG, name), to: T.self)
        }
        
        static func create(from data: Data) -> CGSVGDocument? {
            let method: (@convention(c) (CFData?, CFDictionary?) -> Unmanaged<CGSVGDocument>?) = load("CGSVGDocumentCreateFromData")
            let document = method(data as CFData, nil)?.takeUnretainedValue()
            return document
        }
        
        func draw(in context: CGContext) {
            let method: (@convention(c) (CGContext?, CGSVGDocument?) -> Void) = load("CGContextDrawSVGDocument")
            method(context, self)
        }
        
    }
    
    deinit {
        let method: (@convention(c) (CGSVGDocument?) -> Void) = Self.load("CGSVGDocumentRelease")
        method(document)
    }
    
    private static func load<T>(_ name: String) -> T {
        unsafeBitCast(dlsym(CoreSVG, name), to: T.self)
    }
    
    public let size: CGSize
    
#if canImport(UIKit)
    public func image() -> UIImage? {
        let selector = Selector(("_imageWithCGSVGDocument:"))
        let method = unsafeBitCast(UIImage.self.method(for: selector), to: (@convention(c) (AnyObject, Selector, CGSVGDocument) -> UIImage).self)
        let image = method(UIImage.self, selector, document)
        return image
    }
#endif
    
    public func draw(in context: CGContext) {
        draw(in: context, size: size)
    }
    
    public func draw(in context: CGContext, size target: CGSize) {
        
        var target = target
        
        let ratio = (
            x: target.width / size.width,
            y: target.height / size.height
        )
        
        let rect = (
            document: CGRect(origin: .zero, size: size), ()
        )
        
        let scale: (x: CGFloat, y: CGFloat)
        
        if target.width <= 0 {
            scale = (ratio.y, ratio.y)
            target.width = size.width * scale.x
        } else if target.height <= 0 {
            scale = (ratio.x, ratio.x)
            target.width = size.width * scale.y
        } else {
            let min = min(ratio.x, ratio.y)
            scale = (min, min)
            target.width = size.width * scale.x
            target.height = size.height * scale.y
        }
        
        let transform = (
            scale: CGAffineTransform(scaleX: scale.x, y: scale.y),
            aspect: CGAffineTransform(translationX: (target.width / scale.x - rect.document.width) / 2, y: (target.height / scale.y - rect.document.height) / 2)
        )
        
        context.translateBy(x: 0, y: target.height)
        context.scaleBy(x: 1, y: -1)
        context.concatenate(transform.scale)
        context.concatenate(transform.aspect)
        
        document.draw(in: context)
    }
}
