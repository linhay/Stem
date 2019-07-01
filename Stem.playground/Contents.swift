//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import Stem


class MyViewController : UIViewController {

    override func loadView() {
       let image = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100)).image { (ctx) in
            let ctx = ctx.cgContext
            let path = UIBezierPath(rect: CGRect(x: 20,y: 20,width: 80,height: 80))
            UIColor.blue.with(alpha: 0.5).setFill()
            path.fill()
        ctx.draw(UIImage(color: UIColor.red.with(alpha: 0.5)).cgImage!, in: CGRect(x: 0, y: 0, width: 80, height: 80))
        }
        self.view = UIImageView(image: image)
    }
}

PlaygroundPage.current.liveView = MyViewController()



