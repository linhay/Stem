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

@dynamicMemberLookup
public struct SelectableWrapper<ReferenceValue>: SelectableProtocol, WrapperWritableReferenceProtocol {
    
    public var selectableModel: SelectableModel
    public var referenceValue: ReferenceValue {
        get { value }
        set { value = newValue }
    }
    public var value: ReferenceValue

    public init(_ value: ReferenceValue, selectable: SelectableModel = SelectableModel()) {
        self.value = value
        self.selectableModel = selectable
    }
    
}

extension SelectableWrapper: Equatable where ReferenceValue: Equatable {
    
    public static func == (lhs: SelectableWrapper<ReferenceValue>, rhs: SelectableWrapper<ReferenceValue>) -> Bool {
        return lhs.referenceValue == rhs.referenceValue && lhs.selectableModel == rhs.selectableModel
    }
    
}

extension SelectableWrapper: Identifiable where ReferenceValue: Identifiable {
    
    public var id: ReferenceValue.ID { referenceValue.id }
    
}
