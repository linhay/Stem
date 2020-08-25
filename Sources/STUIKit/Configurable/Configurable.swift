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

public protocol ConfigurableView: UIView {
    associatedtype Model
    func config(_ model: Model)
    static func preferredSize(model: Model?) -> CGSize
    func preferredSize(model: Model?) -> CGSize
}

public extension ConfigurableView {

    func preferredSize(model: Model?) -> CGSize {
        Self.preferredSize(model: model)
    }

}

public extension ConfigurableView where Model == Void {
    func config(_ model: Model) { }

    static func preferredSize() -> CGSize {
        preferredSize(model: nil)
    }

    func preferredSize() -> CGSize {
        Self.preferredSize(model: nil)
    }
}

public protocol ConfigurableCollectionCell: UIView {
    associatedtype Model
    func config(_ model: Model)
    static func preferredSize(collectionView: UICollectionView, model: Model?) -> CGSize
}

public extension ConfigurableCollectionCell where Model == Void {

    func config(_ model: Model) { }

    static func preferredSize(collectionView: UICollectionView) -> CGSize {
        preferredSize(collectionView: collectionView, model: nil)
    }

}

public protocol ConfigurableTableCell: UIView {
    associatedtype Model
    func config(_ model: Model)
    static func preferredSize(tableView: UITableView, model: Model?) -> CGSize
}

public extension ConfigurableTableCell where Model == Void {

    func config(_ model: Model) { }

    static func preferredSize(tableView: UITableView) -> CGSize {
        preferredSize(tableView: tableView, model: nil)
    }

}
