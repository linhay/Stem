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
import WebKit
import Combine

@available(iOS 13.0, *)
public class HybridCookieStorage {
    public static let shared = HybridCookieStorage()
    private var cancellable: AnyCancellable?
}

@available(iOS 13.0, *)
public extension HybridCookieStorage {
    
    func listen(_ timeInterval: Int = 1) {
        stop()
        cancellable = NotificationCenter.default
            .publisher(for: .NSHTTPCookieManagerCookiesChanged)
            .debounce(for: .seconds(timeInterval), scheduler: RunLoop.main)
            .compactMap { _ in HTTPCookieStorage.shared.cookies }
            .removeDuplicates()
            .sink { list in
                for item in list {
                    WKWebsiteDataStore.default().httpCookieStore.setCookie(item, completionHandler: nil)
                }
            }
        NotificationCenter.default.post(name: .NSHTTPCookieManagerCookiesChanged, object: nil)
    }
    
    func stop() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    func sync() {
        for item in HTTPCookieStorage.shared.cookies ?? [] {
            WKWebsiteDataStore.default().httpCookieStore.setCookie(item, completionHandler: nil)
        }
    }
    
}

@available(iOS 13.0, *)
public extension HybridCookieStorage {
    
    /// 生成带 Cookies 的请求
    /// - Parameter url: url
    /// - Returns: URLRequest
    func request(with url: URL) async -> URLRequest {
        var request = URLRequest(url: url)
        
        let appCookies = HTTPCookieStorage.shared.cookies(for: url) ?? []
        let webCookies = await WKWebsiteDataStore.default().httpCookieStore.allCookies().filter({ cookie in
            url.host?.hasSuffix(cookie.domain) == true
        })
        
        var set = Set<String>()
        let cookies = (appCookies + webCookies).filter({ set.insert($0.name).inserted })
        
        guard cookies.isEmpty == false else {
            return request
        }
        
        let fields = HTTPCookie.requestHeaderFields(with: cookies)
        if let value = fields["Cookie"] {
            request.addValue(value, forHTTPHeaderField: "Cookie")
        }
        return request
    }
    
    /// 采用JS函数同步 cookie 至 webView
    /// - Parameters:
    ///   - cookies: [HTTPCookie]
    ///   - webView: WKWebView
    @MainActor
    func sync(cookies: [HTTPCookie], into webView: WKWebView) async throws {
        let cookies = cookies.map { cookie in
            [
                "\(cookie.name)=\(cookie.value)",
                "domain=\(cookie.domain)",
                "path=\(cookie.path)",
                "expires=\((cookie.expiresDate?.timeIntervalSince1970 ?? 0) / 1000);"
            ].joined(separator: ";")
        }.map({ "document.cookie = '\($0)'" })
            .joined(separator: "\n")
        _ = try await webView.evaluateJavaScript(cookies)
    }
    
    /// 构造 cookies
    /// - Parameters:
    ///   - name: 名称
    ///   - value: 值
    ///   - domain: 所属域名
    /// - Returns: cookie
    func cookie(name: String, value: String?, domain: String) -> HTTPCookie? {
        var properties: [HTTPCookiePropertyKey: Any] = [:]
        properties[.name] = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        properties[.value] = value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        properties[.path] = "/"
        properties[.version] = "1"
        // 两天有效期
        properties[.maximumAge] = "172800"
        properties[.domain] = domain
        return HTTPCookie(properties: properties)
    }
    
    /// 添加 cookie 至 app 与 hybrid 容器中
    /// - Parameter cookies: cookie 数组
    func add(cookies: [HTTPCookie]) {
        stop()
        defer { listen() }
        cookies
            .forEach { item in
                HTTPCookieStorage.shared.setCookie(item)
            }
    }
    
    /// 从 app 与 hybrid 容器中移除对应域名的 cookie
    /// - Parameter domains: 域名
    @MainActor
    func delete(domains: [String]) async {
        stop()
        defer { listen() }
        
        let http = HTTPCookieStorage.shared
        let website = WKWebsiteDataStore.default()
        
        http.cookies?.filter({ cookie in
            domains.contains(where: { cookie.domain.contains($0) })
        }).forEach({ cookie in
            http.deleteCookie(cookie)
            website.httpCookieStore.delete(cookie)
        })
        
        var records = await website.dataRecords(ofTypes: Set([WKWebsiteDataTypeCookies]))
        records = records.filter({ record in
            domains.contains(where: { record.displayName.contains($0) })
        })
        
        await website.removeData(ofTypes: Set([WKWebsiteDataTypeCookies]), for: records)
    }
    
}
