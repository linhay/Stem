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

public struct STKeyboardInfo: Equatable {
    
    public enum Event {
        case keyboardWillShow
        case keyboardWillHide
        case keyboardDidShow
        case keyboardWillChangeFrame
        case keyboardDidChangeFrame
    }
    
    public internal(set) var event: Event
    public internal(set) var stardFrame: CGRect
    public internal(set) var endFrame: CGRect
    public internal(set) var animationDuration: TimeInterval
    public internal(set) var animationCurve: UIView.AnimationCurve
    
    init() {
        event = .keyboardDidChangeFrame
        stardFrame = .zero
        endFrame = .zero
        animationDuration = 0.25
        animationCurve = .easeInOut
    }
    
    init(event: Event, notification: Notification) {
        self.event = event
        self.stardFrame = notification.keyboardFrameBegin ?? .zero
        self.endFrame = notification.keyboardFrameEnd ?? .zero
        self.animationDuration = notification.keyboardAnimationDuration ?? 0.25
        self.animationCurve = notification.keyboardAnimationCurve ?? .easeInOut
    }
}

extension STKeyboardInfo {
    
    public var animationOptions: UIView.AnimationOptions {
        return animationCurve.animationOptions
    }
}

extension Notification {
    
    var keyboardFrameBegin: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    var keyboardFrameEnd: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    var keyboardAnimationDuration: TimeInterval? {
        return userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
    }
    
    var keyboardAnimationCurve: UIView.AnimationCurve? {
        return (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt).flatMap {
            UIView.AnimationCurve.init(rawValue: Int($0))
        }
    }
    
}

extension UIView.AnimationCurve {
    
    var animationOptions: UIView.AnimationOptions {
        switch self {
        case .easeInOut:
            return .curveEaseInOut
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .linear:
            return .curveLinear
        default:
            return .curveEaseInOut
        }
    }
}


public class STKeyboardManager {
    
    private enum State {
        case master
        case slave
    }
    
    private static let shared = STKeyboardManager(state: .master)
    
    @available(iOS, introduced: 8.0, deprecated: 13.0, message: "No longer supported; use keyboardInfoPublisher")
    public let frameChanged = Delegate<CGRect, Void>()
    
    private let keyboardInfoSubject: CurrentValueSubject<STKeyboardInfo, Never> = .init(.init())
    private var slaveCancellable: AnyCancellable?
    
    public convenience init() {
        self.init(state: .slave)
    }
    
    private let state: State
    
    private init(state: State) {
        self.state = state
        switch state {
        case .master:
            let center = NotificationCenter.default
            center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            center.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
            center.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            center.addObserver(self, selector: #selector(keyboardDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        case .slave:
            slaveCancellable = STKeyboardManager.shared.keyboardInfoPublisher.sink { [weak self] info in
                guard let self = self else { return }
                self.keyboardInfoSubject.send(info)
                self.frameChanged.call(info.endFrame)
            }
        }
    }
}

extension STKeyboardManager {
    
    public static func startListening() {
        _ = STKeyboardManager.shared
    }
    
    public static func getUIRemoteKeyboardWindow() -> UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if let cls = NSClassFromString("UIRemoteKeyboardWindow"), window.isKind(of: cls) {
                return window
            }
        }
        return nil
    }
}

extension STKeyboardManager {
    
    public var keyboardInfoPublisher: AnyPublisher<STKeyboardInfo, Never> {
        keyboardInfoSubject.eraseToAnyPublisher()
    }
    
    public var keyboardInfo: STKeyboardInfo {
        keyboardInfoSubject.value
    }
    
    public var frame: CGRect {
        keyboardInfo.endFrame
    }
}

extension STKeyboardManager {
    
    public private(set) static var lastKeybordFrame = CGRect.zero
    
    public var lastKeybordFrame: CGRect {
        STKeyboardManager.lastKeybordFrame
    }
    
    public private(set) static var hasUIRemoteKeyboardWindow = false
    
    public var hasUIRemoteKeyboardWindow: Bool {
        STKeyboardManager.hasUIRemoteKeyboardWindow
    }
}

// MARK: Only for master
private extension STKeyboardManager {
    
    @objc func keyboardDidChangeFrame(_ notification: Notification) {
        
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        let keyboardInfo = STKeyboardInfo(event: .keyboardWillChangeFrame, notification: notification)
        keyboardInfoSubject.send(keyboardInfo)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardInfo = STKeyboardInfo(event: .keyboardWillShow, notification: notification)
        keyboardInfoSubject.send(keyboardInfo)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        var keyboardInfo = STKeyboardInfo(event: .keyboardWillHide, notification: notification)
        // 简化键盘隐藏时 endFrame 并不为 0
        keyboardInfo.endFrame.size.height = 0
        keyboardInfoSubject.send(keyboardInfo)
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        let keyboardInfo = STKeyboardInfo(event: .keyboardDidShow, notification: notification)
        keyboardInfoSubject.send(keyboardInfo)
        STKeyboardManager.lastKeybordFrame = keyboardInfo.endFrame
        
        if STKeyboardManager.getUIRemoteKeyboardWindow() != nil {
            STKeyboardManager.hasUIRemoteKeyboardWindow = true
        }
    }
}

#endif

