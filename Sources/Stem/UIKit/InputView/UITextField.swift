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
import Combine

public extension Stem where Base: UITextField {
    
    var selectedRange: NSRange? {
        guard let selectedTextRange = base.selectedTextRange else { return nil }
        let location = base.offset(from: base.beginningOfDocument, to: selectedTextRange.start)
        let length = base.offset(from: selectedTextRange.start, to: selectedTextRange.end)
        return NSRange(location: location, length: length)
    }
    
}

// MARK: - Padding
public extension Stem where Base: UITextField {

    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification, object: base)
            .compactMap { $0.object as? UITextField }
            .filter { $0.markedTextRange == nil }
            .map(\.text)
            .eraseToAnyPublisher()
    }
    
    /// 字数限制
    /// - Parameter count: 字数限制
    /// - Parameter willExceedLimit: 超出限制时回调
    /// - Returns: Cancellable
    func countLimit(_ count: Int, exceedLimit: (() -> Void)? = nil) -> Cancellable {
        textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak base] text in
                guard let text = text else {
                    return
                }
                guard text.count > count else {
                    return
                }
                exceedLimit?()
                base?.text = String(text.prefix(count))
            }
    }

}
#endif
