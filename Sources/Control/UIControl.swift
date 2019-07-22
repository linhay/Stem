//
//  Stem
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
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

import UIKit

extension Stem where Base: UIControl {

    /// 添加响应事件
    ///
    /// - Parameters:
    ///   - event: 响应事件类型
    ///   - action: 响应事件
    public func add(for event: UIControl.Event, action: @escaping (_: UIControl) -> ()) {
        guard let selector = base.selector(event: event) else { return }
        UIControl.swizzing
        base.actionStore[event.rawValue] = action
        base.addTarget(base, action: selector, for: event)
    }

    /// 移除响应事件
    ///
    /// - Parameter event: 响应事件类型
    public func remove(for event: UIControl.Event) {
        guard let selector = base.selector(event: event) else { return }
        base.actionStore[event.rawValue] = nil
        base.removeTarget(base, action: selector, for: event)
    }

}

public extension Stem where Base: UIControl {

    /// 上次事件响应时间
    var lastEventTime: TimeInterval {
        get { return getAssociated(associatedKey: UIControl.ActionKey.lastEventTime) ?? 0 }
        set { setAssociated(value: newValue, associatedKey: UIControl.ActionKey.lastEventTime) }
    }

    // 重复点击的间隔
    var eventInterval: TimeInterval {
        get { return getAssociated(associatedKey: UIControl.ActionKey.eventInterval) ?? 0 }
        set { setAssociated(value: newValue, associatedKey: UIControl.ActionKey.eventInterval) }
    }

    // 超时事件
    var timeoutEvent: ((UIControl) -> Void)? {
        get { return getAssociated(associatedKey: UIControl.ActionKey.timeoutEvent) }
        set { setAssociated(value: newValue, associatedKey: UIControl.ActionKey.timeoutEvent) }
    }

    /// 设置超时事件
    /// - Parameter timeoutEvent: 超时事件
    @discardableResult
    func set(timeoutEvent:  ((UIControl) -> Void)?) -> Stem<Base> {
        self.timeoutEvent = timeoutEvent
        return self
    }
}


// MARK: - time
extension UIControl {

    fileprivate static let swizzing: Void = {
        StemRuntime.exchangeMethod(selector: #selector(UIControl.sendAction(_:to:for:)),
                                   replace: #selector(UIControl.stem_control_sendAction(action:to:forEvent:)),
                                   class: UIControl.self)

    }()

    fileprivate struct ActionKey {
        static var actionStore   = UnsafeRawPointer(bitPattern: "control.stem.actionStore".hashValue)!
        static var lastEventTime = UnsafeRawPointer(bitPattern: "control.stem.lastEventTime".hashValue)!
        static var eventInterval = UnsafeRawPointer(bitPattern: "control.stem.eventInterval".hashValue)!
        static var timeoutEvent  = UnsafeRawPointer(bitPattern: "control.stem.timeoutEvent".hashValue)!
    }

    /// 系统响应事件
    fileprivate static var systemActions = Set(arrayLiteral: "_handleShutterButtonReleased:",
                                               "_handleShutterButtonReleased:",
                                               "cameraShutterPressed:",
                                               "_tappedBottomBarCancelButton:",
                                               "_tappedBottomBarDoneButton:",
                                               "recordStart:",
                                               "btnTouchUp:withEvent:")


    @objc fileprivate func stem_control_sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        if st.eventInterval <= 0 || UIControl.systemActions.contains(action.description) {
            self.stem_control_sendAction(action: action, to: target, forEvent: event)
            return
        }

        let t1 = ProcessInfo.processInfo.systemUptime
        if t1 - st.lastEventTime >= st.eventInterval {
            st.lastEventTime = t1
            self.stem_control_sendAction(action: action, to: target, forEvent: event)
            return
        }

        st.timeoutEvent?(self)
    }

}

// MARK: - target
extension UIControl {

    fileprivate var actionStore: [UInt: (_: UIControl) -> Void] {
        get {
            if let value = objc_getAssociatedObject(self,UIControl.ActionKey.actionStore) as? [UInt: (_: UIControl) -> Void] {
                return value
            }else {
                self.actionStore = [:]
                return self.actionStore
            }
        }
        set { objc_setAssociatedObject(self, UIControl.ActionKey.actionStore, newValue as [UInt: (_: UIControl) -> Void], .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    fileprivate func triggerAction(for: UIControl, event: UIControl.Event){
        guard let action = actionStore[event.rawValue] else { return }
        action(self)
    }

    fileprivate func selector(event: UIControl.Event) -> Selector? {
        var selector: Selector?
        switch event.rawValue {
        // Touch events
        case 1 << 0: selector = #selector(touchDown(sender:))
        case 1 << 1: selector = #selector(touchDownRepeat(sender:))
        case 1 << 2: selector = #selector(touchDragInside(sender:))
        case 2 << 2: selector = #selector(touchDragOutside(sender:))
        case 2 << 3: selector = #selector(touchDragEnter(sender:))
        case 2 << 4: selector = #selector(touchDragExit(sender:))
        case 2 << 5: selector = #selector(touchUpInside(sender:))
        case 2 << 6: selector = #selector(touchUpOutside(sender:))
        case 2 << 7: selector = #selector(touchCancel(sender:))
        // UISlider events
        case 2 << 11: selector = #selector(valueChanged(sender:))
        // TV event
        case 2 << 12: selector = #selector(primaryActionTriggered(sender:))
        // UITextField events
        case 2 << 15: selector = #selector(editingDidBegin(sender:))
        case 2 << 16: selector = #selector(editingChanged(sender:))
        case 2 << 17: selector = #selector(editingDidEnd(sender:))
        case 2 << 18: selector = #selector(editingDidEndOnExit(sender:))
        // Other events
        case 4095:       selector = #selector(allTouchEvents(sender:))
        case 983040:     selector = #selector(allEditingEvents(sender:))
        case 251658240:  selector = #selector(applicationReserved(sender:))
        case 4026531840: selector = #selector(systemReserved(sender:))
        case 4294967295: selector = #selector(allEvents(sender:))
        default: selector = nil
        }
        return selector
    }

    @objc fileprivate func touchDown(sender: UIControl) {
        triggerAction(for: sender, event: .touchDown)
    }
    @objc fileprivate func touchDownRepeat(sender: UIControl) {
        triggerAction(for:sender, event: .touchDownRepeat)
    }
    @objc fileprivate func touchDragInside(sender: UIControl) {
        triggerAction(for:sender, event: .touchDragInside)
    }
    @objc fileprivate func touchDragOutside(sender: UIControl) {
        triggerAction(for:sender, event: .touchDragOutside)
    }
    @objc fileprivate func touchDragEnter(sender: UIControl) {
        triggerAction(for:sender, event: .touchDragEnter)
    }
    @objc fileprivate func touchDragExit(sender: UIControl) {
        triggerAction(for:sender, event: .touchDragExit)
    }
    @objc fileprivate func touchUpInside(sender: UIControl) {
        triggerAction(for:sender, event: .touchUpInside)
    }
    @objc fileprivate func touchUpOutside(sender: UIControl) {
        triggerAction(for:sender, event: .touchUpOutside)
    }
    @objc fileprivate func touchCancel(sender: UIControl) {
        triggerAction(for:sender, event: .touchCancel)
    }
    @objc fileprivate func valueChanged(sender: UIControl) {
        triggerAction(for:sender, event: .valueChanged)
    }
    @objc fileprivate func primaryActionTriggered(sender: UIControl) {
        if #available(iOS 9.0, *) {
            triggerAction(for:sender, event: .primaryActionTriggered)
        }
    }
    @objc fileprivate func editingDidBegin(sender: UIControl) {
        triggerAction(for:sender, event: .editingDidBegin)
    }
    @objc fileprivate func editingChanged(sender: UIControl) {
        triggerAction(for:sender, event: .editingChanged)
    }
    @objc fileprivate func editingDidEnd(sender: UIControl) {
        triggerAction(for:sender, event: .editingDidEnd)
    }
    @objc fileprivate func editingDidEndOnExit(sender: UIControl) {
        triggerAction(for:sender, event: .editingDidEndOnExit)
    }
    @objc fileprivate func allTouchEvents(sender: UIControl) {
        triggerAction(for:sender, event: .allTouchEvents)
    }
    @objc fileprivate func allEditingEvents(sender: UIControl) {
        triggerAction(for:sender, event: .allEditingEvents)
    }
    @objc fileprivate func applicationReserved(sender: UIControl) {
        triggerAction(for:sender, event: .applicationReserved)
    }
    @objc fileprivate func systemReserved(sender: UIControl) {
        triggerAction(for:sender, event: .systemReserved)
    }
    @objc fileprivate func allEvents(sender: UIControl) {
        triggerAction(for:sender, event: .allEvents)
    }

}
