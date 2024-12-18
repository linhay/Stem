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

@dynamicMemberLookup
open class STLayerView<Layer: CALayer>: UIView {

    open override class var layerClass: AnyClass {
        return Layer.self
    }
    
    open var wrappedValue: Layer { self.layer as! Layer }

    open subscript<T>(dynamicMember keyPath: KeyPath<Layer, T>) -> T {
        let layer = layer as! Layer
        return layer[keyPath: keyPath]
    }
    
    open subscript<T>(dynamicMember keyPath: WritableKeyPath<Layer, T>) -> T {
        get {
            let layer = layer as! Layer
            return layer[keyPath: keyPath]
        }
        set {
            var layer = layer as! Layer
            layer[keyPath: keyPath] = newValue
        }
    }
    
    open subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<Layer, T>) -> T {
        get {
            let layer = layer as! Layer
            return layer[keyPath: keyPath]
        }
        set {
            let layer = layer as! Layer
            layer[keyPath: keyPath] = newValue
        }
    }
    
}
#endif
