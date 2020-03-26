//
//  AttributedString+Data.swift
//  Pods-iOS
//
//  Created by 林翰 on 2020/3/26.
//

import UIKit

extension StemValue where Base == Data {

    // http://stackoverflow.com/questions/39248092/nsattributedstring-extension-in-swift-3
    @available(iOS 9.0, *)
    public var attributedString: NSAttributedString? {
        return try? NSAttributedString(data: base,
                                       options: [.documentType: NSAttributedString.DocumentType.html,
                                                 .characterEncoding: String.Encoding.utf8.rawValue],
                                       documentAttributes: nil)
    }

}
