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

public extension UIApplication {
  
 public struct Info {
    /// App版本号
    public let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    /// App构建版本号
    public let bundleVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    public let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? ""
    public let bundleID = Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String ?? ""
  }
  
  struct Path {
    var documentsURL: URL? { return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last }
    var documentsPath: String? { return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first }
    var cachesURL: URL? { return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last }
    var cachesPath: String? { return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first }
    var libraryURL: URL? { return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last }
    var libraryPath: String? { return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first }
  }
  
}

public extension Stem where Base: UIApplication {

  var info: UIApplication.Info { return UIApplication.Info() }
  var path: UIApplication.Path { return UIApplication.Path() }
  
}

// MARK: - open
public extension Stem where Base: UIApplication {
  
  /// 打开链接 (会判断 能否打开)
  ///
  /// - Parameter url: url
  public func open(url: String) {
    guard let str = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
      let url = URL(string: str),
      UIApplication.shared.canOpenURL(url) else{ return }
    unsafeOpen(url: url)
  }
  
  /// 打开链接 (不会判断 能否打开)
  ///
  /// - Parameter url: url
  public func unsafeOpen(url: String) {
    guard let str = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
      let url = URL(string: str) else { return }
    unsafeOpen(url: url)
  }
  
  /// 打开链接 (不会判断 能否打开)
  ///
  /// - Parameter url: url
  public func unsafeOpen(url: URL) {
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, completionHandler: nil)
    } else {
      UIApplication.shared.openURL(url)
    }
  }
  
  
}

