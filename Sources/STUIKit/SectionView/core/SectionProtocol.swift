/// MIT License
///
/// Copyright (c) 2020 linhey
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.

/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import UIKit

public protocol SectionProtocol: class {
    var core: SectionCore? { get set }
    var index: Int { get set }
    var itemCount: Int { get }
    func didSelectItem(at row: Int)
    func deselect(at row: Int, animated: Bool)

    func canMove(at: Int) -> Bool
    func move(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func pick(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)
}

public extension SectionProtocol {

    var index: Int {
        set { core?.index = newValue }
        get { core?.index ?? 0 }
    }

    var isLoaded: Bool { core != nil }

}

public extension SectionProtocol {

    func indexPath(from value: Int?) -> IndexPath? {
        return value.map({ IndexPath(item: $0, section: index) })
    }

    func indexPath(from value: Int) -> IndexPath {
        return IndexPath(item: value, section: index)
    }

    func indexPaths(from value: [Int]) -> [IndexPath] {
        return value.map({ IndexPath(item: $0, section: index) })
    }

}

public extension SectionProtocol {
    func didSelectItem(at row: Int) { }
    func canMove(at: Int) -> Bool { false }
    func move(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { }
}
