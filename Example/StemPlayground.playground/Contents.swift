//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Stem

class MyViewController : UIViewController {

    let sublayer = CAGradientLayer()

    override func loadView() {
        let view = UIView()
        sublayer.st.inset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        sublayer.colors = [UIColor.red,UIColor.blue]
        sublayer.startPoint = CGPoint(x: 0, y: 0)
        sublayer.endPoint = CGPoint(x: 1, y: 1)
//sublayer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        sublayer.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(sublayer)
        view.backgroundColor = .white
        self.view = view
    }

}


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
