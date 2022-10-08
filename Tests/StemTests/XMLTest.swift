//
//  File.swift
//  
//
//  Created by linhey on 2022/10/8.
//

import Foundation
import Stem
import XCTest

class XMLTest: XCTestCase {
    
    func test() {
        let xml = StemXML(contentsOf: "https://www.ximalaya.com/album/3558668.xml")?.parse()
        print(xml)
    }
    
}
