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

import UIKit

class KeyboardStateManager {

    private static let shared = KeyboardStateManager(state: .master)
    private static let syncNotificationName = Notification.Name("KeyboardStateManager.syncName")

    private enum State {
        case master
        case slave
    }

    private(set) var frame: CGRect = .zero {
        didSet {
            guard frame != oldValue else {
                return
            }
            switch state {
            case .master:
                NotificationCenter.default.post(name: KeyboardStateManager.syncNotificationName, object: frame)
            case .slave:
                frameChanged.call(frame)
            }
        }
    }

    let frameChanged = Delegate<CGRect, Void>()

    convenience init() {
        self.init(state: .slave)
    }

    private let state: State

    private init(state: State) {
        self.state = state
        switch state {
        case .master:
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        case .slave:
            self.frame = KeyboardStateManager.shared.frame
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: KeyboardStateManager.syncNotificationName, object: nil)
        }
    }

}

extension KeyboardStateManager {

    static func startListening() {
        _ = Self.shared
    }

}

private extension KeyboardStateManager {

    func keyboardEndFrame(_ userInfo: [AnyHashable: Any]) -> CGRect {
        return (userInfo[UIResponder.keyboardFrameEndUserInfoKey]  as? CGRect) ?? .zero
    }

    @objc
    func syncFromMaster(_ notification: Notification) {
        frame = notification.object as? CGRect ?? .zero
    }

    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        frame = keyboardEndFrame(userInfo)
    }

    @objc
    func keyboardWillHide(_ notification: Notification) {
        frame = .zero
    }

    @objc
    func keyboardDidShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        frame = keyboardEndFrame(userInfo)
    }

}
