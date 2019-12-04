//
//  TestVideoViewController.swift
//  Stem_Example
//
//  Created by linhey on 2019/6/28.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import AVKit
import Stem

class TestVideoViewController: BaseViewController {

    let imageView = UIImageView().then { (item) in
        item.contentMode = UIView.ContentMode.center
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(imageView)
        imageView.layer.masksToBounds = true
        imageView.do { (item) in
            item.snp.makeConstraints({ (make) in
                make.top.left.equalToSuperview().offset(8)
                make.bottom.right.equalToSuperview().offset(-8)
            })
        }

        items.append(TableElement(title: "取帧", subtitle: "") { [weak self] in
            self?.test(handle: { [weak self] (image) in
                guard let base = self else { return }
                base.imageView.image = image
            })
        })
    }

}

extension TestVideoViewController {

    func test(handle: @escaping (UIImage) -> Void) {
        let url       = URL(fileURLWithPath: Bundle.main.bundlePath + "/test-video.mp4")
        let asset     = AVAsset(url: url)
        asset.st.frames(seconds: (0...52).map({ TimeInterval($0) }), success: handle)
    }

    
}
