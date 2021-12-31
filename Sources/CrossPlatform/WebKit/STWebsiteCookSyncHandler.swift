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

#if canImport(WebKit) && canImport(Combine)
import Foundation
import WebKit
import Combine

@available(iOS 13.0, macOS 10.15, *)
open class STWebsiteCookSyncHandler {
    
    public static let shared: STWebsiteCookSyncHandler = STWebsiteCookSyncHandler()
    private let publisher = PassthroughSubject<Void, Never>()
    private var cancellable: AnyCancellable?
    
}

@available(iOS 13.0, macOS 10.15, *)
public extension STWebsiteCookSyncHandler {
    
    func listen() {
        stop()
        NotificationCenter.default.addObserver(self, selector: #selector(task(notification:)), name: .NSHTTPCookieManagerCookiesChanged, object: nil)
        cancellable = publisher
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.sync()
            }
        publisher.send()
    }
    
    func stop() {
        NotificationCenter.default.removeObserver(self, name: .NSHTTPCookieManagerCookiesChanged, object: nil)
        cancellable?.cancel()
        cancellable = nil
    }
    
    func sync() {
        for item in HTTPCookieStorage.shared.cookies ?? [] {
            WKWebsiteDataStore.default().httpCookieStore.setCookie(item, completionHandler: {})
        }
    }
    
}

@available(iOS 13.0, macOS 10.15, *)
private extension STWebsiteCookSyncHandler {
    
    @objc
    func task(notification: Notification) {
        publisher.send()
    }
    
}

@available(iOS 13.0, macOS 10.15, *)
private extension STWebsiteCookSyncHandler {
    
    func cookie(name: String, value: String?, domain: String) -> HTTPCookie? {
        var properties: [HTTPCookiePropertyKey: Any] = [:]
        properties[.name] = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        properties[.value] = value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        properties[.path] = "/"
        properties[.version] = "1"
        //两天有效期
        properties[.maximumAge] = "172800"
        properties[.domain] = domain
        return HTTPCookie(properties: properties)
    }
    
}

#endif
