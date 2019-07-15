//
//  TestInputViewController.swift
//  Stem_Example
//
//  Created by linhey on 2019/7/15.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Stem
import SVProgressHUD

class TestInputViewController: BaseViewController {

    let textField = UITextField()
    let textView  = UITextView()
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.st.addSubviews(textView,searchBar,textField)
        textField.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.right.left.equalToSuperview()
            make.height.equalTo(50)
        }

        self.textField.placeholder = "placeholder"
        self.searchBar.placeholder = "placeholder"
        self.textView.st.placeholder = "placeholder"
        
        items.append(TableElement(title: "placeholderLabel", subtitle: "textField - searchBar - textView", event: {
            self.textField.st.placeholderLabel?.textColor = UIColor.red
            self.textField.st.placeholderLabel?.font = UIFont.boldSystemFont(ofSize: 14)

            self.searchBar.st.placeholderLabel?.textColor = UIColor.red
            self.searchBar.st.placeholderLabel?.font = UIFont.boldSystemFont(ofSize: 14)

            self.textView.st.placeholderLabel.textColor = UIColor.red
            self.textView.st.placeholderLabel.font = UIFont.boldSystemFont(ofSize: 14)
        }))

        items.append(TableElement(title: "selectedRange", subtitle: "textField - searchBar", event: {
            var  str = ""
            if let range = self.textField.st.selectedRange {
                str += "textField: \(range.description)"
            }

            if let range = self.searchBar.st.selectedRange {
                str += "\nsearchBar: \(range.description)"
            }

            SVProgressHUD.showSuccess(withStatus: str)
            SVProgressHUD.dismiss(withDelay: 3)
        }))

        items.append(TableElement(title: "leftPadding", subtitle: "textField", event: {
            self.textField.st.leftPadding += 5
        }))

        items.append(TableElement(title: "rightPadding", subtitle: "textField", event: {
            self.textField.st.rightPadding += 5
        }))

    }

}
