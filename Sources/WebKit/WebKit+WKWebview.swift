//
//  DXYUtilWrapper+WKWebview.swift
//  iDxyer
//
//  Created by 林翰 on 2019/12/9.
//

import WebKit

extension DXYUtilWrapper where Base: WKWebView {

    public func load(_ url: URL) {
        if url.isFileURL {
            // allowingReadAccessTo: 授权路径, 真机上需要赋予相应路径权限, html才可加载相应路径资源文件
            base.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else {
            base.load(URLRequest(url: url))
        }
    }

}
