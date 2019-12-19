//
//  Stem
//
//  github: https://github.com/linhay/Stem
//  Copyright (c) 2019 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import CoreImage

public protocol CIFilterContainerProtocol {
    var filter: CIFilter { get }
}

public extension CIFilterContainerProtocol {

    var outputImage: CIImage? {
        return filter.outputImage
    }

    var name: String {
        return filter.name
    }

    func setDefaults() {
        return filter.setDefaults()
    }

    var attributes: [String: Any] {
        return filter.attributes
    }
}

@propertyWrapper
class CIFilterValueBox<Value> {

    weak var filter: CIFilter?

    var name: String = ""
    var defaultValue: Value?

    var wrappedValue: Value {
        set { filter?.setValue(newValue, forKey: name) }
        get {
            if let value = filter?.value(forKey: name) as? Value {
                return value
            }
            return defaultValue!
        }
    }

    init() {}

    func cofig(filter: CIFilter, name: String, default value: Value) {
        self.filter = filter
        self.defaultValue = value
        self.name = name
    }
}
