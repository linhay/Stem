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

#if canImport(UIKit)
import UIKit

@available(iOS 13, *)
open class SectionDifferenceWrapper<Section: SingleTypeDriveSectionProtocol & SectionProtocol>: SectionWrapperProtocol where Section.Cell.Model: Hashable {
        
    var referenceValue: Section
    open var wrappedSection: Section { referenceValue }
        
    public init(_ section: Section) {
        self.referenceValue = section
    }
    
    open func config(models: [Section.Cell.Model]) {
        let models = models.filter({ Section.Cell.validate($0) })
        guard models.isEmpty == false, referenceValue.isLoaded else {
            referenceValue.config(models: models)
            return
        }

        let difference = models.difference(from: referenceValue.models)
        referenceValue.pick({
            referenceValue.config(models: models)
            for change in difference {
                switch change {
                case let .remove(offset, _, _):
                    referenceValue.delete(at: offset)
                case let .insert(offset, element, _):
                    referenceValue.insert(element, at: offset)
                }
            }
        }, completion: nil)
    }
    
}

@available(iOS 13, *)
public extension SectionProtocol where Self: SingleTypeDriveSectionProtocol, Cell.Model: Hashable {
    
    var differenceWrapper: SectionDifferenceWrapper<Self> { .init(self) }
    
}

#endif
