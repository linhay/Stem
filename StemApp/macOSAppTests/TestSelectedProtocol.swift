//
//  TestSelectedProtocol.swift
//  macOSTests
//
//  Created by 林翰 on 2020/8/20.
//  Copyright © 2020 linhey.ax. All rights reserved.
//

import XCTest
import Stem

class SelectedItem: SelectableProtocol {

    var selectableModel: SelectableModel = .init(isSelected: false, canSelect: true)
    var index: Int

    init(_ index: Int) {
        self.index = index
    }

}

class SelectedCollection: SelectableCollectionProtocol {

    var selectables: [SelectedItem] = (0...100).map({ SelectedItem($0) })

}

class TestSelectedProtocol: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let list = SelectedCollection()

        list.selectables.forEach { item in
            item.selectedObservable.delegate(on: self) { (self, flag) in
                print("select: \(item.index) - \(flag)")
            }
            item.canSelectObservable.delegate(on: self) { (self, flag) in
                print("select: \(item.index) - \(flag)")
            }
        }

        list.select(at: 2)
        list.select(at: 5)
        list.select(at: 25)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
