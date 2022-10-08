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
        guard let xml = StemXML(contentsOf: "https://www.ximalaya.com/album/3558668.xml")?.parse() else {
            return
        }
        let item = xml["channel"].collection(prefix: "itunes")
        print(item)
    }
    
}
