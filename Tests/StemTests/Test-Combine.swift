//
//  File.swift
//  
//
//  Created by linhey on 2022/2/8.
//

import Foundation
import XCTest
import Stem
import Vision
import WebKit

class Test_Combine: XCTestCase {

    @available(macOS 13.0, *)
    func testVNImage() throws {
        let data = try Data(contentsOf: URL(filePath: "/Users/linhey/Downloads/list1.png"))
        guard let image = NSImage(data: data)?.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return
        }
        let ciImage = CIImage(cgImage: image)
        let handler = try VNImageRequestHandler(ciImage: ciImage)
        let request = VNRecognizeTextRequest { request, error in
            request.results?.forEach({ observation in
                guard let observation = observation as? VNRecognizedTextObservation else { return }
                print(observation.topCandidates(1).first?.string)
            })
        }
        request.recognitionLevel = .accurate
        try handler.perform([request])
    }
    
    func testNSOBject() {
//        let obj = NSObject()
//        Timer.publish(every: 1, tolerance: nil, on: .main, in: .common, options: nil).sink { date in
//
//        }.store(in: &obj.st.cancellable)
        
//        Runtime.classList().forEach { cls in
//            print(cls)
//        }
        
        Runtime.print.methods(from: WKWebView.self)
        Runtime.print.methods(from: Runtime.metaclass(from: WKWebView.self)!)
        Runtime.print.ivars(from: WKWebView.self)
        Runtime.print.properties(from: WKWebView.self)
        Runtime.print.protocols(from: WKWebView.self)

//        swizzleGeneralPasteboard()
//        UIPasteboard().setItems([])
    }
    
}


import Foundation

class Test {
    
   static func begin() {
//       RunTime.exchange(new: .init(selector: #selector(UIPasteboard.dxy_setItemProviders(_:localOnly:expirationDate:)),
//                                   class: UIPasteboard.self),
//                        with: .init(selector: #selector(UIPasteboard.setItemProviders(_:localOnly:expirationDate:)),
//                                    class: UIPasteboard.general.classForCoder))
//        Runtime.exchange(selector: #selector(UIPasteboard.setItemProviders(_:localOnly:expirationDate:)),
//                         by: #selector(UIPasteboard.dxy_setItemProviders(_:localOnly:expirationDate:)),
//                         class: UIPasteboard.self)
//
//        Runtime.exchange(selector: #selector(UIPasteboard.setObjects(_:localOnly:expirationDate:)),
//                         by: #selector(UIPasteboard.dxy_setObjects(_:localOnly:expirationDate:)),
//                         class: UIPasteboard.self)
//
//       Runtime.exchange(selector: .init("pasteboardWithName:create:"),
//                         by: #selector(UIPasteboard.dxy_init(name:create:)),
//                         class: UIPasteboard.self,
//                        kind: .class)
//
//        Runtime.exchange(selector: #selector(UIPasteboard.setValue(_:forPasteboardType:)),
//                         by: #selector(UIPasteboard.dxy_setValue(_:forPasteboardType:)),
//                         class: UIPasteboard.self)
//
//       Runtime.exchange(selector: #selector(UIPasteboard.setData(_:forPasteboardType:)),
//                        by: #selector(UIPasteboard.dxy_setData(_:forPasteboardType:)),
//                        class: UIPasteboard.self)
//
//       Runtime.exchange(selector: #selector(UIPasteboard.setItems(_:options:)),
//                        by: #selector(UIPasteboard.dxy_setItems(_:options:)),
//                        class: UIPasteboard.self)
//
//       Runtime.exchange(selector: #selector(UIPasteboard.addItems(_:)),
//                        by: #selector(UIPasteboard.dxy_addItems(_:)),
//                        class: UIPasteboard.self)
    }
    
}
