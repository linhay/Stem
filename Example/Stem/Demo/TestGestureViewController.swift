//
//  TestButtonViewController.swift
//  Stem_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Stem
import SVProgressHUD

class TestGestureViewController: BaseViewController {
    
    
    let testView: UIView = {
        let item = UIView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.backgroundColor = UIColor.blue
        return item
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(testView)
        
        testView.do { (item) in
            item.snp.makeConstraints({ (make) in
                make.center.equalTo(self.contentView.snp.center)
                make.width.height.equalTo(200)
            })
        }
        
        items.append(TableElement(title: "UITapGestureRecognizer",
                                  subtitle: "testView.st.set(tap: ((UITapGestureRecognizer) -> Void)?)") { [weak self] in
                                    guard let base = self else { return }
                                    if base.testView.st.tapGestureRecognizer == nil {
                                        base.testView.st.setTapGesture({ (ges) in
                                            SVProgressHUD.showSuccess(withStatus: "Tap: " + ges.location(in: base.testView).debugDescription)
                                        })
                                    }else{
                                        base.testView.st.setTapGesture(nil)
                                    }
        })
        
        items.append(TableElement(title: "UIPanGestureRecognizer",
                                  subtitle: "testView.st.set(pan: ((UIPanGestureRecognizer) -> Void)?)") { [weak self] in
                                    guard let base = self else { return }
                                    if base.testView.st.panGestureRecognizer == nil {
                                        base.testView.st.setPanGesture({ (ges) in
                                            SVProgressHUD.showSuccess(withStatus: "Pan: " + ges.location(in: base.testView).debugDescription)
                                        })
                                    }else{
                                        base.testView.st.setPanGesture(nil)
                                    }
        })

        items.append(TableElement(title: "UITapGestureRecognizer",
                                  subtitle: "testView.st.set(tap: ((UITapGestureRecognizer) -> Void)?)") { [weak self] in
                                    guard let base = self else { return }
                                    let ges = STGestureRecognizer()
                                    ges.add(for: .began) { (_, state) in
                                        print(state.debugDescription)
                                    }
                                    ges.add(for: .cancelled) { (_, state) in
                                        print(state.debugDescription)
                                    }
                                    ges.add(for: .changed) { (_, state) in
                                        print(state.debugDescription)
                                    }
                                    ges.add(for: .ended) { (_, state) in
                                        print(state.debugDescription)
                                    }
                                    ges.add(for: .failed) { (_, state) in
                                        print(state.debugDescription)
                                    }
                                    ges.add(for: .possible) { (_, state) in
                                        print(state.debugDescription)
                                    }
                                    ges.add(for: .recognized) { (_, state) in
                                        print(state.debugDescription)
                                    }
                                    base.testView.addGestureRecognizer(ges)
        })
    }
    
}
