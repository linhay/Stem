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

public protocol NoticeProtocol {

    var noticeTokens: NoticeTokens { get }

}

public class Notice<Parsable: NoticeParsable> {

    public let key: Notification.Name

    public convenience init(key: String) {
        self.init(key: Notification.Name(key))
    }

    public init(key: Notification.Name) {
        self.key = key
    }

}

public extension Notice where Parsable: NoticeNotificationParsable {

    convenience init() {
        self.init(key: Parsable.noticeName)
    }

    convenience init(use parsable: Parsable.Type) {
        self.init(key: parsable.noticeName)
    }

}

public extension Notice where Parsable: NoticeCustomParsable {

    convenience init() {
        self.init(key: Notification.Name(Parsable.noticeName))
    }

    convenience init(use parsable: Parsable.Type) {
        self.init(key: parsable.noticeName)
    }

}

public extension Notice where Parsable: NoticeType.Void {

    func accept() {
        NotificationCenter.default.post(name: key, object: nil)
    }

    func subscribe(by object: NSObject, queue: OperationQueue? = nil, using block: @escaping () -> Void) {
        let callback: (NoticeType.Void) -> Void = { _ in block() }
        subscribe(by: object, queue: queue, using: callback)
    }

    func subscribe(by object: NoticeProtocol, queue: OperationQueue? = nil, using block: @escaping () -> Void) {
        let callback: (NoticeType.Void) -> Void = { _ in block() }
        subscribe(by: object, queue: queue, using: callback)
    }

}

public extension Notice {

    func accept(_ parsable: Parsable) {
        let (object, userInfo) = parsable.notification
        NotificationCenter.default.post(name: key, object: object, userInfo: userInfo)
    }

    func subscribe(by object: NSObject, queue: OperationQueue? = nil, using block: @escaping (Parsable) -> Void) {
        let token = subscribe(queue: queue, using: block)
        let key = "com.linhey.stem.notice.tokens"
        if let tokens = object.st.getAssociated(for: key) as NoticeTokens? {
            token.disposed(tokens)
            return
        }
        let tokens = NoticeTokens()
        token.disposed(tokens)
        object.st.setAssociated(value: tokens, for: key)
    }

    func subscribe(by object: NoticeProtocol, queue: OperationQueue? = nil, using block: @escaping (Parsable) -> Void) {
        subscribe(queue: queue, using: block).disposed(object.noticeTokens)
    }

    private func subscribe(queue: OperationQueue? = nil, using block: @escaping (Parsable) -> Void) -> NoticeToken {
        let token = NoticeToken(name: key)
        token.objectProtocol = NotificationCenter.default.addObserver(forName: key, object: nil, queue: queue) { note in
            block(Parsable(from: note))
        }
        return token
    }
}
