//
//  TestVideoViewController.swift
//  Stem_Example
//
//  Created by linhey on 2019/6/28.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import AVKit
import CoreMedia
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

        let generator = AVAssetImageGenerator(asset: asset)
        generator.requestedTimeToleranceBefore = CMTime.zero
        generator.requestedTimeToleranceAfter  = CMTime.zero

        let duration = asset.duration
        let times  = (0...52).map({ CMTime(seconds: Double($0), preferredTimescale: duration.timescale) })
        let values = times.map{ NSValue(time: $0) }

        print(url)

        generator.generateCGImagesAsynchronously(forTimes: values) { (time, cgImage, ti, result, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }

            if let cgImage = cgImage {
                let image = UIImage(cgImage: cgImage)
                let url   = URL(fileURLWithPath: Bundle.main.bundlePath + "/1.png")
                do{
                    try image.jpegData(compressionQuality: 1)?.write(to: url)
                }catch{
                    assertionFailure(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    handle(image)
                }
                return
            }
        }
    }

    
}
