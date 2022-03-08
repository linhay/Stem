// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

open class SelectableBox<Value>: MutableReference<Value>, SelectableProtocol {
    
    public var selectableModel: SelectableModel
    
    public init(_ value: Value, selectable: SelectableModel = SelectableModel()) {
        self.selectableModel = selectable
        super.init(value)
    }
    
}

extension SelectableBox: Equatable where Value: Equatable {
    
    public static func == (lhs: SelectableBox<Value>, rhs: SelectableBox<Value>) -> Bool {
        return lhs.value == rhs.value && lhs.selectableModel == rhs.selectableModel
    }
    
}

extension SelectableBox: Identifiable where Value: Identifiable {
    
    public var id: Value.ID { value.id }
    
}
