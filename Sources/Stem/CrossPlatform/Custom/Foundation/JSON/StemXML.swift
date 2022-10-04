//
//  File.swift
//  
//
//  Created by linhey on 2022/10/5.
//

import Foundation
import Stem
import XCTest

class Test_XML: XCTestCase {
    
    func test() {
        let data = NSData(contentsOf: URL(string: "https://www.ximalaya.com/album/3558668.xml")!)
        let xml = StemXML(parser: .init(data: data! as Data)).parse()
        print(xml.stringValue)
    }
    
}
