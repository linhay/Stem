//
//  File.swift
//  
//
//  Created by linhey on 2022/2/8.
//

import Foundation
import XCTest
import Stem

class Test_Combine: XCTestCase {

    func testNSOBject() {
//        let obj = NSObject()
//        Timer.publish(every: 1, tolerance: nil, on: .main, in: .common, options: nil).sink { date in
//
//        }.store(in: &obj.st.cancellable)
        
//        Runtime.classList().forEach { cls in
//            print(cls)
//        }
        
        Runtime.print.methods(from: NSClassFromString("UIWindowSceneGeometryPreferencesIOS")!)
        Runtime.print.ivars(from: NSClassFromString("UIWindowSceneGeometryPreferencesIOS")!)
        Runtime.print.properties(from: NSClassFromString("UIWindowSceneGeometryPreferencesIOS")!)
        Runtime.print.protocols(from: NSClassFromString("UIWindowSceneGeometryPreferencesIOS")!)
    }
    
}
