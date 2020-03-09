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

import Foundation

open class EventParsable<Value> {

    open class func value(from notification: Notification) -> Value? {
        return nil
    }

    open class func value(for post: Value?) -> (object: Any?, userInfo: [String: Any]?) {
        return (nil, nil)
    }

}

public class EventToken {
    var objectProtocol: NSObjectProtocol?
    public let name: Notification.Name

    init(name: Notification.Name) {
        self.name = name
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
}

public class Event<Value> {

    public let key: Notification.Name
    public let parsable: EventParsable<Value>.Type?

    public convenience init(key: String, parsable: EventParsable<Value>.Type? = nil) {
        self.init(key: Notification.Name(key), parsable: parsable)
    }

    public init(key: Notification.Name, parsable: EventParsable<Value>.Type? = nil) {
        self.key = key
        self.parsable = parsable
    }

}

public extension Event {

    func accept(_ value: Value?) {
        let (object, userInfo) = parsable?.value(for: value) ?? (nil, nil)
        NotificationCenter.default.post(name: key, object: object, userInfo: userInfo)
    }

    func subscribe(queue: OperationQueue? = nil, using block: @escaping (Value?) -> Void) -> EventToken {
        let token = EventToken(name: key)
        let objectProtocol = NotificationCenter.default.addObserver(forName: key, object: nil, queue: queue) {[weak self] note in
            guard let self = self else {
                return
            }
            block(self.parsable?.value(from: note))
        }
        token.objectProtocol = objectProtocol
        return token
    }
}
